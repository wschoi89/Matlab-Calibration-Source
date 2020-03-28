close all
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
    up = ((data(i,3)-offset_z)./amp_z - (data(i,2)-offset_y)./amp_y*sin(-shift))/cos(-shift);
%     up = ((data(i,3)-offset_z)./amp_z - (data(i,2)-offset_y)./amp_y);
    down = (data(i,2)-offset_y)./amp_y;
    diff_angle = atan2(up, down)*180/pi -atan2(1,0)*180/pi;
        
    arr_angles_optimized(i,1) = diff_angle;
    ref_angle = data(i,4);
   
    diff(i,1) = diff_angle - ref_angle; % differences
end


subplot(1,3,1);
xlabel('refefence angle(degree)');
ylabel('optimized angle(degree)');
plot(arr_angles_reference, arr_mean_optimzed)
xlabel('refefence angle(degree)');
ylabel('magnetic flux (mT)')
legend('Bx', 'By', 'Bz')
subplot(1,3,2);
plot(arr_angles_reference, arr_angles_optimized)
xlabel('refefence angle(degree)');
ylabel('optimized angle(degree)');
subplot(1,3,3);
plot(arr_angles_reference, diff);
xlabel('refefence angle(degree)');
ylabel('angle error(degree)');
title(strcat('Angle error : ', num2str(mean(diff)), ' \pm',num2str(std(diff)),' \circ'));
sgtitle('After optimization')
set(gcf, 'position', [100,100,1000,500])
set(gcf, 'position', [100,100,1000,400])
saveas(gcf, 'test.jpeg')
