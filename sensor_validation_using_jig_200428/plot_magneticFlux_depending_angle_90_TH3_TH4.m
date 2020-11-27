clear;
clc;
close all;

name_sensor = 'sensor14';

% 11 angles between [-75, 75] (15 degree space)
arr_angles_reference_TH3 = -75:15:75;
% arr_angles_reference_TH3 = [-75,-60,-45,-30,-15,0,15,30,45,60,75];
len_TH3 = length(arr_angles_reference_TH3);

% 17 angles between [-30, 90] (7.5 degree space)
arr_angles_reference_TH4 = -30:7.5:90;
% arr_angles_reference_TH4 =[-30,-22.5,-15,-7.5, 0, 7.5, 15, 22.5, 30, 37.5, 45, 52.5, 60, 67.5, 75, 82.5, 90];
len_TH4 = length(arr_angles_reference_TH4);

flag_calibration = false; % flag about wheather the plot shows calibrated data(true) or raw data(false)

arr_mean = zeros(len_TH3*len_TH4, 3); % array for magnet flux components(Bx, By, Bz)

arr_total_data = ones(size(arr_mean,1),size(arr_mean,2)+2); % column: arr_mean + reference angles(TH1+TH2)
arr_minMax = zeros(2, 3); % first row : min, second row : max for flux components(Bx, By, Bz)

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

%%  calculate offset using min-max method
arr_minMax(1,:) = min(arr_mean); %min
arr_minMax(2,:) = max(arr_mean); %max
offset = zeros(1,3);
amplitude = zeros(1,3);

%% step1 : calculate offset and amplitude
for j=1:3 % sensor 성분 수
    offset(j) = sum(arr_minMax(:,j))/2;
    amplitude(j) = (arr_minMax(2,j)-arr_minMax(1,j))/2;
end

%% step2 : correct for offset and normalize 
if flag_calibration == true
    arr_mean_normalized = (arr_mean-offset)./amplitude;
else
    arr_mean_normalized = arr_mean;
end

%% step3 : calculate orthogonality
if flag_calibration == true
    arr_orthogonal_magnitude = zeros(size(arr_angles_reference_TH1,2),1); % Y, Z성분 크기 
    for j=1:size(arr_angles_reference_TH1, 2)
        arr_orthogonal_magnitude(j) = sqrt(arr_mean_normalized(j,2)^2+arr_mean_normalized(j,3)^2);
    end

    arr_error_orthogonality = zeros(5,1);
    arr_enhanced_error_orthogonality = zeros(5,1);
    arr_delta_r_square = zeros(5,1);
    for j=1:size(arr_angles_reference_TH1, 2)-4
        arr_error_orthogonality(j) = 2*atan2(arr_orthogonal_magnitude(j+4)-arr_orthogonal_magnitude(j), arr_orthogonal_magnitude(j+4)+arr_orthogonal_magnitude(j));
        arr_delta_r_square(j) = (atan2(arr_mean_normalized(j,3),arr_mean_normalized(j,2))-arr_angles_reference_TH1(j)*pi/180)^2+...
            (atan2(arr_mean_normalized(j+4,3),arr_mean_normalized(j+4,2))-arr_angles_reference_TH1(j+4)*pi/180)^2;

        arr_enhanced_error_orthogonality(j) = arr_error_orthogonality(j)/(1-arr_delta_r_square(j));
    end
end


%% orthogonality 반영
if flag_calibration == true
%     for i=1:size(arr_angles_reference_abd, 2)
%         arr_mean_normalized(i,2) = (arr_mean_normalized(i,2)-arr_mean_normalized(i,3)*sin(-mean(arr_enhanced_error_orthogonality)))/cos(-mean(arr_enhanced_error_orthogonality));
%     end
end

%% plot data

len_total_data = size(arr_total_data,1);

bx_3 = arr_total_data(:,1);
by_3 = arr_total_data(:,2);
bz_3 = arr_total_data(:,3);

for i=1:len_total_data
    
    angle_TH3_calc = -atan2(by_3(i), bz_3(i))*180/pi;
    
    angle_TH4_calc = atan2(bx_3(i), sqrt(by_3(i)^2+bz_3(i)^2))*180/pi;


    
    angle_calculated(i,1:2) = [angle_TH3_calc angle_TH4_calc];
    
end

angle_reference = arr_total_data(:,4:5);
diff_TH3 = angle_calculated(:,1)-angle_reference(:,1);
diff_TH4 = angle_calculated(:,2)-angle_reference(:,2);

subplot(2,2,1)
plot(1:len_total_data, angle_reference(:,1))
hold on
plot(1:len_total_data, angle_calculated(:,1))
hold on
legend('TH3 ref', 'TH3 calc')
xlabel('sample')
ylabel('degree')

subplot(2,2,2)
plot(1:len_total_data, angle_reference(:,2))
hold on
plot(1:len_total_data, angle_calculated(:,2))
hold on
legend('TH4 ref', 'TH4 calc')
xlabel('sample')
ylabel('degree')

subplot(2,2,3)
plot(1:len_total_data, diff_TH3)
title(strcat('TH3 difference: ', num2str(mean(diff_TH3)), '\pm', num2str(std(diff_TH3)), ' degree' ))
xlabel('sample')
ylabel('degree')

subplot(2,2,4)
plot(1:len_total_data, diff_TH4)
title(strcat('TH4 difference: ', num2str(mean(diff_TH4)), '\pm', num2str(std(diff_TH4)), ' degree' ))
xlabel('sample')
ylabel('degree')








