clear;
clc;
close all;

name_sensor = 'sensor14';

% 9 angles between [-30, 30] (7.5degree space)
arr_angles_reference_TH3 = -75:15:75;
% arr_angles_reference_TH3 = [-75,-60,-45,-30,-15,0,15,30,45,60,75];
len_TH3 = length(arr_angles_reference_TH3);

% 17 angles between [-30, 90] (7.5 degree space)
arr_angles_reference_TH4 = -30:7.5:90;
% arr_angles_reference_TH4 =[-30,-22.5,-15,-7.5, 0, 7.5, 15, 22.5, 30, 37.5, 45, 52.5, 60, 67.5, 75, 82.5, 90];
len_TH4 = length(arr_angles_reference_TH4);

arr_mean = zeros(len_TH3*len_TH4, 3); % array for flux components(Bx, By, Bz)

arr_total_data = ones(size(arr_mean,1),size(arr_mean,2)+2); % column: arr_mean + reference angles(abduction+flexion)

%% load magnetic flux data

for i=1:len_TH4
    for j=1:len_TH3
        str_folderPath = strcat('magnetic_90/2dofs/',name_sensor,'/','abd_',num2str(arr_angles_reference_TH4(i)));

        str_fileName = strcat(str_folderPath,'/',name_sensor,'_',num2str(arr_angles_reference_TH3(j)),'_',num2str(arr_angles_reference_TH4(i)),'degree.csv');

        data = csvread(str_fileName);
        data = data(:, 4:6); % read one sensor data     
        mean_data = mean(data);
        arr_total_data(len_TH3*(i-1)+j,1:3) = mean_data;
        arr_total_data(len_TH3*(i-1)+j,4) = arr_angles_reference_TH3(j);
        arr_total_data(len_TH3*(i-1)+j,5) = arr_angles_reference_TH4(i);
    end
end

arr_mean_normalized = arr_total_data;
len_total_data = size(arr_total_data,1);

options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 100000, 'MaxIterations', 100000, 'StepTolerance', 1e-10);
% options = optimoptions(@lsqnonlin,'Algorithm', 'trust-region-reflective ','Display', 'iter', 'MaxFunctionEvaluations', 1000000, 'MaxIterations', 1000000, 'initDamping', 10,'StepTolerance', 1e-10);
parameter_init = [0 0 0 1 1 1 1e-10 1e-10 0]; % parameter initilization 
% parameter_init = [0 0 0 1 1 1 0.001 0.001]; % parameter initilization 
disp('Optimization start!');
optimized_sensor_param=lsqnonlin(@optimize_sensor_2dofs_TH3_TH4, parameter_init, [],[],options, arr_mean_normalized);

offset_x = optimized_sensor_param(1);
offset_y = optimized_sensor_param(2);
offset_z = optimized_sensor_param(3);

amp_x = optimized_sensor_param(4);
amp_y = optimized_sensor_param(5);
amp_z = optimized_sensor_param(6);
shift_x = optimized_sensor_param(7);% reference is Bz
shift_y = optimized_sensor_param(8);% reference is Bz

offset_th4_extrinsic = optimized_sensor_param(9);

bx_2 = (arr_mean_normalized(:,1)-offset_x)./amp_x;
by_2 = (arr_mean_normalized(:,2)-offset_y)./amp_y;
bz_2 = (arr_mean_normalized(:,3)-offset_z)./amp_z;

bx_3 = (bx_2-bz_2*sin(-shift_x))/cos(-shift_x);
by_3 = (by_2-bz_2*sin(-shift_y))/cos(-shift_y);
bz_3 = bz_2;

for i=1:size(arr_mean_normalized,1)
    % fixed abd angle, Bx, Bz·Î °è»ê
    
    angle_TH3_calc = -atan2(by_3(i), bz_3(i))*180/pi;
    
    angle_TH4_calc = atan2(bx_3(i), sqrt(by_3(i)^2+bz_3(i)^2))*180/pi+offset_th4_extrinsic*180/pi;
    
    angle_calculated(i,1:2) = [angle_TH3_calc angle_TH4_calc];
    
end

% array for mean, std error
% row1 : th1 mean, std
% row2 : th2 mean, std

arr_mean_std = zeros(2,2);
arr_mean_std(1,1) = mean(angle_calculated(:,1)-arr_total_data(:,4));
arr_mean_std(1,2) = std(angle_calculated(:,1)-arr_total_data(:,4));
arr_mean_std(2,1) = mean(angle_calculated(:,2)-arr_total_data(:,5));
arr_mean_std(2,2) = std(angle_calculated(:,2)-arr_total_data(:,5));

subplot(2,2,1)
plot(1:len_total_data, arr_total_data(:,4))
hold on
plot(1:len_total_data, angle_calculated(:,1))
hold on
legend('TH3 ref', 'TH3 calc')
xlabel('sample')
ylabel('degree')

subplot(2,2,2)
plot(1:len_total_data, arr_total_data(:,5))
hold on
plot(1:len_total_data, angle_calculated(:,2))
hold on
legend('TH4 ref', 'TH4 calc')
xlabel('sample')
ylabel('degree')

subplot(2,2,3)
plot(1:len_total_data, angle_calculated(:,1)-arr_total_data(:,4))
title(strcat('TH3 difference: ', num2str(arr_mean_std(1,1)), '\pm', num2str(arr_mean_std(1,2)), ' degree' ))

xlabel('sample')
ylabel('degree')


subplot(2,2,4)
plot(1:len_total_data, angle_calculated(:,2)-arr_total_data(:,5))
title(strcat('TH4 difference: ', num2str(arr_mean_std(2,1)), '\pm', num2str(arr_mean_std(2,2)), ' degree' ))
xlabel('sample')
ylabel('degree')


