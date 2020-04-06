function jointAngle = getJointAngle_updated(magnetic_data, param_thumb_sensors_in, param_index_sensors_in, param_middle_sensors_in,ext_sensor_thumb_in,ext_sensor_index_in,ext_sensor_middle_in)
% 3D magnetic sensor에서 얻은 data를 이용해 joint angle 계산하는 함수

    % 이상적인 조립 상황에서의 normalized magnet sensor data값
    alpha=0;
    beta=0;
    gamma=1;
    
    num_fingers = 3;
    num_joints_per_finger = 4;
    
    %thumb, index, middle finger number 
    T1=1;
    T2=0;
    I1=2;
    I2=3;
    M1=4;
    M2=5;
    
    length = size(magnetic_data, 1);
    jointAngle = zeros(length, num_joints_per_finger*num_fingers);
    
    %% parameters (thumb)
    offset_px_thumb=param_thumb_sensors_in(1);offset_py_thumb=param_thumb_sensors_in(2);offset_pz_thumb=param_thumb_sensors_in(3);
    offset_dx_thumb=param_thumb_sensors_in(4);offset_dy_thumb=param_thumb_sensors_in(5);offset_dz_thumb=param_thumb_sensors_in(6);
    
    amp_px_thumb=param_thumb_sensors_in(7); amp_py_thumb=param_thumb_sensors_in(8); amp_pz_thumb=param_thumb_sensors_in(9);
    amp_dx_thumb=param_thumb_sensors_in(10);amp_dy_thumb=param_thumb_sensors_in(11);amp_dz_thumb=param_thumb_sensors_in(12);
    
    shift_px_thumb = param_thumb_sensors_in(13);shift_py_thumb = param_thumb_sensors_in(14);
    shift_dx_thumb = param_thumb_sensors_in(15);shift_dy_thumb = param_thumb_sensors_in(16);
    
    bx_p_2_thumb = (magnetic_data(:,T1*3+1)-offset_px_thumb)./amp_px_thumb;
    by_p_2_thumb = (magnetic_data(:,T1*3+2)-offset_py_thumb)./amp_py_thumb;
    bz_p_2_thumb = (magnetic_data(:,T1*3+3)-offset_pz_thumb)./amp_pz_thumb;
    
    bx_p_3_thumb = (bx_p_2_thumb-bz_p_2_thumb*sin(-shift_px_thumb))/cos(-shift_px_thumb);
    by_p_3_thumb = (by_p_2_thumb-bz_p_2_thumb*sin(-shift_py_thumb))/cos(-shift_py_thumb);
    bz_p_3_thumb = bz_p_2_thumb;
    
    bx_d_2_thumb = (magnetic_data(:,T2*3+1)-offset_dx_thumb)./amp_dx_thumb;
    by_d_2_thumb = (magnetic_data(:,T2*3+2)-offset_dy_thumb)./amp_dy_thumb;
    bz_d_2_thumb = (magnetic_data(:,T2*3+3)-offset_dz_thumb)./amp_dz_thumb;
    
    bx_d_3_thumb = (bx_d_2_thumb-bz_d_2_thumb*sin(-shift_dx_thumb))/cos(-shift_dx_thumb);
    by_d_3_thumb = (by_d_2_thumb-bz_d_2_thumb*sin(-shift_dy_thumb))/cos(-shift_dy_thumb);
    bz_d_3_thumb = bz_d_2_thumb;
    
    %% parameter(index)
    offset_px_index=param_index_sensors_in(1);offset_py_index=param_index_sensors_in(2);offset_pz_index=param_index_sensors_in(3);
    offset_dx_index=param_index_sensors_in(4);offset_dy_index=param_index_sensors_in(5);offset_dz_index=param_index_sensors_in(6);
    
    amp_px_index=param_index_sensors_in(7); amp_py_index=param_index_sensors_in(8); amp_pz_index=param_index_sensors_in(9);
    amp_dx_index=param_index_sensors_in(10);amp_dy_index=param_index_sensors_in(11);amp_dz_index=param_index_sensors_in(12);
    
    shift_px_index = param_index_sensors_in(13);shift_py_index = param_index_sensors_in(14);
    shift_dx_index = param_index_sensors_in(15);shift_dy_index = param_index_sensors_in(16);
    
    bx_p_2_index = (magnetic_data(:,I1*3+1)-offset_px_index)./amp_px_index;
    by_p_2_index = (magnetic_data(:,I1*3+2)-offset_py_index)./amp_py_index;
    bz_p_2_index = (magnetic_data(:,I1*3+3)-offset_pz_index)./amp_pz_index;
    
    bx_p_3_index = (bx_p_2_index-bz_p_2_index*sin(-shift_px_index))/cos(-shift_px_index);
    by_p_3_index = (by_p_2_index-bz_p_2_index*sin(-shift_py_index))/cos(-shift_py_index);
    bz_p_3_index = bz_p_2_index;
    
    bx_d_2_index = (magnetic_data(:,I2*3+1)-offset_dx_index)./amp_dx_index;
    by_d_2_index = (magnetic_data(:,I2*3+2)-offset_dy_index)./amp_dy_index;
    bz_d_2_index = (magnetic_data(:,I2*3+3)-offset_dz_index)./amp_dz_index;
    
    bx_d_3_index = (bx_d_2_index-bz_d_2_index*sin(-shift_dx_index))/cos(-shift_dx_index);
    by_d_3_index = (by_d_2_index-bz_d_2_index*sin(-shift_dy_index))/cos(-shift_dy_index);
    bz_d_3_index = bz_d_2_index;
    
    %% parameter(middle)
    offset_px_middle=param_middle_sensors_in(1);offset_py_middle=param_middle_sensors_in(2);offset_pz_middle=param_middle_sensors_in(3);
    offset_dx_middle=param_middle_sensors_in(4);offset_dy_middle=param_middle_sensors_in(5);offset_dz_middle=param_middle_sensors_in(6);
    
    amp_px_middle=param_middle_sensors_in(7); amp_py_middle=param_middle_sensors_in(8); amp_pz_middle=param_middle_sensors_in(9);
    amp_dx_middle=param_middle_sensors_in(10);amp_dy_middle=param_middle_sensors_in(11);amp_dz_middle=param_middle_sensors_in(12);
    
    shift_px_middle = param_middle_sensors_in(13);shift_py_middle = param_middle_sensors_in(14);
    shift_dx_middle = param_middle_sensors_in(15);shift_dy_middle = param_middle_sensors_in(16);
    
    bx_p_2_middle = (magnetic_data(:,M1*3+1)-offset_px_middle)./amp_px_middle;
    by_p_2_middle = (magnetic_data(:,M1*3+2)-offset_py_middle)./amp_py_middle;
    bz_p_2_middle = (magnetic_data(:,M1*3+3)-offset_pz_middle)./amp_pz_middle;
    
    bx_p_3_middle = (bx_p_2_middle-bz_p_2_middle*sin(-shift_px_middle))/cos(-shift_px_middle);
    by_p_3_middle = (by_p_2_middle-bz_p_2_middle*sin(-shift_py_middle))/cos(-shift_py_middle);
    bz_p_3_middle = bz_p_2_middle;
    
    bx_d_2_middle = (magnetic_data(:,M2*3+1)-offset_dx_middle)./amp_dx_middle;
    by_d_2_middle = (magnetic_data(:,M2*3+2)-offset_dy_middle)./amp_dy_middle;
    bz_d_2_middle = (magnetic_data(:,M2*3+3)-offset_dz_middle)./amp_dz_middle;
    
    bx_d_3_middle = (bx_d_2_middle-bz_d_2_middle*sin(-shift_dx_middle))/cos(-shift_dx_middle);
    by_d_3_middle = (by_d_2_middle-bz_d_2_middle*sin(-shift_dy_middle))/cos(-shift_dy_middle);
    bz_d_3_middle = bz_d_2_middle;
    
    %% calculate joint angle        
    for iter=1:length
       %  Thumb 
       
        jointAngle(iter,1) = - atan2(bx_p_3_thumb(iter), bz_p_3_thumb(iter))+ext_sensor_thumb_in(1);
        jointAngle(iter,2) =   atan2(by_p_3_thumb(iter), bz_p_3_thumb(iter))+ext_sensor_thumb_in(2);
        
        jointAngle(iter,3) =  -atan2(by_d_3_thumb(iter), bz_d_3_thumb(iter))+ext_sensor_thumb_in(3);
        jointAngle(iter,4) =  -atan2(bx_d_3_thumb(iter), bz_d_3_thumb(iter))+ext_sensor_thumb_in(4);

        
       % index finger
       jointAngle(iter,5) = - atan2(bx_p_3_index(iter), bz_p_3_index(iter))+ext_sensor_index_in(1);
       jointAngle(iter,6) =   atan2(by_p_3_index(iter), bz_p_3_index(iter))+ext_sensor_index_in(2);
        
       jointAngle(iter,7) =  -atan2(by_d_3_index(iter), bz_d_3_index(iter))+ext_sensor_index_in(3);
       jointAngle(iter,8) =  -atan2(bx_d_3_index(iter), bz_d_3_index(iter))+ext_sensor_index_in(4);
        
      % middle finger
      
      jointAngle(iter,9) = - atan2(bx_p_3_middle(iter), bz_p_3_middle(iter))+ext_sensor_middle_in(1);
      jointAngle(iter,10) =  atan2(by_p_3_middle(iter), bz_p_3_middle(iter))+ext_sensor_middle_in(2);
        
      jointAngle(iter,11) =  -atan2(by_d_3_middle(iter), bz_d_3_middle(iter))+ext_sensor_middle_in(3);
      jointAngle(iter,12) =  -atan2(bx_d_3_middle(iter), bz_d_3_middle(iter))+ext_sensor_middle_in(4);
        
        
    end


end

