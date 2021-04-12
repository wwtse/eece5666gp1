clear;
close all;

fname = 'RSdataMine';
load("IMU_Hover/"+fname+".mat");

t = rt_sensor.time;
T = t(2)- t(1);
fs = round(1/T);

p = rt_sensor.signals.values(:,4);
q = rt_sensor.signals.values(:,5);
r = rt_sensor.signals.values(:,6);

fp1 = filter(trfir1,p);
fq1 = filter(trfir1,q);
fr1 = filter(trfir2,r);

%%=========
fdelay  = mean(grpdelay(trfir1,fs,length(t)));
tt = t(1:end-fdelay);

pp = p(1:end-fdelay);
fp1_1 = fp1;
fp1_1(1:fdelay) = [];

qq = q(1:end-fdelay);
fq1_1 = fq1;
fq1_1(1:fdelay) = [];

fdelayr  = mean(grpdelay(trfir2,fs,length(t)));
tt2 = t(1:end-fdelayr);
rr2 = r(1:end-fdelayr);
fr1_1 = fr1;
fr1_1(1:fdelayr) = [];

%% plot
%{
figure;
subplot(3,1,1)
hold on;
plot(tt,pp);
plot(tt,fp1_1);
title("p")

subplot(3,1,2)
hold on;
plot(tt,qq);
plot(tt,fq1_1);
title("q")

subplot(3,1,3)
hold on;
plot(tt2,rr2);
plot(tt2,fr1_1);
title("r")
%}
save(fname(7:end)+"fgyro"+".mat",'tt','fp1_1','fq1_1','tt2','fr1_1');