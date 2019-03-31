function fval = obj_funcHTT(x)

%Load input parameter
 Input_Parameter;
 CallParameter;
 
 load('Datafile.mat');
 N = file(1);
 P_rec = file(2:N+1);
 
 fval = 0;
 sumt = 0;
 
 for i = 1:2*N
    if rem(i,2)== 0
     sumt = sumt+x(i);
    end
 end
R = zeros(N);
 for i = 1:N
     R(i)=Psi*x((i-1)*2+2)*log2(1+(Gamma*(1-sumt)*P_rec(i)/x((i-1)*2+2)));
     fval = fval+R(i);
 end
 %for i = 1:N
 %  R(i)= Psi*x(i)*log2(1+Gamma*(1-sumt)*P_rec(i)/x(i));
 % fval = fval+R(i);
 %end
 fval= -fval;
 end
    