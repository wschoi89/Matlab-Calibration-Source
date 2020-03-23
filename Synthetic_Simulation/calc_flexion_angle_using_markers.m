clear
clc
close all

% data = csvread('csv_angle_ab_plus_flex_plus.csv');
% data = csvread('csv_angle_ab_plus_flex_zero.csv');
% data = csvread('csv_angle_ab_plus_flex_minus.csv');

% data = csvread('csv_angle_ab_minus_flex_plus.csv');
% data = csvread('csv_angle_ab_minus_flex_zero.csv');
data = csvread('csv_angle_ab_minus_flex_minus.csv');

% delete first row
data(1,:) = [];

[row,col] = size(data);

% delete rows which angles calculated by magnets are zeros
for r=1:row
    if data(r,13)~=0 && data(r,14)~=0 && data(r,15)~=0 && data(r,16)~=0
        row_nonzero_magnetAngles = r;
        break;
    end
end

data(1:row_nonzero_magnetAngles,:) = [];

[row,col] = size(data);

% find rows including 3more zeros, which means that one of the markers were lost
num_markerLoss = 0;
for r=1:row
    data_temp = data(r,:);
    array_zeros = find(data_temp==0);
    if size(array_zeros,2) >= 3
        num_markerLoss = num_markerLoss + 1;
        arr_markerLoss(1,num_markerLoss) = r;
    end
end

if exist('arr_markerLoss', 'var')
    % rearrange arr_markerLoss in descend order
    arr_markerLoss = sort(arr_markerLoss, 'descend');

    % delete marker loss array 
    for i=1:length(arr_markerLoss)
        data(arr_markerLoss(i),:) = [];
    end
end

data(:,1:12) = data(:,1:12)*1000; % adjust scale (m->mm)

angle_magnet = data(:, 13:16);

% (proximal) 1,2,3,4 (distal)
L12_reference = 18.9; % length between marker 1 and 2
L34_reference = 32; % length between marker 2 and 3

order_marker = zeros(1,4);


length_vec_12 = sqrt((data(:,1)-data(:,4)).^2+(data(:,2)-data(:,5)).^2+(data(:,3)-data(:,6)).^2);
length_vec_13 = sqrt((data(:,1)-data(:,7)).^2+(data(:,2)-data(:,8)).^2+(data(:,3)-data(:,9)).^2);
length_vec_14 = sqrt((data(:,1)-data(:,10)).^2+(data(:,2)-data(:,11)).^2+(data(:,3)-data(:,12)).^2);

length_vec_23 = sqrt((data(:,4)-data(:,7)).^2+(data(:,5)-data(:,8)).^2+(data(:,6)-data(:,9)).^2);
length_vec_24 = sqrt((data(:,4)-data(:,10)).^2+(data(:,5)-data(:,11)).^2+(data(:,6)-data(:,12)).^2);

length_vec_34 = sqrt((data(:,7)-data(:,10)).^2+(data(:,8)-data(:,11)).^2+(data(:,9)-data(:,12)).^2);

mean_12 = mean(length_vec_12); std_12 = std(length_vec_12);
mean_13 = mean(length_vec_13); std_13 = std(length_vec_13);
mean_14 = mean(length_vec_14); std_14 = std(length_vec_14);

mean_23 = mean(length_vec_23); std_23 = std(length_vec_23);
mean_24 = mean(length_vec_24); std_24 = std(length_vec_24);

mean_34 = mean(length_vec_34); std_34 = std(length_vec_34);

% 32, 19와 비슷한 vector length 찾기

% 저장순서 1,2,3,4 
%data1
vec_12 = [data(:,4)-data(:,1) data(:,5)-data(:,2) data(:,6)-data(:,3)];
vec_13 = [data(:,7)-data(:,1) data(:,8)-data(:,2) data(:,9)-data(:,3)];
vec_21 = [data(:,1)-data(:,4) data(:,2)-data(:,5) data(:,3)-data(:,6)];
vec_34 = [data(:,10)-data(:,7) data(:,11)-data(:,8) data(:,12)-data(:,9)];
%data2
vec_42 = [data(:,4)-data(:,10) data(:,5)-data(:,11) data(:,6)-data(:,12)];
vec_31 = [data(:,1)-data(:,7) data(:,2)-data(:,8) data(:,3)-data(:,9)];
%data3
vec_23 = [data(:,7)-data(:,4) data(:,8)-data(:,5) data(:,9)-data(:,6)];
vec_24 = [data(:,10)-data(:,4) data(:,11)-data(:,5) data(:,12)-data(:,6)];
vec_14 = [data(:,10)-data(:,1) data(:,11)-data(:,2) data(:,12)-data(:,3)];


dot_vec12_vec34 = dot(vec_12, vec_34, 2);
dot_vec21_vec34 = dot(vec_21, vec_34, 2);
dot_vec42_vec_31 = dot(vec_42, vec_31, 2);
dot_vec23_vec_14 = dot(vec_23, vec_14, 2);
dot_vec13_vec_24 = dot(vec_13, vec_24, 2);
dot_vec14_vec_23 = dot(vec_14, vec_23, 2);


cos_angle = dot_vec12_vec34./(length_vec_12.*length_vec_34);
% cos_angle = dot_vec42_vec_31./(length_vec_24.*length_vec_13);
% cos_angle = dot_vec23_vec_14./(length_vec_23.*length_vec_14);
% cos_angle = dot_vec13_vec_24./(length_vec_13.*length_vec_24);
% cos_angle = dot_vec14_vec_23./(length_vec_14.*length_vec_23);

angle_marker = acos(cos_angle)*180/pi;

% comparison = [angle_marker angle_magnet(:,2)];
% comparison = [180-angle_marker angle_magnet(:,2)];
comparison = [-180+angle_marker angle_magnet(:,2)];
% comparison = [-angle_marker angle_magnet(:,2)];
subplot(2,1,1)
plot(comparison)
title('angle calculated by markers and magnetic sensor')
legend('marker', 'magnet')
xlabel('time')
ylabel('degree')
subplot(2,1,2)
difference = (comparison(:,1)-comparison(:,2));
plot(difference)
mean_difference = mean(difference);
title(strcat('Angle difference (mean=', num2str(mean_difference), ' degree)'))
xlabel('time')
ylabel('degree')