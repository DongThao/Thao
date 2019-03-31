function NumbSTEva(numbChange,priRFPow, BSRate)

% Loading parameter
Input_Parameter;
CallParameter;

%Optimization the integrated problem 
for i=1:numbChange
   
    if i==1
        numbST(i) = 2;
    else
        numbST(i)= i*IniNumST;
    end
   %Calulate the received power of sensor;
    dist_vec = 10*ones(1, numbST(i));
    Rec_Pw = Delta*priRFPow*RFGain*SensorGain./(((4*pi/Lambda).*dist_vec).^2); %Unit: walt

   %Converting scalar values to vectors
   Gamma_vec = Gamma*ones(1,numbST(i));
   Psi_vec = Psi*ones(1,numbST(i));
   PowTh_vec = PowTh*ones(1,numbST(i));
   %dist_vec = 10*ones(1,numbST);
  
   %Writing variables to a textfile
   file(1) = numbST(i);
   file(2:numbST(i)+1) = Rec_Pw;
   file(numbST(i)+2) = BSRate;
   save('Datafile.mat','file');
   
   
   output = IntegratedFunc(BSRate,numbST(i),Gamma_vec,Psi_vec,PowTh_vec,Rec_Pw);
   out_Int(i)= output(1);
   R_BS(i) = output(2);
   R_HTT(i) = output(3);
   
   out_HTT = HTT_Func(numbST(i),Gamma_vec,Psi_vec,PowTh_vec,Rec_Pw);
   HTT_mode(i) = out_HTT(1);
   
   BS_mode(i) = BSRate;
   delete('Datafile.mat');
end
for i=1:numbChange
    out_Int(i) = out_Int(i)/1000;
    HTT_mode(i) = HTT_mode(i)/1000;
    BS_mode(i) = BS_mode(i)/1000;
    R_HTT(i) = R_HTT(i)/1000;
    R_BS(i) = R_BS(i)/1000;
end
    
%Plotting the result figures
plot(numbST,out_Int,'-r*',numbST,BS_mode,'-b>',numbST,HTT_mode,'-m+','LineWidth',1.5,'MarkerSize',10);
hold on;

plot(numbST,R_HTT,'-co',numbST,R_BS,'--kd','LineWidth',1.0,'MarkerSize',8);
fig_legend = legend('Integrated Solution','BS Policy','HTT Policy');
grid on;

set(fig_legend,'FontSize',12);
ylabel('The network throughput(kbps)');
xlabel('The number of sensor');
end