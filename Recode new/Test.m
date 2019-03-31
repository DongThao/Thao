close all;
clear all;
clc;
%TransPwEva(10,10,5e3);
%BackscatterEva(10,10,0.1);

%NumbSTEva(10,0.1,5e3);
%DistanceEva(10,10,5e3);
%DistanceRdEva(10,2,5e3);
load Output2.txt
[f2,x] = ecdf(Output2);
plot(x,f2,'b','LineWidth',3);
grid on;
hold on;

%T = table(out_Int,HTT_mode);
%T(1:1,:);