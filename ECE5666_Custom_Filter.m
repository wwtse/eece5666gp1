clear;
clc;

%load('RSdataMine')
load('RSdataB0904_1')
%load('RSdataMine0904')

subplot(3,2,1)
plot(rt_sensor.time,rt_sensor.signals.values(:,1))
title('x-accel')

subplot(3,2,3)
plot(rt_sensor.time,rt_sensor.signals.values(:,2))
title('y-accel')

subplot(3,2,5)
plot(rt_sensor.time,rt_sensor.signals.values(:,3))
title('z-accel')

subplot(3,2,2)
plot(rt_sensor.time,rt_sensor.signals.values(:,4))
title('x-w')

subplot(3,2,4)
plot(rt_sensor.time,rt_sensor.signals.values(:,5))
title('y-w')

subplot(3,2,6)
plot(rt_sensor.time,rt_sensor.signals.values(:,6))
title('z-w')

%Sampling frequeny -> 500 Hz
Fs = 500;

%cutoff frequency for IMU -> 12Hz(pass) - 15Hz(stop)
F_pass = 12;
F_stop = 15;

%Normalized frequency omega = 2pi*freq/sampling freq
om_pass = 2*pi*F_pass/Fs;
om_stop = 2*pi*F_stop/Fs;

%Take ripple magnitude of Ap = 0.1 dB and attenuation As = 50 dB
Ap = 0.1;
As = 50;

% delta p and delta s
deltap = (10^(Ap/20)-1)/(10^(Ap/20)+1);
deltas = (1+deltap)/(10^(As/20));

delta = min(deltap,deltas);
A = -20*log10(delta);

delta_om = om_stop - om_pass;
om_cutoff = (om_stop + om_pass)/2;

%using Table 10.3 Hamming SpecsL = ceil(6.6*pi/delta_om) +  1;
L = ceil(6.6*pi/delta_om) + 1;
M = L-1;
alpha = M/2;

window = hamming(L);

n = 0:M;
hd = ideallp(om_cutoff,M);
h = hd.*window;

ax = conv(h,rt_sensor.signals.values(:,1));
ay = conv(h,rt_sensor.signals.values(:,2));
az = conv(h,rt_sensor.signals.values(:,3));

%az = lowpass(rt_sensor.signals.values(:,3),om_pass);

figure()
subplot(3,2,1)
plot(rt_sensor.time,rt_sensor.signals.values(:,1))
title('ax - unfiltered')

subplot(3,2,2)
%plot(rt_sensor.time, az)
plot(ax)
title('ax - filtered')

subplot(3,2,3)
plot(rt_sensor.time,rt_sensor.signals.values(:,2))
title('ay - unfiltered')

subplot(3,2,4)
plot(ay)
title('ay - filtered')

subplot(3,2,5)
plot(rt_sensor.time,rt_sensor.signals.values(:,3))
title('az - unfiltered')

subplot(3,2,6)
plot(az)
title('az - filtered')



