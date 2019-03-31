
% RF transmitter information

global f;                            % the frequency 
f = 2.4*10^9;                        % unit:Hz

global Bw                            % the bandwith
Bw = 10^7;                           % unit: Hz

global Lambda;                        % the wavelength
Lambda = (3*10^8)/f;                  % unit: m

rfGain = 6;                          %dBi
sensorGain =6;                       %dBi

global RFGain;                       % the antenna gain of RF
RFGain = 10^(rfGain/10);

global SensorGain;                    %the antenna gain of sensor
SensorGain = 10^(sensorGain/10);

global IniPow;                       %the initial RF power
IniPow = 0.1;                        %unit: W

% Sensor Tranmitter

global Kappa;                       %the data transmission efficiency
Kappa = 0.6;                        

global Delta;                       %the enery harvesting efficiency
Delta =0.6;

global Psi;
Psi = Kappa*Bw;

Noise = 1.3*10^(-9);               %Noise in transmission of secondary transmitter
NoisePw = Noise*Bw;

global Gamma;
Gamma = 1/NoisePw;

global PowTh;                      %Power threshold to provide for sensor operation
PowTh = 10^(-5);

global IniNumST;
IniNumST = 10;

global IniBS;                       %The rate of backscatter
IniBS = 10^3;                       %unit: bps

global out_Int; 

%global fileID = fopen('nums2.txt','w');




