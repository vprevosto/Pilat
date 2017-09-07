(**************************************************************************)
(*                                                                        *)
(*  This file is part of Frama-C.                                         *)
(*                                                                        *)
(*  Copyright (C) 2007-2016                                               *)
(*    CEA (Commissariat à l'énergie atomique et aux énergies              *)
(*         alternatives)                                                  *)
(*                                                                        *)
(*  you can redistribute it and/or modify it under the terms of the GNU   *)
(*  Lesser General Public License as published by the Free Software       *)
(*  Foundation, version 2.1.                                              *)
(*                                                                        *)
(*  It is distributed in the hope that it will be useful,                 *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *)
(*  GNU Lesser General Public License for more details.                   *)
(*                                                                        *)
(*  See the GNU Lesser General Public License version 2.1                 *)
(*  for more details (enclosed in the file LICENCE).                      *)
(*                                                                        *)
(**************************************************************************)

open Cil_datatype


module Make: functor 
     (Assign : Poly_assign.S with type P.v = Varinfo.t 
			     and type P.Var.Map.key = Varinfo.t
			     and type P.Var.Set.t = Varinfo.Set.t
     )-> 
sig 
  
  (** 1. Cil2Pilat *)
  (** Returns a polynomial representing the expression in argument *)
  val exp_to_poly : ?nd_var:(float*float) Varinfo.Map.t  -> Cil_types.exp -> Assign.P.t
    
  (** Returns a list of list of polynomial affectations. Each list correspond to a the 
      succession of affectations for each possible path in the loop, while omitting 
      variable absent of the set in argument
      Raises Not_solvable if a statement of the loop is not solvable. *)
  val loop_to_poly_lists : 
    Assign.P.Var.Set.t -> 
    ?nd_var:(float*float) Varinfo.Map.t -> 
    Cil_types.stmt option -> 
    Cil_types.stmt -> 
    Assign.body list


  (**2.  Pilat2Cil *)
                                                      
  val block_linassign_to_block : 
    Cil_types.block list -> 
    Kernel_function.t -> 
    Cil_types.typ -> 
    Cil_types.location -> 
    Assign.monom_assign list -> Cil_types.block

  (** Returns all the varinfo created by this module. *)
  val export_variables : unit -> Varinfo.t list 

end
