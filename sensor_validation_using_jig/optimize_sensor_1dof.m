function output = optimize_sensor_1dof(parameter_input, data)

    
    offset_y = parameter_input(1);
    offset_z = parameter_input(2);
    
    
    amp_y = parameter_input(3);
    amp_z = parameter_input(4);
    shift = parameter_input(5);

    for i=1:size(data,1)
        up = ((data(i,2)-offset_y)./amp_y - (data(i,3)-offset_z)./amp_z*sin(-shift))/cos(-shift);
        down = (data(i,3)-offset_z)./amp_z;
        diff_angle = -atan2(up, down)*180/pi ;
        
        if i==1 && diff_angle >0 
            diff_angle = -diff_angle;
        end
    
        ref_angle = data(i,4);
        output(i,1) = diff_angle - ref_angle;
        
        
        
    end
end

