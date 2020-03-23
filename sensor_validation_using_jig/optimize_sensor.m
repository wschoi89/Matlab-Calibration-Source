function output = optimize_sensor(parameter_input, data)

    
    offset_y = parameter_input(1);
    offset_z = parameter_input(2);
    
    
    amp_y = parameter_input(3);
    amp_z = parameter_input(4);
    shift = parameter_input(5);

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
        
   ref_angle = data(i,4);
   
   output(i,1) = diff_angle - ref_angle;
        
        
        
    end
end

