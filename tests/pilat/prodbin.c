/*run.config
   OPT: -pilat-degree 2 -pilat-lin
*/

int prodbin(int a, int b){
  int x,y,z;

  x = a;
  y = b;
  z = 0;
  
  while( y!=0 ) 
    { 
      
      if ( y % 2 ==1 )
	{
	  z = z+x;
	}
      x = 2*x;
      y = y/2;
    }
  //@ assert z == a*b;
  return z; 
}


