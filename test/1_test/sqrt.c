int main(){
  int n;
  
   int a,su,t;

    a=0;
    su=1;
    t=1;

    while ( su <= n )
      {
        a=a+1;
        t=t+2;
        su=su+t;
      }
    
    return a;
    
}
