clear
clc
close all
num_dataBlock = 1;
data = csvread('csv_angle_abPlus_flex1.csv');
% delete first row
data(1,:) = [];

[row,col] = size(data);

% delete rows which angles calculated by magnets are zeros
for r=1:row
    if data(r,13)~=0 && data(r,14)~=0 && data(r,15)~=0 && data(r,16)~=0
%     if data(r,19)~=0 && data(r,20)~=0 && data(r,21)~=0 && data(r,22)~=0
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

% rearrange arr_markerLoss in descend order
arr_markerLoss = sort(arr_markerLoss, 'descend');

% delete marker loss array 
for i=1:length(arr_markerLoss)
    data(arr_markerLoss(i),:) = [];
end

data(:,1:12) = data(:,1:12)*1000; % adjust scale (m->mm)
% data(:,1:18) = data(:,1:18)*1000; % adjust scale (m->mm)

angle_magnet = data(:, 13:16);

% (proximal) 1,2,3,4 (distal)
L12_reference = 32; % length between marker 1 and 2
L23_reference = 35; % length between marker 2 and 3
L34_reference = 47; % length between marker 3 and 4

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

% 35, 47과 비슷한 vector length 찾기

% 저장순서 1,2,3,4 
%data1
vec_12 = [data(:,4)-data(:,1) data(:,5)-data(:,2) data(:,6)-data(:,3)];
vec_21 = [data(:,1)-data(:,4) data(:,2)-data(:,5) data(:,3)-data(:,6)];
vec_34 = [data(:,10)-data(:,7) data(:,11)-data(:,8) data(:,12)-data(:,9)];
%data2
vec_42 = [data(:,4)-data(:,10) data(:,5)-data(:,11) data(:,6)-data(:,12)];
vec_31 = [data(:,1)-data(:,7) data(:,2)-data(:,8) data(:,3)-data(:,9)];
%data3
vec_23 = [data(:,7)-data(:,4) data(:,8)-data(:,5) data(:,9)-data(:,6)];
vec_14 = [data(:,10)-data(:,1) data(:,11)-data(:,2) data(:,12)-data(:,3)];


dot_vec12_vec34 = dot(vec_12, vec_34, 2);
dot_vec21_vec34 = dot(vec_21, vec_34, 2);
dot_vec42_vec_31 = dot(vec_42, vec_31, 2);
dot_vec23_vec_14 = dot(vec_23, vec_14, 2);


cos_angle = dot_vec12_vec34./(length_vec_12.*length_vec_34);
% cos_angle = dot_vec42_vec_31./(length_vec_24.*length_vec_13);
% cos_angle = dot_vec23_vec_14./(length_vec_23.*length_vec_14);

angle_marker = acos(cos_angle)*180/pi;

comparison = [angle_marker angle_magnet(:,3)+90];
subplot(2,1,1)
plot(comparison)
title('angle calculated by markers and magnetic sensor')
legend('marker', 'magnet')
xlabel('time')
ylabel('degree')
subplot(2,1,2)
difference = comparison(:,1)-comparison(:,2);
plot(comparison(:,1)-comparison(:,2))
title('Angle difference')
xlabel('time')
ylabel('degree')