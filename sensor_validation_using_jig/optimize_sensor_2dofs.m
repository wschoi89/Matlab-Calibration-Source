function output = optimize_sensor_2dofs(parameter_input, data)

    offset_x = parameter_input(1);
    offset_y = parameter_input(2);
    offset_z = parameter_input(3);
        
    amp_x = parameter_input(4);
    amp_y = parameter_input(5);
    amp_z = parameter_input(6);
    
    shift_x = parameter_input(7); % reference is Bz
    shift_y = parameter_input(8); % reference is Bz
    
    bx_2 = (data(:,1)-offset_x)./amp_x;
    by_2 = (data(:,2)-offset_y)./amp_y;
    bz_2 = (data(:,3)-offset_z)./amp_z;
    
    bx_3 = (bx_2-bz_2*sin(-shift_x))/cos(-shift_x);
    by_3 = (by_2-bz_2*sin(-shift_y))/cos(-shift_y);
    bz_3 = bz_2;
    
    for i=1:size(data,1)
        
        %flexion angle, By, Bz로 계산
        diff_angle = atan2(by_3(i), bz_3(i))*180/pi ;
        
        % fixed abd angle, Bx, Bz로 계산
        diff_angle_abd = -atan2(bx_3(i), bz_3(i))*180/pi;
        
        ref_angle = data(i,4);
        ref_angle_abd = data(i,5);

        output(i,1) = sqrt((diff_angle - ref_angle)^2+(diff_angle_abd - ref_angle_abd)^2);
        
        
        
        
        
    end
end

