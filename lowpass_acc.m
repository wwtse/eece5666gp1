clear;
%close all;
%% load
%Hover data
%{
fname = 'RSdataMine';
load("IMU_Hover/"+fname+".mat");

at = rt_sensor.time;
T = at(2)- at(1);
fs = round(1/T);

ax = rt_sensor.signals.values(:,1);
ay = rt_sensor.signals.values(:,2);
az = rt_sensor.signals.values(:,3);
%}

%calib data
%{
load("imu_calib.csv")
at = imu_calib(:,1)*10^-9;
T = at(2)- at(1);
fs = round(1/T);

ax = imu_calib(:,29);
ay = imu_calib(:,30);
az = imu_calib(:,31);
%}

%arduino data

fs = 119;
g = 9.81;

fo = 3; %5 is useless
fname = "putty_test"+fo;
data1 = table2array(readtable("IMU_Hover/"+fname));
ax = data1(:,1)*g;
ay = data1(:,2)*g;
az = data1(:,3)*g;
at = 1/fs*(0:(length(data1)-1));
%% filter 
fir = trfir1;

fx1 = filter(fir,1,ax);
fy1 = filter(fir,1,ay);
fz1 = filter(fir,1,az);

%% cut linear delay
fdelay  = round(mean(grpdelay(fir,fs,length(at))));
att = at(1:end-fdelay);

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

figure;

subplot(3,1,1)
hold on;
plot(att,axx);
plot(att,fx1_1);
title("ax")

subplot(3,1,2)
hold on;
plot(att,ayy);
plot(att,fy1_1);
title("ay")

subplot(3,1,3)
hold on;
plot(att,azz);
plot(att,fz1_1);
title("az")

%sgtitle('trfir1');

%without cut
%{
figure;
title(char(fir))
subplot(3,1,1)
hold on;
plot(at,ax);
plot(at,fx1);
title("ax")

subplot(3,1,2)
hold on;
plot(at,ay);
plot(at,fy1);
title("ay")

subplot(3,1,3)
hold on;
plot(at,az);
plot(at,fz1);
title("az")
%}

%% output
%save(fname(7:end)+"facc"+".mat",'att','fx1_1','fy1_1','fz1_1');
%save("calib"+"facc"+".mat",'att','fx1_1','fy1_1','fz1_1');

%save("Arduino"+fname+"facc"+".mat",'att','fx1_1','fy1_1','fz1_1');