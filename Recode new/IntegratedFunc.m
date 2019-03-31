function output = IntegratedFunc(bsrate,N,gamma,psi,powTh,P_rec)

%Set initial value for transmission time(t_a and t_b)
%t_a: time slot for transmission
%t_b: time slot for harvest energy and backscatter time

fprintf('The recived power P_Rec of Integrated Mode \n');
disp(P_rec);

x0 = 0.02*ones(1,2*N);
bsRate_vec = bsrate*ones(1,N);

for i=1:2*N
    if rem(i,2)== 0             %Values of even elements are not changed
       continue;
    else
        x0(i) = 0;              %Values of odd elements are changed to zeros
    end
end

fprintf('The initial value x0 of Integrated Mode \n');
disp(x0);

%Building constraints C0, C1. 
%Set the contraint Ax <= b 
%Matrix A
%Final row is for the constraint C0, while other rows are for the constraint C1
%Constrant C1:  (-1-powTh/P_rec)t_2n - t_2n-1 -Sigma(t_2n)<=-1
%t_2n = t_a, t_2n-1 =t_b

A = zeros(2*N+1,2*N);                                 
for i =1:2*N
   if rem(i,2)==0                     % i even
       for j=1:2*N
           if rem(j,2)== 0            % i even, j even, t_a;
               A(i,j) = -1;
           else
               A(i,j) = 0;            % i even, j odd, t_b
           end
           if j==i                    % i even, j even,i=j the diagonal main of the matrix
            fprintf('%i %i The power threshold and recived power of Integrated Mode \n',powTh(i/2),P_rec(i/2));
            A(i,j) = -1-powTh(i/2)/P_rec(i/2);
            A(i,j-1)=-1;
           end
       end
   end
end
for i=1:2*N
    A(2*N+1,i) =1;
end

fprintf('The matrix A of Integrated Mode \n');
disp(A);    % Show the matrix A
%Vector b
b =zeros(1,2*N+1);
for i=1:2*N
    if rem(i,2)==0
       b(1,i)= -1;
    end
end
b(2*N+1)= 1;

fprintf('The matrix b of Integrated Mode \n');
disp(b);    % Show the matrix b
%Other contraint
Aeq =[];
beq =[];
lb = zeros(1, 2*N);
ub = ones(1, 2*N);
options = optimoptions(@fmincon,'Algorithm','interior-point');
obj_fun =@obj_func;
[x,fx] = fmincon(obj_fun,x0,A,b,Aeq,beq,lb,ub,[],options);

%Caculating throughput in two modes: backscattering and HTT

R_t =0;
R_b =0;

sumt =0;
sumb =0;

for i =1:2*N
    if rem(i,2)==0
        sumt=sumt+x(i);    %i even =>t_a
    else
        sumb=sumb+x(i);
    end
end

for i=1:N
    R_b = R_b + x((i-1)*2+1)*bsRate_vec(i);
    R_t = R_t + psi(i)*x((i-1)*2+2)*log2(1+(gamma(i)*(1-sumt-x((i-1)*2+1))*P_rec(i)/x((i-1)*2+2)));
end

%R_b = sumb*bsrate;


%Setting output results to output variable
output(1) = -fx;
output(2) = R_t;
output(3)= R_b;
fprintf(' Time slot in Integrated Mode  \n');
disp(x);
end


