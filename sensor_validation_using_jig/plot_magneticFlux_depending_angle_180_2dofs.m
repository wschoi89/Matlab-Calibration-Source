clear;
clc;
close all;

name_sensor = 'sensor11';

% 9 angles between [-30, 30] (7.5degree space)
arr_angles_reference_abd =[-30,-22.5,-15,-7.5, 0, 7.5, 15, 22.5, 30];

% 13 angles between [-90, 90] (15degree space)
arr_angles_reference_flex = [-90,-75,-60,-45,-30,-15,0,15,30,45,60,75,90];

angle_fixed=arr_angles_reference_abd(4);

flag_calibration = false; % flag about wheather the plot shows calibrated data(true) or raw data(false)

arr_mean = zeros(size(arr_angles_reference_flex, 1), 3); % array for flux components(Bx, By, Bz)

arr_minMax = zeros(2, 3); % first row : min, second row : max for flux components(Bx, By, Bz)

%% load magnetic flux data

for i=1:size(arr_angles_reference_flex, 2)
    str_folderPath = strcat('magnetic_180/2dofs/',name_sensor,'/','abd_',num2str(angle_fixed));
    
    str_fileName = strcat(str_folderPath,'/',name_sensor,'_',num2str(angle_fixed),'_',num2str(arr_angles_reference_flex(i)),'degree.csv');
    
    data = csvread(str_fileName);
    data = data(:, 4:6); % read one sensor data     
    mean_data = mean(data);
    arr_mean(i,:) = mean_data;
end

%%  calculate offset using min-max method
arr_minMax(1,:) = min(arr_mean); %min
arr_minMax(2,:) = max(arr_mean); %max
offset = zeros(1,3);
amplitude = zeros(1,3);

%% step1 : calculate offset and amplitude
for i=1:3 % sensor 성분 수
    offset(i) = sum(arr_minMax(:,i))/2;
    amplitude(i) = (arr_minMax(2,i)-arr_minMax(1,i))/2;
end

%% step2 : correct for offset and normalize 
if flag_calibration == true
    arr_mean_normalized = (arr_mean-offset)./amplitude;
else
    arr_mean_normalized = arr_mean;
end

%% step3 : calculate orthogonality
if flag_calibration == true
    arr_orthogonal_magnitude = zeros(size(arr_angles_reference_abd,2),1); % Y, Z성분 크기 
    for i=1:size(arr_angles_reference_abd, 2)
        arr_orthogonal_magnitude(i) = sqrt(arr_mean_normalized(i,2)^2+arr_mean_normalized(i,3)^2);
    end

    arr_error_orthogonality = zeros(5,1);
    arr_enhanced_error_orthogonality = zeros(5,1);
    arr_delta_r_square = zeros(5,1);
    for i=1:size(arr_angles_reference_abd, 2)-4
        arr_error_orthogonality(i) = 2*atan2(arr_orthogonal_magnitude(i+4)-arr_orthogonal_magnitude(i), arr_orthogonal_magnitude(i+4)+arr_orthogonal_magnitude(i));
        arr_delta_r_square(i) = (atan2(arr_mean_normalized(i,3),arr_mean_normalized(i,2))-arr_angles_reference_abd(i)*pi/180)^2+...
            (atan2(arr_mean_normalized(i+4,3),arr_mean_normalized(i+4,2))-arr_angles_reference_abd(i+4)*pi/180)^2;

        arr_enhanced_error_orthogonality(i) = arr_error_orthogonality(i)/(1-arr_delta_r_square(i));
    end
end


%% orthogonality 반영
if flag_calibration == true
%     for i=1:size(arr_angles_reference_abd, 2)
%         arr_mean_normalized(i,2) = (arr_mean_normalized(i,2)-arr_mean_normalized(i,3)*sin(-mean(arr_enhanced_error_orthogonality)))/cos(-mean(arr_enhanced_error_orthogonality));
%     end
end

%% plot data
%abduction
% data_plot = [arr_angles_reference_abd' arr_mean_normalized];
%flexion
data_plot = [arr_angles_reference_flex' arr_mean_normalized];
% figure
subplot(1,3,1);
plot(data_plot(:,1), data_plot(:,2))
hold on
plot(data_plot(:,1), data_plot(:,3))
hold on
plot(data_plot(:,1), data_plot(:,4))
legend('Bx', 'By', 'Bz')
xlabel('reference TH2 angle (degree)')
ylabel('magnetic flux(mT)');
xlim([-90 90]);


% calculate angle
arr_angles_calculated_abd = size(arr_angles_reference_flex);% preallocate calculated angle array depending on the size of the number of reference angles 
arr_angles_calculated_flex = size(arr_angles_reference_flex);% preallocate calculated angle array depending on the size of the number of reference angles 

%flexion
for i=1:size(arr_angles_reference_flex, 2)
%     arr_angles_calculated_abd(i) = -atan2(arr_mean_normalized(i,1), arr_mean_normalized(i,3))*180/pi;
    arr_angles_calculated_abd(i) = -atan2(arr_mean_normalized(i,1), arr_mean_normalized(i,3))*180/pi;
    arr_angles_calculated_flex(i) = atan2(arr_mean_normalized(i,2),arr_mean_normalized(i,3))*180/pi;
end

%abduction
% comp_angle = [arr_angles_reference_abd' arr_angles_calculated'];
%flexion

arr_angles_fixed_abd = zeros(1, size(arr_angles_calculated_flex,2));
arr_angles_fixed_abd(1,:) = angle_fixed;
comp_angle = [arr_angles_reference_flex' arr_angles_fixed_abd' arr_angles_calculated_flex' arr_angles_calculated_abd'];
diff = comp_angle(:,3)-comp_angle(:,1); % difference about flexion angle 

subplot(1,3,2);
plot(comp_angle(:,1), comp_angle(:,1)) % reference flexion angle
hold on
plot(comp_angle(:,1), comp_angle(:,2)) % reference abduction angle
hold on
plot(comp_angle(:,1), comp_angle(:,3)) % flexion angle 
hold on
plot(comp_angle(:,1), comp_angle(:,4)) % abduction angle
legend('TH2 ref','TH1 ref','TH2 calc', 'TH1 calc');
xlabel('reference TH2 angle (degree)')
ylabel('Sensor calculated angle (degree)')

subplot(1,3,3);
plot(comp_angle(:,1), diff)
xlabel('reference TH2 angle (degree)')
ylabel('TH2 angle error(degree)')
title(strcat('TH2 Angle error : ', num2str(mean(diff)), '\pm',num2str(std(diff)),' \circ'));
if flag_calibration==true
    sgtitle('After calibration')
else
     sgtitle(strcat('Fixed', '{} TH1 :','{}(',num2str(angle_fixed), '도)', ' {}w/o calibration'))
end
   
% set(gcf, 'position', [2000,0,1500,800])
% hold on
% calibrate_sensor_parameters
% disp(offset(2:3), amplitude(2:3))
% fprintf(strcat(name_sensor,'\t', num_case, '\n'));
% fprintf('offset : %2.5f, %2.5f\n', offset(2), offset(3))
% fprintf('amplitude : %2.5f, %2.5f\n', amplitude(2), amplitude(3))
% fprintf('mean orthogonality error : %2.5f\n', mean(arr_enhanced_error_orthogonality)*180/pi);
% arr_minMax(:,2:3)
% close all




