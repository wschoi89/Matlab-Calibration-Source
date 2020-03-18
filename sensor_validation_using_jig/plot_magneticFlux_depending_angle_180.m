clear 
clc
close all


% arr_angles_reference = [0, 30, 45, 60, 90, 120, 135, 150, 180, 210, 225, 240, 270, 300, 315, 330, 360];
arr_angles_reference = [0, 30, 45, 60, 90, 120, 135, 150, 180, 210, 225, 240, 270, 300, 315, 330, 360];

arr_mean = zeros(size(arr_angles_reference, 1), 3);
arr_mean_normalized = zeros(size(arr_angles_reference, 1), 3);

for i=1:size(arr_angles_reference, 2)
%     str_fileName = strcat('magnetic_180/sensorTest_DAQ_T', num2str(arr_angles_reference(i)), '_I',num2str(arr_angles_reference(i)),'_M',num2str(arr_angles_reference(i)),'_training.csv');
    str_fileName = strcat('magnetic_180/testbed_magnet180_', num2str(arr_angles_reference(i)), 'degree_training.csv');
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
    
    
    arr_angles_calculated(i) = atan2(arr_mean_normalized(i,3),arr_mean_normalized(i,2))*180/pi -atan2(1,0)*180/pi;
    
    while(arr_angles_calculated(i)<0)
        arr_angles_calculated(i) = arr_angles_calculated(i) + 360;
    end
    
    arr_angles_calculated(i)
    
    if i==1
        arr_angles_calculated(i) = arr_angles_calculated(i) - 360;
    end
    
%     if atan2(arr_mean_normalized(i,3),arr_mean_normalized(i,2))*180/pi < 0
%         arr_angles_calculated(i) = atan2(arr_mean_normalized(i,3),arr_mean_normalized(i,2))*180/pi;
%     else
%         arr_angles_calculated(i) = 360 + atan2(arr_mean_normalized(i,3),arr_mean_normalized(i,2))*180/pi;
%     end


end

comp_angle = [arr_angles_reference' arr_angles_calculated'];
diff = comp_angle(:,2)-comp_angle(:,1);

subplot(1,3,2);
plot(comp_angle(:,1), comp_angle(:,2))
xlabel('reference angle (degree)')
ylabel('Sensor calculated angle (degree)')
subplot(1,3,3);
plot(comp_angle(:,1), diff)
xlabel('angle(degree)')
ylabel('angle error(degree)')
