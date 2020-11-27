clear;
clc;
close all;

name_sensor = 'sensor13';

% 9 angles between [-30, 30] (7.5degree space)
arr_angles_reference_TH1 =[-30,-22.5,-15,-7.5, 0, 7.5, 15, 22.5, 30];
% arr_angles_reference_abd =[0, 7.5, 15, 22.5, 30];
len_TH1 = length(arr_angles_reference_TH1);
% 11 angles between [-90, 90] (15degree space)
arr_angles_reference_TH2 = [-75,-60,-45,-30,-15,0,15,30,45,60,75];
% arr_angles_reference_flex = [0,15,30,45,60,75];
len_TH2 = length(arr_angles_reference_TH2);
arr_mean = zeros(len_TH1*len_TH2, 3); % array for flux components(Bx, By, Bz)

arr_total_data = ones(size(arr_mean,1),size(arr_mean,2)+2); % column: arr_mean + reference angles(abduction+flexion)

%% load magnetic flux data

for i=1:size(arr_angles_reference_TH1, 2)
    for j=1:size(arr_angles_reference_TH2, 2)
        str_folderPath = strcat('magnetic_180/2dofs/',name_sensor,'/','abd_',num2str(arr_angles_reference_TH1(i)));

        str_fileName = strcat(str_folderPath,'/',name_sensor,'_',num2str(arr_angles_reference_TH1(i)),'_',num2str(arr_angles_reference_TH2(j)),'degree.csv');

        data = csvread(str_fileName);
        data = data(:, 4:6); % read one sensor data     
        mean_data = mean(data);
        arr_total_data(len_TH2*(i-1)+j,1:3) = mean_data;
        arr_total_data(len_TH2*(i-1)+j,4) = arr_angles_reference_TH1(i);
        arr_total_data(len_TH2*(i-1)+j,5) = arr_angles_reference_TH2(j);
    end
end

arr_mean_normalized = arr_total_data;

options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 100000, 'MaxIterations', 100000, 'StepTolerance', 1e-10);
% options = optimoptions(@lsqnonlin,'Algorithm', 'trust-region-reflective ','Display', 'iter', 'MaxFunctionEvaluations', 1000000, 'MaxIterations', 1000000, 'initDamping', 10,'StepTolerance', 1e-10);
parameter_init = [0 0 0 1 1 1 1e-10 1e-10]; % parameter initilization 
% parameter_init = [0 0 0 1 1 1 0.001 0.001]; % parameter initilization 
disp('Optimization start!');
optimized_sensor_param=lsqnonlin(@optimize_sensor_2dofs_TH1_TH2, parameter_init, [],[],options, arr_mean_normalized);

offset_x = optimized_sensor_param(1);
offset_y = optimized_sensor_param(2);
offset_z = optimized_sensor_param(3);

amp_x = optimized_sensor_param(4);
amp_y = optimized_sensor_param(5);
amp_z = optimized_sensor_param(6);
shift_x = optimized_sensor_param(7);% reference is Bz
shift_y = optimized_sensor_param(8);% reference is Bz

bx_2 = (arr_mean_normalized(:,1)-offset_x)./amp_x;
by_2 = (arr_mean_normalized(:,2)-offset_y)./amp_y;
bz_2 = (arr_mean_normalized(:,3)-offset_z)./amp_z;

bx_3 = (bx_2-bz_2*sin(-shift_x))/cos(-shift_x);
by_3 = (by_2-bz_2*sin(-shift_y))/cos(-shift_y);
bz_3 = bz_2;

for i=1:size(arr_mean_normalized,1)
    % fixed abd angle, Bx, Bz로 계산
    
    angle_TH1_calc = -atan2(bx_3(i), sqrt(by_3(i)^2+bz_3(i)^2))*180/pi;
    
    %flexion angle, By, Bz로 계산
    angle_TH2_calc = atan2(by_3(i), bz_3(i))*180/pi;
        
    angle_calculated(i,1:2) = [angle_TH1_calc angle_TH2_calc];
    
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
plot(1:1:99, arr_total_data(:,4))
hold on
plot(1:1:99, angle_calculated(:,1))
hold on
legend('TH1 ref', 'TH1 calc')
xlabel('sample')
ylabel('degree')

subplot(2,2,2)
plot(1:1:99, arr_total_data(:,5))
hold on
plot(1:1:99, angle_calculated(:,2))
hold on
legend('TH2 ref', 'TH2 calc')
xlabel('sample')
ylabel('degree')

subplot(2,2,3)
plot(1:1:99, angle_calculated(:,1)-arr_total_data(:,4))
title(strcat('TH1 difference: ', num2str(arr_mean_std(1,1)), '\pm', num2str(arr_mean_std(1,2)), ' degree' ))

xlabel('sample')
ylabel('degree')


subplot(2,2,4)
plot(1:1:99, angle_calculated(:,2)-arr_total_data(:,5))
title(strcat('TH2 difference: ', num2str(arr_mean_std(2,1)), '\pm', num2str(arr_mean_std(2,2)), ' degree' ))
xlabel('sample')
ylabel('degree')


