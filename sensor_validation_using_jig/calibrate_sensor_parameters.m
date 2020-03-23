
% options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 100000, 'MaxIterations', 100000, 'initDamping', 10,'StepTolerance', 1e-10);
% 
% data = [arr_mean arr_angles_reference'];
% parameter_init = [0.01 0.01 0.01 0.01 0.01];
% optimized_sensor_param=lsqnonlin(@optimize_sensor, parameter_init, [],[],options, data);
% 
% offset_y = optimized_sensor_param(1);
% offset_z = optimized_sensor_param(2);
% 
% 
% amp_y = optimized_sensor_param(3);
% amp_z = optimized_sensor_param(4);
% shift = optimized_sensor_param(5);

for i=1:size(data,1)
       %By, Bz
       up = ((data(i,3)-offset_z)./amp_z - (data(i,2)-offset_y)./amp_y*sin(-shift))/cos(-shift);
       down = (data(i,2)-offset_y)./amp_y;
        diff_angle = atan2(up, down)*180/pi -atan2(1,0)*180/pi;
        
    
    while(diff_angle < 0)
        diff_angle=diff_angle + 360;
    end
       
    if i==1
        diff_angle = diff_angle - 360;
    end
        
    arr_angle_calculated(i,1) = diff_angle;
   ref_angle = data(i,4);
   
   output(i,1) = diff_angle - ref_angle;
end