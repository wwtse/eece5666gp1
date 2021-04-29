clear;
fo = 10;
fname = "Arduino"+"putty_test"+fo;

load(fname+"facc.mat");
load(fname+"fgyro.mat");

L = min([length(att) length(wtt) length(wtt2)]);
%T = att(2,1)-att(1,1);
T = att(2)-att(1);% arduino dataset

f = zeros(L,7);
f(:,1) =fx1_1(1:L);
f(:,2) =fy1_1(1:L);
f(:,3) =fz1_1(1:L);
f(:,4) =fp1_1(1:L);
f(:,5) =fq1_1(1:L);
f(:,6) =fr1_1(1:L);
f(:,7) = att(1:L);

%accelometer angles
accel_ang = zeros(L,3);

for i = 1:L
    
    x = -f(i,2)/(((f(i,1))^2 + (f(i,3))^2)^0.5);
    y = f(i,1)/(((f(i,2))^2 + (f(i,3))^2)^0.5);
    z = (((f(i,1))^2 + (f(i,2))^2)^0.5)/f(i,3);
    
    accel_ang(i,1) = atan(x);
    accel_ang(i,2) = atan(y);
    accel_ang(i,3) = atan(z);
 
%     accel_ang(i,1) = phi;
%     accel_ang(i,2) = theta;
%     accel_ang(i,3) = ksi;
    
end

%gyroscope angles
gyro_ang = zeros(L,3);

for i = 1:L
    
    gyro_ang(i+1,1) = gyro_ang(i,1)+f(i,4)*T;
    gyro_ang(i+1,2) = gyro_ang(i,2)+f(i,5)*T;
    gyro_ang(i+1,3) = gyro_ang(i,3)+f(i,6)*T;
end
gyro_ang(end,:)=[];

%Assuming that the initial orientation is zero. 
tau = 0.1;  % desired time constant
alpha = tau/(tau+T);
c_ang = (1-alpha)*gyro_ang+alpha*accel_ang;

for i = 1:2    
    figure();
    hold on;
    plot(f(:,7),accel_ang(:,i),'DisplayName',"a"+i);
    plot(f(:,7),gyro_ang(:,i),'DisplayName',"g"+i);
    plot(f(:,7),c_ang(:,i),'DisplayName',"c"+i);
    legend
end
