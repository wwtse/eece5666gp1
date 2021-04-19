%iir 

clear;
close all;
%% load
%arduino data

fs = 119;
g = 9.81;

fo = 10;
fname = "putty_test"+fo;
data1 = table2array(readtable("IMU_Hover/"+fname));
ax = data1(:,1)*g;
ay = data1(:,2)*g;
az = data1(:,3)*g;
at = 1/fs*(0:(length(data1)-1));

ax(end) = [];
ay(end) = [];
az(end) = [];
at(end) = [];
%% filtfilt
iir = tiir1;

fx1 = filtfilt(iir.sosMatrix,iir.ScaleValues,ax);
fy1 = filtfilt(iir.sosMatrix,iir.ScaleValues,ay);
fz1 = filtfilt(iir.sosMatrix,iir.ScaleValues,az);

%% plot 

figure;
title(iir.FilterStructure)
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

