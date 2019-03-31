 function fval = obj_func(x)
 
 %Load input parameter
 Input_Parameter;
 CallParameter;
 
 load('Datafile.mat');
 N = file(1);
 P_rec = file(2:N+1);
 Bs_vec = file(N+2)*ones(1,N);
 
 fval = 0;
 sumb = 0;
 sumt = 0;
 for i=1:2*N
     if rem(i,2)== 0
         sumt =sumt+x(i);
     else
         sumb =sumb+x(i);
     end
 end
 
 R = zeros(N);
 for i = 1:N
     R(i)=x((i-1)*2+1)*Bs_vec(i)+Psi*x((i-1)*2+2)*log2(1+Gamma*(1-sumt-x((i-1)*2+1))*P_rec(i)/x((i-1)*2+2));
     fval = fval+R(i);
 end
 fval= -fval;
 end
     
 
