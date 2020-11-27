clear 
clc
close all


arr_angles_reference = [-90, -60, -45, -30, 0, 30, 45, 60, 90];

arr_mean = zeros(size(arr_angles_reference, 1), 3);
arr_mean_normalized = zeros(size(arr_angles_reference, 1), 3);

for i=1:size(arr_angles_reference, 2)
    str_fileName = strcat('testbed_magnet90_', num2str(arr_angles_reference(i)), 'degree_training.csv');
    data = csvread(str_fileName);
    data = data(:, 4:6);    
    mean_data = mean(data);
    arr_mean(i,:) = mean_data;
end

arr_flux_magnitude = zeros(size(arr_angles_reference, 1),1);

for i=1:size(arr_angles_reference, 2)
    arr_flux_magnitude(i) = sqrt(arr_mean(i,1)^2+arr_mean(i,2)^2+arr_mean(i,3)^2);
end

mean_flux_magnitude = mean(arr_flux_magnitude);
std_flux_magnitude = std(arr_flux_magnitude);

data_plot = [arr_angles_reference' arr_mean];
figure
subplot(1,3,1);
plot(data_plot(:,1), data_plot(:,2))
hold on
plot(data_plot(:,1), data_plot(:,3))
hold on
plot(data_plot(:,1), data_plot(:,4))
legend('Bx', 'By', 'Bz')
xlabel('degree(angle)')
ylabel('magnetic flux(mT)');


% calculate angle

arr_angles_calculated = size(arr_angles_reference);

for i=1:size(arr_angles_reference, 2)
    arr_mean_normalized(i,:) = arr_mean(i,:)/arr_flux_magnitude(i);
    arr_angles_calculated(i) = atan2(arr_mean_normalized(i,3),arr_mean_normalized(i,2))*180/pi - atan2(1,0)*180/pi;
%     arr_angles_calculated(i) = atan2(sqrt(1-arr_mean_normalized(i,2)^2),arr_mean_normalized(i,2))*180/pi - atan2(1,0)*180/pi;
%     arr_angles_calculated(i) = atan2(arr_mean_normalized(i,2),sqrt(1-arr_mean_normalized(i,2)^2))*180/pi - atan2(1,0)*180/pi+4/pi;
%     arr_angles_calculated(i) = atan2(arr_mean_normalized(i,2),arr_mean_normalized(i,3))*180/pi - atan2(1,0)*180/pi;


end

comp_angle = [arr_angles_reference' arr_angles_calculated'];
diff = comp_angle(:,2)-comp_angle(:,1);
subplot(1,3,2);
plot(comp_angle(:,1), comp_angle(:,2))
xlabel('reference degree(angle)')
ylabel('calculated degree(angle)')
subplot(1,3,3);
plot(comp_angle(:,1), diff)
xlabel('angle(degree)')
ylabel('angle error(degree')

