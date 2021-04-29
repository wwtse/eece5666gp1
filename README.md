# eece5666gp1

The project is a DSP course project. We mostly used MATLAB to design the filters for IMU datasets. 

The three types of the dataset are from 1. quadcopter, 2. offered by group members, 3.LSM9DS1 IMU embedded ARDUINO NANO 33 BLE SENSE. We used PuTTY to log the signal. 
In the filtering process, three filters should be used. Two lowpass filters to reject the noise and one complementary filter to combine the accelerometer and gyrometer data. 

The lowpass_acc.m is FIR lowpass filter for acceleratometer. 
Parameters: fo - dataset name - 35 line
            fir - fir choice - 43 line

The lowpass_gyro.m is the FIR lowpass filter for gyrometer. 
Parameters: fo - dataset name - 33 line
            fir1,2 - fir choice - 43,44 line
            
The iirImplemet.m is the IIR lowpass filter for acceleratometer. 
Parameters: fo - dataset name - 11 line

The complementary.m is the complementary filter. 
Make sure to run lowpass_acc.m and lowpass_gyro.m firstly.
Parameters: fo - dataset name - 2 line
