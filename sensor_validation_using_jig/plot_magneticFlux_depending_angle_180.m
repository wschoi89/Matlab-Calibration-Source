clear;clc;close all;

name_sensor = 'sensor1';
num_case = 'case2';

arr_angles_reference = [-180, -150, -135, -120, -90, -60, -45, -30, 0, 30, 45, 60, 90, 120, 135, 150, 180];

flag_calibration = true; % flag about whether the plot shows calibrated data or not 

arr_mean = zeros(size(arr_angles_reference, 1), 3); % array for flux components(Bx, By, Bz)
arr_mean_normalized = zeros(size(arr_angles_reference, 1), 3);
arr_minMax = zeros(2, 3); % first row : min, second row : max for flux components(Bx, By, Bz)

%% load magnetic flux data

for i=1:size(arr_angles_reference, 2)
    str_folderPath = strcat('magnetic_180/',name_sensor,'/',num_case);
    str_fileName = strcat(str_folderPath,'/',name_sensor,'_',num2str(arr_angles_reference(i)),'degree_',num_case,'.csv');
    data = csvread(str_fileName);
    data = data(:, 4:6); % read one sensor data     
    mean_data = mean(data);
    arr_mean(i,:) = mean_data;
end

%%  calculate offset using min-max method
arr_minMax(1,:) = min(arr_mean); 
arr_minMax(2,:) = max(arr_mean);
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
arr_orthogonal_magnitude = zeros(size(arr_angles_reference,2),1); % Y, Z성분 크기 
for i=1:size(arr_angles_reference, 2)
    arr_orthogonal_magnitude(i) = sqrt(arr_mean_normalized(i,2)^2+arr_mean_normalized(i,3)^2);
end

arr_error_orthogonality = zeros(5,1);
arr_enhanced_error_orthogonality = zeros(5,1);
arr_delta_r_square = zeros(5,1);
for i=1:1
    arr_error_orthogonality(i) = 2*atan2(arr_orthogonal_magnitude(i+4)-arr_orthogonal_magnitude(i), arr_orthogonal_magnitude(i+4)+arr_orthogonal_magnitude(i));
    arr_delta_r_square(i) = (atan2(arr_mean_normalized(i,3),arr_mean_normalized(i,2))-arr_angles_reference(i)*pi/180)^2+...
        (atan2(arr_mean_normalized(i+4,3),arr_mean_normalized(i+4,2))-arr_angles_reference(i+4)*pi/180)^2;
    
    arr_enhanced_error_orthogonality(i) = arr_error_orthogonality(i)/(1-arr_delta_r_square(i));
end


%% orthogonality 반영
for i=1:size(arr_angles_reference, 2)
%     arr_mean_normalized(i,3) = (arr_mean_normalized(i,3)-arr_mean_normalized(i,2)*sin(-arr_enhanced_error_orthogonality(1)))/cos(-arr_enhanced_error_orthogonality(1));
    arr_mean_normalized(i,2) = (arr_mean_normalized(i,2)-arr_mean_normalized(i,3)*sin(-arr_enhanced_error_orthogonality(1)))/cos(-arr_enhanced_error_orthogonality(1));
end

%% plot data
data_plot = [arr_angles_reference' arr_mean_normalized];
figure
subplot(1,3,1);
plot(data_plot(:,1), data_plot(:,2))
hold on
plot(data_plot(:,1), data_plot(:,3))
hold on
plot(data_plot(:,1), data_plot(:,4))
legend('Bx', 'By', 'Bz')
xlabel('reference angle (degree)')
ylabel('magnetic flux(mT)');
xlim([-180 180]);


% calculate angle

arr_angles_calculated = size(arr_angles_reference);

for i=1:size(arr_angles_reference, 2)
    arr_angles_calculated(i) = -atan2(arr_mean_normalized(i,2),arr_mean_normalized(i,3))*180/pi;
    if i==1 &&arr_angles_calculated(i)>0
       arr_angles_calculated(i) =  -arr_angles_calculated(i);
    end
end

comp_angle = [arr_angles_reference' arr_angles_calculated'];
diff = comp_angle(:,2)-comp_angle(:,1);

subplot(1,3,2);
plot(comp_angle(:,1), comp_angle(:,2))
xlabel('reference angle (degree)')
ylabel('Sensor calculated angle (degree)')

subplot(1,3,3);
plot(comp_angle(:,1), diff)
xlabel('reference angle (degree)')
ylabel('angle error(degree)')
title(strcat('Angle error : ', num2str(mean(diff)), '\pm',num2str(std(diff)),' \circ'));
sgtitle('Before calibration')
set(gcf, 'position', [2000,0,1500,800])

% saveas(gcf, 'test.jpeg')