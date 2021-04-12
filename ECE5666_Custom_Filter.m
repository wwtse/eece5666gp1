clear;
clc;

%load('RSdataMine')
load('IMU_Hover/RSdataB0904_1')
%load('RSdataMine0904')
%% subplot
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

%% calu
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
hd = ideallp(om_cutoff,L);
h = hd.*window.';
h1 = [h zeros(1,length(rt_sensor.signals.values(:,1))-1)];
rtax = [rt_sensor.signals.values(:,1); zeros(length(h)-1,1)]';
rtay = [rt_sensor.signals.values(:,2); zeros(length(h)-1,1)]';
rtaz = [rt_sensor.signals.values(:,3); zeros(length(h)-1,1)]';


ax = ifft(fft(h1).*fft(rtax));
ay = ifft(fft(h1).*fft(rtay));
az = ifft(fft(h1).*fft(rtaz));

%az = lowpass(rt_sensor.signals.values(:,3),om_pass);

%% subplot2
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

%% ideallp function
% return ideal impulse response
 function F = ideallp(wc,N)
 t = (N+1)/2;              
 x = 0: (N-1);             
 m = x - t + eps;          
 F = sin(wc*m) ./ (pi*m);
 end
