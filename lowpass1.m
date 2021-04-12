clear;
close all;
%% load
load("IMU_Hover/RSdataMine.mat");

t = rt_sensor.time;
T = t(2)- t(1);
fs = round(1/T);

ax = rt_sensor.signals.values(:,1);
ay = rt_sensor.signals.values(:,2);
az = rt_sensor.signals.values(:,3);

%% filter 
fx1 = filter(tfir2,1,ax);
fy1 = filter(tfir2,1,ay);
fz1 = filter(tfir2,1,az);

%% cut linear delay
fdelay  = mean(grpdelay(tfir2,fs,length(t)));
tt = t(1:end-fdelay);

axx = ax(1:end-fdelay);
fx1_1 = fx1;
fx1_1(1:fdelay) = [];

ayy = ay(1:end-fdelay);
fy1_1 = fy1;
fy1_1(1:fdelay) = [];

azz = az(1:end-fdelay);
fz1_1 = fz1;
fz1_1(1:fdelay) = [];

%% plot 
%{
figure;
subplot(3,1,1)
hold on;
plot(tt,axx);
plot(tt,fx1_1);
title("ax")

subplot(3,1,2)
hold on;
plot(tt,ayy);
plot(tt,fy1_1);
title("ay")

subplot(3,1,3)
hold on;
plot(tt,azz);
plot(tt,fz1_1);
title("az")
%}