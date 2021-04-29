clear;
close all;

% load("IMU_Hover/RSdataMine0904.mat");
fs = 119;
g = 9.81;

fo = 4; %5 is useless
fname = "putty_test"+fo;
data1 = table2array(readtable("IMU_Hover/"+fname));
ax = data1(1:end-1,1)*g;
ay = data1(1:end-1,2)*g;
az = data1(1:end-1,3)*g;
at = 1/fs*(0:(length(data1)-1));

S = ax;
T = at(2)-at(1);
Fs = fs;
L = length(S);
t = at;

X = S;
Y = fft(X);

figure;
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')


