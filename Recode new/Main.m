
close all;
clear all;
clc;
%TransPwEva(10,10,5e3);
%BackscatterEva(10,10,0.1);

%NumbSTEva(10,0.1,5e3);
%DistanceEva(20,5,5e3);
DistanceRdEva(1000,10,5e3);

figure (2);
load out_Int.txt
[f2,x] = ecdf(out_Int);
plot(x,f2,'r','LineWidth',3);
grid on;
hold on;

load HTT_mode.txt
[f2,x] = ecdf(HTT_mode);
plot(x,f2,'b','LineWidth',3);
grid on;
fig_legend = legend('Integrated Mode','HTT Mode');
hold on;
set(fig_legend,'FontSize',12);
xlabel('The network throughput(kbps)');
ylabel('cdf');

%load BS_mode.txt
%[f2,x] = ecdf(BS_mode);
%plot(x,f2,'r','LineWidth',3);
%grid on;
%hold on;
%T = table(out_Int,HTT_mode);
%T(1:1,:);