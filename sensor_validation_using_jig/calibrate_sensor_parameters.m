% close all
options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 100000, 'MaxIterations', 100000, 'initDamping', 10,'StepTolerance', 1e-10);

data = [arr_mean_normalized arr_angles_reference'];
parameter_init = [0.01 0.01 0.01 0.01 0.01];
disp('Optimization start!');
optimized_sensor_param=lsqnonlin(@optimize_sensor, parameter_init, [],[],options, data);

offset_y = optimized_sensor_param(1);
offset_z = optimized_sensor_param(2);


amp_y = optimized_sensor_param(3);
amp_z = optimized_sensor_param(4);
shift = optimized_sensor_param(5);

arr_mean_optimzed = [arr_mean_normalized(:,1) (arr_mean_normalized(:,2)-offset_y)./amp_y (arr_mean_normalized(:,3)-offset_z)./amp_z];

for i=1:size(data,1)
    
    %By, Bz
    up = ((data(i,2)-offset_y)./amp_y - (data(i,3)-offset_z)./amp_z*sin(-shift))/cos(-shift);
    down = (data(i,3)-offset_z)./amp_z;
    
    diff_angle = -atan2(up, down)*180/pi;
    
    if i==1 && diff_angle >0 
        diff_angle = -diff_angle;
    end
        
    arr_angles_optimized(i,1) = diff_angle;
    ref_angle = data(i,4);
   
    diff(i,1) = diff_angle - ref_angle; % differences
end

if num_case == 'case1'
    subplot(3,3,1);
elseif num_case == 'case2'
    subplot(3,3,4);
else
    subplot(3,3,7);
end
xlabel('refefence angle(degree)');
ylabel('optimized angle(degree)');
plot(arr_angles_reference, arr_mean_optimzed)
xlabel('refefence angle(degree)');
ylabel('magnetic flux (mT)')
legend('Bx', 'By', 'Bz')
if num_case == 'case1'
    subplot(3,3,2);
elseif num_case == 'case2'
    subplot(3,3,5);
else
    subplot(3,3,8);
end
plot(arr_angles_reference, arr_angles_optimized)
xlabel('refefence angle(degree)');
ylabel('optimized angle(degree)');
if num_case == 'case1'
    subplot(3,3,3);
elseif num_case == 'case2'
    subplot(3,3,6);
else
    subplot(3,3,9);
end
plot(arr_angles_reference, diff);
xlabel('refefence angle(degree)');
ylabel('angle error(degree)');
title(strcat('Angle error : ', num2str(mean(diff)), ' \pm',num2str(std(diff)),' \circ'));
sgtitle(strcat(name_sensor,'{ }','optimization'))
set(gcf, 'position', [100,100,1000,500])
set(gcf, 'position', [100,100,1000,400])
if num_case=='case3'
    set(gcf, 'units', 'normalized','outerposition', [0 0 1 1])
    saveas(gcf, strcat(name_sensor,'_','optimization.jpeg'))
end
fprintf(' %2.5f %2.5f %2.5f %2.5f %2.5f\n', optimized_sensor_param(1),optimized_sensor_param(2),optimized_sensor_param(3),optimized_sensor_param(4),optimized_sensor_param(5));

close all