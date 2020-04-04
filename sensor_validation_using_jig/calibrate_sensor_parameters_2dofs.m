 close all
% options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 100000, 'MaxIterations', 100000, 'initDamping', 10,'StepTolerance', 1e-10);
options = optimoptions(@lsqnonlin,'Algorithm', 'trust-region-reflective ','Display', 'iter', 'MaxFunctionEvaluations', 1000000, 'MaxIterations', 1000000, 'initDamping', 10,'StepTolerance', 1e-10);

data = [arr_mean_normalized arr_angles_reference_flex' arr_angles_fixed_abd'];
parameter_init = [0.00 0.00 0.00 0.01 0.01 0.01 0.01 0.01];
disp('Optimization start!');
optimized_sensor_param=lsqnonlin(@optimize_sensor_2dofs, parameter_init, [],[],options, data);

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


% optimized_bx = ((arr_mean_normalized(:,1)-offset_x)./amp_x - (arr_mean_normalized(:,3)-offset_z)./amp_z * sin(-shift_x))/cos(-shift_x);
% optimized_by = ((arr_mean_normalized(:,2)-offset_y)./amp_y - (arr_mean_normalized(:,3)-offset_z)./amp_z * sin(-shift_y))/cos(-shift_y);
% optimized_bz = (arr_mean_normalized(:,3)-offset_z)./amp_z;

% arr_mean_optimzed = [(arr_mean_normalized(:,1)-offset_x)./amp_x (arr_mean_normalized(:,2)-offset_y)./amp_y (arr_mean_normalized(:,3)-offset_z)./amp_z];
arr_mean_optimized = [bx_3 by_3 bz_3];

for i=1:size(data,1)
    
    %By, Bz
    
    diff_angle = atan2(by_3(i), bz_3(i))*180/pi ;
       
    % fixed abd angle
    diff_angle_abd = -atan2(bx_3(i), bz_3(i))*180/pi;
        
    arr_angles_optimized(i,1) = diff_angle;
    arr_angles_optimized_abd(i,1) = diff_angle_abd;
    ref_angle = data(i,4);
    ref_angle_abd = data(i,5);
   
    diff(i,1) = diff_angle - ref_angle; % differences
    diff_abd(i,1) = diff_angle_abd - ref_angle_abd;
end


subplot(1,3,1);
xlabel('refefence angle(degree)');
ylabel('optimized angle(degree)');
plot(arr_angles_reference_flex, arr_mean_optimized)
xlabel('refefence angle(degree)');
ylabel('magnetic flux (mT)')
legend('Bx', 'By', 'Bz')
xlim([-90 90]);

subplot(1,3,2);
arr_angles_fixed_abd = zeros(1, size(arr_angles_reference_flex,2));
arr_angles_fixed_abd(1,:) = angle_fixed;

plot(arr_angles_reference_flex, arr_angles_reference_flex) %flexion ref
hold on
plot(arr_angles_reference_flex, arr_angles_fixed_abd) % abduction ref
hold on
plot(arr_angles_reference_flex, arr_angles_optimized) % flexion optimized
hold on
plot(arr_angles_reference_flex, arr_angles_optimized_abd) % abduction optimized
hold on
legend('flexion ref','abduction ref','flexion calc', 'abduction calc');
xlabel('refefence angle(degree)');
ylabel('optimized angle(degree)');

subplot(1,3,3);

plot(arr_angles_reference_flex, diff);
hold on
plot(arr_angles_reference_flex, diff_abd);
hold on
legend('error flexion', 'error abduction');
xlabel('refefence angle(degree)');
ylabel('angle error(degree)');
title({strcat('flexion angle error : ', num2str(mean(diff)), ' \pm',num2str(std(diff)),' \circ'); 
    strcat('abduction angle error : ', num2str(mean(diff_abd)), ' \pm',num2str(std(diff_abd)),' \circ')});

sgtitle(strcat('flexion angle', '{} abduction angle','{}(',num2str(angle_fixed), ')', ' {}w/ optimization'))
% set(gcf, 'position', [100,100,1000,500])
% set(gcf, 'position', [100,100,1000,400])
% if num_case=='case3'
set(gcf, 'units', 'normalized','outerposition', [0 0 1 1])
% saveas(gcf, strcat(name_sensor,'_','optimization.jpeg'))

% fprintf(' %2.5f %2.5f %2.5f %2.5f %2.5f\n', optimized_sensor_param(1),optimized_sensor_param(2),optimized_sensor_param(3),optimized_sensor_param(4),optimized_sensor_param(5));

