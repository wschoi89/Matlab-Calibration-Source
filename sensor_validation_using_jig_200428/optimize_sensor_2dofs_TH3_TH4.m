function output = optimize_sensor_2dofs_TH1_TH2(parameter_input, data)

    offset_x = parameter_input(1);
    offset_y = parameter_input(2);
    offset_z = parameter_input(3);
        
    amp_x = parameter_input(4);
    amp_y = parameter_input(5);
    amp_z = parameter_input(6);
    
    shift_x = parameter_input(7); % reference is Bz
    shift_y = parameter_input(8); % reference is Bz
    
    offset_th4_extrinsic = parameter_input(9);
        
    bx_2 = (data(:,1)-offset_x)./amp_x;
    by_2 = (data(:,2)-offset_y)./amp_y;
    bz_2 = (data(:,3)-offset_z)./amp_z;
        
    bx_3 = (bx_2-bz_2*sin(-shift_x))/cos(-shift_x);
    by_3 = (by_2-bz_2*sin(-shift_y))/cos(-shift_y);
    bz_3 = bz_2;
    
    for i=1:size(data,1)
        
    angle_TH3_calc = -atan2(by_3(i), bz_3(i))*180/pi;
    
    angle_TH4_calc = atan2(bx_3(i), sqrt(by_3(i)^2+bz_3(i)^2))*180/pi+offset_th4_extrinsic*180/pi;
                       
        angle_TH3_ref = data(i,4);
        angle_TH4_ref = data(i,5);

        output(i,1) = sqrt((angle_TH4_calc - angle_TH4_ref)^2+(angle_TH3_calc - angle_TH3_ref)^2);
              
        
    end
end

