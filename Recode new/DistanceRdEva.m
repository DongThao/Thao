function DistanceRdEva(numbChange, numbST, BSRate)

% Loading parameter
Input_Parameter;
CallParameter;

%Converting scalar values to vectors
Gamma_vec = Gamma*ones(1,numbST);
Psi_vec = Psi*ones(1,numbST);
PowTh_vec = PowTh*ones(1,numbST);
%dist_vec = 10*ones(1,numbST);

%Optimization the integrated problem 
for i=1:numbChange+1
   
   %priRFPow(i)= IniPow;
   priRFPow(i)= 0.1;
   
   %Calulate the received power of sensor;
  % dist_vec = i*ones(1,numbST);
   dist_vec = randi([2,20],1, numbST); 
   disp(i);
   disp(dist_vec);

  %dist_vec = 10*ones(1,numbST);
   Rec_Pw = Delta*priRFPow(i)*RFGain*SensorGain./(((4*pi/Lambda).*dist_vec).^2); %Unit: walt
  % fprintf('The recived power of Integrated Mode \n');
  % disp(Rec_Pw);
   
   file(1) = numbST;
   file(2:numbST+1) = Rec_Pw;
   file(numbST+2) = BSRate;
   save('Datafile.mat','file');
   
   output= IntegratedFunc(BSRate,numbST,Gamma_vec,Psi_vec,PowTh_vec,Rec_Pw);
   out_Int(i)= output(1);
  % if out_Int(i) > 10000
  %     fprintf('%i\n Integrated',i);
  %     disp(dist_vec);
  %     disp(out_Int);
  % end
   R_HTT(i) = output(2);
   R_BS(i) = output(3);
   
   out_HTT = HTT_Func(numbST,Gamma_vec,Psi_vec,PowTh_vec,Rec_Pw);
   HTT_mode(i) = out_HTT(1);
   %if HTT_mode(i) > 10000
    %   fprintf('%i HTT \n',i);
    %   disp(dist_vec);
     %  disp(HTT_mode(i));
   %end
   
   BS_mode(i) = BSRate;
   delete('Datafile.mat');
end
%disp(output);
%disp(out_HTT);
for i=1:numbChange
    out_Int(i) = out_Int(i)/1000;
    HTT_mode(i) = HTT_mode(i)/1000;
    BS_mode(i) = BS_mode(i)/1000;
    R_HTT(i) = R_HTT(i)/1000;
    R_BS(i) = R_BS(i)/1000;
end
%disp(HTT_mode);
%disp(out_Int);
dlmwrite('out_Int.txt',out_Int);
dlmwrite('HTT_mode.txt',HTT_mode);
%dlmwrite('BS_mode.txt',BS_mode);

%Plotting the result figures
for i=1:numbChange 
dist(i) = i;
end
plot(dist,out_Int,'-r*',dist,HTT_mode,'-b>',dist,BS_mode,'-m+','LineWidth',1.5,'MarkerSize',10);

%plot(dist,out_Int,'-r*','LineWidth',1.5,'MarkerSize',10);
%plot(dist,HTT_mode,'-b>','LineWidth',1.5,'MarkerSize',10);
%plot(dist,out_Int,'-r*',dist,HTT_mode,'-b>','LineWidth',1.5,'MarkerSize',10);

hold on;
plot(dist,R_HTT,'-co',dist,R_BS,'--kd','LineWidth',2.0,'MarkerSize',10);

fig_legend = legend('Integrated Solution','HTT Policy','BS Policy','HTT Rate','BS Rate');

%fig_legend = legend('Integrated Solution','HTT Rate','BS Rate');
%fig_legend = legend('HTT Policy');
%fig_legend = legend('Integrated Solution');
%fig_legend = legend('Integrated Solution','HTT Policy','HTT Rate','BS Rate');
grid on;

set(fig_legend,'FontSize',12);
ylabel('The network throughput(kbps)');
xlabel('The number of random distance change between RF and ST(m)');
end

