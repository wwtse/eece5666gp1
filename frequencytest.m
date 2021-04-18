clear;
close all;

load("IMU_Hover/RSdataMine0904.mat");

T = rt_sensor.time(2,1)-rt_sensor.time(1,1);
Fs = 1/T;
L = length(rt_sensor.time);
t = rt_sensor.time;

S = rt_sensor.signals.values(:,6);

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
%=====================

% figure;
% hold on;
% %subplot(2,1,1);
% plot(t,S)
% %subplot(2,1,2);
% S1 = lowpass(S,15,Fs);
% plot(t,S1)

