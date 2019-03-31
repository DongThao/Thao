function BackscatterEva(numbChange,numbST,priRFPow)

% Loading parameter
Input_Parameter;
CallParameter;

%Calulate the received power of sensor;
dist_vec = 10*ones(1,numbST);

Rec_Pw = Delta*priRFPow*RFGain*SensorGain./(((4*pi/Lambda).*dist_vec).^2); %Unit: walt

%Converting scalar values to vectors
Gamma_vec = Gamma*ones(1,numbST);
Psi_vec = Psi*ones(1,numbST);
PowTh_vec = PowTh*ones(1,numbST);
%dist_vec = 10*ones(1,numbST);

%Optimization the integrated problem 
for i=1:numbChange
   
    BSRate(i)= i*IniBS;
    disp(dist_vec);
    
   %Writing variables to a textfile
   file(1) = numbST;
   file(2:numbST+1) = Rec_Pw;
   file(numbST+2) = BSRate(i);
   save('Datafile.mat','file');
   
   
   output = IntegratedFunc(BSRate(i),numbST,Gamma_vec,Psi_vec,PowTh_vec,Rec_Pw);
   if output(1) < BSRate(i);
     out_Int(i)= BSRate(i) ;
     R_BS(i) = BSRate(i);
     R_HTT(i) = 0;
   else 
     out_Int(i)= output(1);
     R_BS(i) = output(2);
     R_HTT(i) = output(3);
   end
   
   out_HTT = HTT_Func(numbST,Gamma_vec,Psi_vec,PowTh_vec,Rec_Pw);
   HTT_mode(i) = out_HTT(1);
   
   BS_mode(i) = BSRate(i);
   delete('Datafile.mat');
end
for i=1:numbChange
    BSRate(i) =BSRate(i)/1000;
    out_Int(i) = out_Int(i)/1000;
    HTT_mode(i) = HTT_mode(i)/1000;
    BS_mode(i) = BS_mode(i)/1000;
    R_HTT(i) = R_HTT(i)/1000;
    R_BS(i) = R_BS(i)/1000;
end
    
 %Plotting the result figures
plot(BSRate,out_Int,'-r*',BSRate,BS_mode,'-b>',BSRate,HTT_mode,'-m+','LineWidth',1.5,'MarkerSize',10);
hold on;

plot(BSRate,R_HTT,'-co',BSRate,R_BS,'--kd','LineWidth',1.0,'MarkerSize',8);
fig_legend = legend('Integrated Solution','BS Policy','HTT Policy');
grid on;

set(fig_legend,'FontSize',12);
ylabel('The network throughput(kbps)');
xlabel('The backscater rate(kbps)');
end