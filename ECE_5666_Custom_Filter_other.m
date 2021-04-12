
%{
Fs = 200;
T = 1/Fs;
L = 1208;
az = rt_sensor.signals.values(:,2);
Y = fft(az);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f =Fs*(0:(L/2))/L;
figure()
plot(f,P1)
%}


%{
%accelometer angles
accel_ang = zeros(length(rt_sensor.signals.values),3);

for i = 1:length(rt_sensor.signals.values)
    
    x = rt_sensor.signals.values(i,2)/(((rt_sensor.signals.values(i,1))^2 + (rt_sensor.signals.values(i,3))^2)^0.5);
    y = rt_sensor.signals.values(i,1)/(((rt_sensor.signals.values(i,2))^2 + (rt_sensor.signals.values(i,3))^2)^0.5);
    z = (((rt_sensor.signals.values(i,1))^2 + (rt_sensor.signals.values(i,2))^2)^0.5)/rt_sensor.signals.values(i,3);
    
    phi = atan(x);
    theta = atan(y);
    ksi = atan(z);
    
    accel_ang(i,1) = phi;
    accel_ang(i,2) = theta;
    accel_ang(i,3) = ksi;
    
end

%gyroscope angles
gyro_ang = zeros(length(rt_sensor.signals.values),3);

%Assuming that the initial orientation is zero. 
%figure()
%plot(rt_sensor.time,accel_ang(:,1))
%}
