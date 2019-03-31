function TransPwEva(numbChange, numbST, BSRate)

% Loading parameter
Input_Parameter;
CallParameter;

%Converting scalar values to vectors
Gamma_vec = Gamma*ones(1,numbST);
Psi_vec = Psi*ones(1,numbST);
PowTh_vec = PowTh*ones(1,numbST);
%dist_vec = 10*ones(1,numbST);

%Optimization the integrated problem 
for i=1:numbChange
   
   priRFPow(i)= i*IniPow;
   
   %Calulate the received power of sensor;
   dist_vec = 10*ones(1,numbST);
  % dist_vec = 10*rand(1, numbST); 
   disp(dist_vec);

   dist_vec = 10*ones(1,numbST);
   Rec_Pw = Delta*priRFPow(i)*RFGain*SensorGain./(((4*pi/Lambda).*dist_vec).^2); %Unit: walt
   file(1) = numbST;
   file(2:numbST+1) = Rec_Pw;
   file(numbST+2) = BSRate;
   save('Datafile.mat','file');
   
   
   output= IntegratedFunc(BSRate,numbST,Gamma_vec,Psi_vec,PowTh_vec,Rec_Pw);
   out_Int(i)= output(1);
   R_HTT(i) = output(2);
   R_BS(i) = output(3);
   
   out_HTT = HTT_Func(numbST,Gamma_vec,Psi_vec,PowTh_vec,Rec_Pw);
   HTT_mode(i) = out_HTT(1);
   
   BS_mode(i) = BSRate;
   delete('Datafile.mat');
end
%disp(dist_vec);
for i=1:numbChange
    out_Int(i) = out_Int(i)/1000;
    HTT_mode(i) = HTT_mode(i)/1000;
    BS_mode(i) = BS_mode(i)/1000;
    R_HTT(i) = R_HTT(i)/1000;
    R_BS(i) = R_BS(i)/1000;
end
 %Plotting the result figures
plot(priRFPow,out_Int,'-r*',priRFPow,BS_mode,'-b>',priRFPow,HTT_mode,'-m+','LineWidth',1.5,'MarkerSize',10);
hold on;

plot(priRFPow,R_HTT,'-co',priRFPow,R_BS,'--kd','LineWidth',1.0,'MarkerSize',8);
fig_legend = legend('Integrated Solution','BS Policy','HTT Policy');
grid on;

set(fig_legend,'FontSize',12);
ylabel('The network throughput(kbps)');
xlabel('The transmit power(Walt)');

end

