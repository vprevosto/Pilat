open Cil_types
open Cil_datatype
open Cil

let dkey_fundec = Mat_option.register_category "pilat_vis:fundec"

(** Returns the varinfos used in the block in argument *)
let varinfo_registerer block = 
  let vinfos = ref Cil_datatype.Varinfo.Set.empty in
  
  let visitor = 
    object
      
      inherit Visitor.frama_c_inplace
      method! vvrbl v = 
	let () = vinfos := Varinfo.Set.add v !vinfos
	in
	SkipChildren      
      method! vstmt s = 
	match s.skind with 
	  If _ -> SkipChildren 
	| _ -> DoChildren
    end 
  in
  let () = 
    ignore (Cil.visitCilBlock (visitor :> cilVisitor) block)
  in
  !vinfos

let stmt_init_table = Stmt.Hashtbl.create 42

let register_stmt = Stmt.Hashtbl.add stmt_init_table 

class fundec_updater prj = 
object
  inherit (Visitor.frama_c_copy prj)
  method! vfunc fundec = 
    List.iter 
      (fun ref_stmt -> 
	try 
	  let new_stmtkind = Stmt.Hashtbl.find stmt_init_table ref_stmt
	  in

	  
	  let new_stmt = Cil.mkStmtCfg ~before:false ~new_stmtkind ~ref_stmt 
	  in
	  	  
	  let () = 
	    Mat_option.debug ~dkey:dkey_fundec "Adding %a to the CFG before %a" 
	      Printer.pp_stmt new_stmt
	      Printer.pp_stmt ref_stmt
	  in
	  
	  new_stmt.ghost <- true;
	  let rec fundec_stmt_zipper left right = 
	    match right with
	      [] -> assert false
	    | hd :: tl -> 
	      if Stmt.equal hd ref_stmt
	      then fundec.sbody.bstmts <- ((List.rev left) @ (new_stmt:: right))
	      else fundec_stmt_zipper ((List.hd right)::left) (List.tl right)
	  in
	    
	  fundec_stmt_zipper [] fundec.sbody.bstmts 
	with 
	  Not_found -> ()
      )
      fundec.sallstmts;
    ChangeDoChildrenPost (fundec,(fun i -> i))
     
end
