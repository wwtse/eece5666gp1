clear;
close all;
%% load
%Hover data
%{
fname = 'RSdataMine';
load("IMU_Hover/"+fname+".mat");

wt = rt_sensor.time;
T = wt(2)- wt(1);
fs = round(1/T);

p = rt_sensor.signals.values(:,4);
q = rt_sensor.signals.values(:,5);
r = rt_sensor.signals.values(:,6);
%}
%calib data
%{
load("imu_calib.csv")
wt = imu_calib(:,1)*10^-9;
T = wt(2)- wt(1);
fs = round(1/T);

p = imu_calib(:,17);
q = imu_calib(:,18);
r = imu_calib(:,19);
%}
%arduino data

fs = 119;

fname = "putty_test3";
data1 = table2array(readtable("IMU_Hover/"+fname));
p = data1(:,4);
q = data1(:,5);
r = data1(:,6);
wt = 1/fs*(0:(length(data1)-1));

%%

fir1 = tfir2;
fir2 = tfir1;

fp1 = filter(fir1,1,p);
fq1 = filter(fir1,1,q);
fr1 = filter(fir2,1,r);


fdelay  = mean(grpdelay(fir1,fs,length(wt)));
wtt = wt(1:end-fdelay);

pp = p(1:end-fdelay);
fp1_1 = fp1;
fp1_1(1:fdelay) = [];

qq = q(1:end-fdelay);
fq1_1 = fq1;
fq1_1(1:fdelay) = [];

fdelayr  = mean(grpdelay(fir2,fs,length(wt)));
wtt2 = wt(1:end-fdelayr);
rr2 = r(1:end-fdelayr);
fr1_1 = fr1;
fr1_1(1:fdelayr) = [];

%% plot

figure;
subplot(3,1,1)
hold on;
plot(wtt,pp);
plot(wtt,fp1_1);
title("p")

subplot(3,1,2)
hold on;
plot(wtt,qq);
plot(wtt,fq1_1);
title("q")

subplot(3,1,3)
hold on;
plot(wtt2,rr2);
plot(wtt2,fr1_1);
title("r")

%save(fname(7:end)+"fgyro"+".mat",'wtt','fp1_1','fq1_1','wtt2','fr1_1');
save("Arduino"+"fgyro"+".mat",'wtt','fp1_1','fq1_1','wtt2','fr1_1');