function output_HTT = HTT_Func(N,gamma,psi,powTh,P_rec)

%Set initial value for transmission time(t_a and t_b)
%t_a: time slot for transmission
%t_h: time slot for harvest energy

x0 = 0.02*ones(1,2*N);

for i=1:2*N
    if rem(i,2)== 0
       continue;                    %Values of even elements are not changed
    else
        x0(i) = 0;                  %Values of even elements are not changed
    end
end
fprintf('The initial value x0 of Integrated Mode \n');
disp(x0);
%Building constraints C0, C1. 
%Set the contraint Ax <= b 
%Matrix A
%Final row is for the constraint C0, while other rows are for the constraint C1
%Contraint C1 :(-1-powTh/P_rec)t_2n -Sigma(t_2n)<=-1 
%t_2n = t_a, t_2n-1 =t_h

A = zeros(2*N+1,2*N);
for i =1:2*N
   if rem(i,2)==0                    % i even
       for j=1:2*N
           if rem(j,2)== 0           % i even, j even, t_a;
               A(i,j) = -1;
           else
               A(i,j) = 0;            % i even, j odd, t_h
           end
           if j==i                    % i even, j even,i=j
            fprintf('%i %i The power threshold and recived power of Integrated Mode \n',powTh(i/2),P_rec(i/2));
            A(i,j) = -1-powTh(i/2)/P_rec(i/2);
           % A(i,j-1)=-1;
           end
       end
   end
end
for i=1:2*N
    A(2*N+1,i) =1;
end

fprintf('The matrix A of HTT Mode \n');
disp(A);    % Show the matrix A


%for i=1:N
%   for j=1:N
%       if j==i
%           A(i,j)= -1 - powTh(1)/P_rec(1);
%       else
%           A(i,j)= -1;
%       end
%    end
%end


%Vector b
b =zeros(1,2*N+1);
for i=1:2*N
    if rem(i,2)==0
       b(1,i)= -1;
    end
end
b(2*N+1)= 1;

fprintf('The matrix b of HTT Mode \n');
disp(b);    % Show the matrix b

%b = zeros(1,N+1);
%for i=1:N
%    b(1,i) = -1;
%end
%b(1,N+1) = 1;
%disp(b);



%Other contraint
lb = zeros(1, 2*N);
ub = ones(1, 2*N);
Aeq = [];
beq =[];

options = optimoptions(@fmincon,'Algorithm','interior-point');
func_objHTT =@obj_funcHTT;
[x,fx] = fmincon(func_objHTT,x0,A,b,Aeq,beq,lb,ub,[],options);


%Computing network throughput in HTT modes:

R_t =0;

sumt =0;
sumh =0;

for i =1:2*N
    if rem(i,2)==0
        sumt=sumt+x(i);    %i even =>t_a
    else
        sumh=sumh+x(i);     %i odd =>t_h
    end
end

for i=1:N
    R_t = R_t + psi(i)*x((i-1)*2+2)*log2(1+gamma(i)*(1-sumt-x((i-1)*2+1))*P_rec(i)/x((i-1)*2+2));
end

%Setting output results to output variable
output_HTT(1) = -fx;
output_HTT(2) = R_t;
fprintf(' Time slot in HTT \n');
disp(x);
end