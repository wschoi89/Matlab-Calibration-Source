% test data ÀÌ¿ëÇÑ distance error

% clear variables except arr_mean_ 

% clearvars -except arr_mean_dist_Calib_training arr_mean_dist_noCalib_training
clc
close all

% set device name
device_name='Device7';
DH_json = jsondecode(fileread('mech-R6.json')); %training parameter

%load link lengths for thumb, index, and middle devices
arr_links = loadLinkLength();

num_DHjoints = 7; % the joint number in DH table
num_param_per_joint = 4; % DH parameter per joint
num_fingers = 3; % the number of device fingers
num_angles = 4; % device angle

num_zigPos_test = [45, 45, 45]; % thumb, index, middle 
% num_zigPos_test = [36, 38, 34]; % thumb, index, middle 
num_maxZigPos_test = max(num_zigPos_test);

if ~exist('num_samples', 'var')
    num_samples = 10; % samples per position
end

% set each finger's origin position
if ~exist('transform_thumb_wrt_index','var')
    load('mat_files/transform_thumb_wrt_index.mat');
end

Origin_thumb = eye(4)*transform_thumb_wrt_index;
Origin_index = eye(4);
Origin_middle = Origin_index*transl(0,0,19);


% allocate each finger's origin into Origin cell.
Origin = cell(1,3);
Origin{1,1} = Origin_thumb;
Origin{1,2} = Origin_index;
Origin{1,3} = Origin_middle;


DH_ref = [0 0      0   -pi/2;
          0 0      0   pi/2;
          0 0      0   0;
          0 -pi/2  0   0;
          0 0      0   0;
          0 0      0   0;
          0 -pi/2  0   0;];
 
DH_table = zeros(num_DHjoints, num_param_per_joint, num_fingers);
mat_transform = cell(1, num_DHjoints, num_fingers);
frame = cell(1, 7, 3);
pos_frame = cell(1, num_DHjoints, num_fingers);

pos_endEffector_noCalib = cell(1,3);
pos_endEffector_Calib = cell(1,3);
arr_jointAngles = zeros(num_samples, num_angles*num_fingers, num_maxZigPos_test);

for finger=1:num_fingers
    pos_endEffector_noCalib{1,finger} = zeros(num_samples,3,num_zigPos_test(finger));    
    pos_endEffector_Calib{1,finger}=zeros(num_samples,3,num_zigPos_test(finger)); 
end

% load positions for CAD test zig
load('mat_files./pos_calibration_big_radius.mat');
pos_calibZig_test=pos_calibZig;

% load('mat_files./pos_calibration_small_radius.mat');


%% plot finger's origin
color_zigPosition = {[0 0 0], [0 0 0], [0 0 0]}; % color for each finger (thumb, index,and middle finger)
figure;
for finger=1:num_fingers
    if finger==1 % Thumb
        subplot(2,3,1);
    elseif finger==2 % index finger
        subplot(2,3,2);
    elseif finger==3 % middle finger
        subplot(2,3,3);
    end
    % plot each finger's origin
    plot3(Origin{1,finger}(1,4), Origin{1,finger}(2,4), Origin{1,finger}(3,4), '-o','MarkerSize',10,'MarkerFaceColor', color_zigPosition{finger}, 'MarkerEdgeColor', color_zigPosition{finger})
    hold on
end

%% plot real end-effector position
for finger=1:num_fingers
   if finger==1 % thumb 
        subplot(2,3,1);
   elseif finger==2  % index finger
        subplot(2,3,2);
   elseif finger==3 % middle finger
        subplot(2,3,3);
   end
    
   for row=1:size(pos_calibZig_test{1,finger}, 1)
        if row == size(pos_calibZig_test{1,finger}, 1)
            plot_origin(finger)=plot3(pos_calibZig_test{1,finger}(row,1), pos_calibZig_test{1,finger}(row,2), pos_calibZig_test{1,finger}(row,3), '-o','MarkerSize',8,'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
        else
            plot3(pos_calibZig_test{1,finger}(row,1), pos_calibZig_test{1,finger}(row,2), pos_calibZig_test{1,finger}(row,3), '-o','MarkerSize',8,'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
        end
            hold on
    end
    view(-180,0)
end

DH_offset = reshape(DH_json.DH_offset, 32, 3)';
ext_off_thumb = [DH_json.off_TH1_Thumb, DH_json.off_TH2_Thumb, DH_json.off_TH3_Thumb, DH_json.off_TH4_Thumb];
ext_off_index = [DH_json.off_TH1_Index, DH_json.off_TH2_Index, DH_json.off_TH3_Index, DH_json.off_TH4_Index];
ext_off_middle = [DH_json.off_TH1_Middle, DH_json.off_TH2_Middle, DH_json.off_TH3_Middle, DH_json.off_TH4_Middle];

%%  load training magnet data from files and calculate estimated end-effector without calibration
for n_pos=1:num_maxZigPos_test % the number of thumb zig positions
    
%     fileName_magneticData=strcat('DAQ/',device_name,'/test/',device_name,'_DAQ_T',num2str(n_pos),'_I',num2str(n_pos),'_M',num2str(n_pos),'_test.csv');
    fileName_magneticData=strcat('DAQ/',device_name,'/training/',device_name,'_DAQ_T',num2str(n_pos),'_I',num2str(n_pos),'_M',num2str(n_pos),'_training.csv');
    magnetic_data{1,n_pos} = load(fileName_magneticData);
    magnetic_data{1,n_pos} = magnetic_data{1,n_pos}(1:num_samples, :);
   

    % preallocate the size of pos_frame 
    for finger=1:num_fingers
        for joint=1:num_DHjoints
            pos_frame{1,joint,finger} = zeros(size(arr_jointAngles(:,:,n_pos), 1),3);
        end
    end
        

    % calculate each joint's transformation matrix and position
    for finger=1:num_fingers
        for row_sample=1:size(arr_jointAngles(:,:,n_pos),1)
            
            % convert magnetic data into joint angles
            DH_temp = DH_ref;
            param_thumb_sensors = [0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0];
            param_index_sensors = [0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0];
            param_middle_sensors = [0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0];
            
            if finger==1
                arr_jointAngles(:,:,n_pos) = getJointAngle_updated(magnetic_data{1,n_pos}, DH_offset(finger, 17:32), param_index_sensors,param_middle_sensors,ext_off_thumb,[0,0,0,0],[0,0,0,0]);
            elseif finger==2
                arr_jointAngles(:,:,n_pos) = getJointAngle_updated(magnetic_data{1,n_pos}, param_thumb_sensors,DH_offset(finger, 17:32),param_middle_sensors,[0,0,0,0],ext_off_index,[0,0,0,0]);
            elseif finger==3
                arr_jointAngles(:,:,n_pos) = getJointAngle_updated(magnetic_data{1,n_pos}, param_thumb_sensors,param_index_sensors,DH_offset(finger, 17:32),[0,0,0,0],[0,0,0,0],ext_off_middle);
            end
            
            
            jointAngles_temp = arr_jointAngles(:,:,n_pos);
            DH_temp(2,2)=jointAngles_temp(row_sample,4*(finger-1)+1);
            DH_temp(3,2)=jointAngles_temp(row_sample,4*(finger-1)+2);
            DH_temp(5,2)=jointAngles_temp(row_sample,4*(finger-1)+3);
            DH_temp(6,2)=jointAngles_temp(row_sample,4*(finger-1)+4);
            DH_temp(2:end,3) = arr_links(:,finger);
            
            % DH parameters
            DH_temp(1,1)=DH_temp(1,1)+DH_offset(finger,1);                DH_temp(1,3)=DH_temp(1,3)+DH_offset(finger,2);
            DH_temp(2,1)=DH_temp(2,1)+DH_offset(finger,3);                DH_temp(2,3)=DH_temp(2,3)+DH_offset(finger,4);
            DH_temp(3,1)=DH_temp(3,1)+DH_offset(finger,5);                DH_temp(3,3)=DH_temp(3,3)+DH_offset(finger,6);
            DH_temp(5,1)=DH_temp(5,1)+DH_offset(finger,7);                DH_temp(5,3)=DH_temp(5,3)+DH_offset(finger,8);
            DH_temp(6,1)=DH_temp(6,1)+DH_offset(finger,9);                DH_temp(6,3)=DH_temp(6,3)+DH_offset(finger,10);

            DH_temp(1,2)=DH_temp(1,2)+DH_offset(finger,11);               DH_temp(1,4)=DH_temp(1,4)+DH_offset(finger,12);
                                                                          DH_temp(2,4)=DH_temp(2,4)+DH_offset(finger,13);
                                                                          DH_temp(3,4)=DH_temp(3,4)+DH_offset(finger,14);
                                                                          DH_temp(5,4)=DH_temp(5,4)+DH_offset(finger,15);
                                                                          DH_temp(6,4)=DH_temp(6,4)+DH_offset(finger,16);

           DH_table(:,:,finger) = DH_temp;
                       

            for joint=1:num_DHjoints
                %transformation matrix
                mat_transform{1, joint, finger}=transform_DH(DH_table(:,:,finger), joint, joint-1);

                %frame's transform matrix 
                if joint == 1
                    frame{1,joint,finger} = Origin{1,finger}*cell2mat(mat_transform(1,1,finger));
                else
                    frame{1,joint, finger} = cell2mat(frame(1,joint-1,finger))*cell2mat(mat_transform(1,joint,finger));
                end

                % frame's origin position
                pos_frame{1,joint,finger}(row_sample,:)=[frame{1,joint,finger}(1,4) frame{1,joint,finger}(2,4) frame{1,joint,finger}(3,4)];
            end
        end
    end

    % allocate end-effector positions
    color_init_endEffector = {[0.8 0 0], [0 0.5 0], [0 0.5 1]};
    for finger=1:num_fingers 
        if finger==1 && n_pos<num_zigPos_test(1)+1
            subplot(2,3,1);
            for row_sample=1:size(arr_jointAngles,1)
                pos_endEffector_Calib{1,finger}(row_sample,:,n_pos) = pos_frame{1,7,finger}(row_sample,:);
            end
             
        elseif finger==2 && n_pos<num_zigPos_test(2)+1
            subplot(2,3,2);
            for row_sample=1:size(arr_jointAngles,1)
                pos_endEffector_Calib{1,finger}(row_sample,:,n_pos) = pos_frame{1,7,finger}(row_sample,:);
            end
        elseif finger==3 && n_pos<num_zigPos_test(3)+1
            for row_sample=1:size(arr_jointAngles,1)
                pos_endEffector_Calib{1,finger}(row_sample,:,n_pos) = pos_frame{1,7,finger}(row_sample,:);
            end
        end
    end
end

%% pre-allocate array for distance error without calibration
arr_distance_Calib_test = cell(1,3);
% array for distance average and standard deviation without calibration
arr_mean_dist_Calib_test = cell(1,3);
for finger=1:num_fingers
    arr_distance_Calib_test{1,finger} = zeros(num_samples, 4, num_zigPos_test(finger)); 
    arr_mean_dist_Calib_test{1,finger} = zeros(2, 4, num_zigPos_test(finger));
end

%% calculated the distance between zig position and calculated end-effector without calibration

for finger=1:num_fingers
    [row,col,page] = size(pos_endEffector_Calib{1,finger});
    for p=1:page
        %1-3 columns: each axis' distance
        arr_distance_Calib_test{1,finger}(:,1:3,p)=pos_endEffector_Calib{1,finger}(:,:,p)-pos_calibZig_test{1,finger}(p,1:3);
        %4 column : 3D distance
        arr_distance_Calib_test{1,finger}(:,4,p)=sqrt(sum((pos_endEffector_Calib{1,finger}(:,:,p)-pos_calibZig_test{1,finger}(p,1:3)).^2, 2));
    end
end

%% allocate mean and std distance error
for finger=1:num_fingers
    [row,col,page] = size(arr_distance_Calib_test{1,finger});
    for p=1:page
        for c=1:col
            arr_mean_dist_Calib_test{1,finger}(1,c,p)=mean(arr_distance_Calib_test{1,finger}(:,c,p)); 
            clear std
            arr_mean_dist_Calib_test{1,finger}(2,c,p)=std(arr_distance_Calib_test{1,finger}(:,c,p)); 
        end
    end
end

%% plot calculated end-effector's mean without calibration
 for finger=1:num_fingers 
    if finger==1 % thumb 
        subplot(2,3,1);
    elseif finger==2  % index finger
        subplot(2,3,2);
    elseif finger==3 % middle finger
        subplot(2,3,3);
    end
    [row,col,page] = size(arr_distance_noCalib{1,finger});
    for p=1:page
        if p==page
            plot_Calib_test(finger) = plot3(mean(pos_endEffector_Calib{1,finger}(:,1,p)),mean(pos_endEffector_Calib{1,finger}(:,2,p)),mean(pos_endEffector_Calib{1,finger}(:,3,p)),'-o','MarkerSize',10,'MarkerEdgeColor', color_init_endEffector{finger});
        else
            plot3(mean(pos_endEffector_Calib{1,finger}(:,1,p)),mean(pos_endEffector_Calib{1,finger}(:,2,p)),mean(pos_endEffector_Calib{1,finger}(:,3,p)),'-o','MarkerSize',10,'MarkerEdgeColor', color_init_endEffector{finger});
        end
    end
end

%% plot distance error and variance
for finger=1:num_fingers
   if finger==1
       subplot(2,3,4);
   elseif finger==2 
       subplot(2,3,5);
   elseif finger==3 
       subplot(2,3,6);
   end
   x=1:1:num_zigPos_test(finger);
    y=reshape(arr_mean_dist_Calib_test{1,finger}(1,4,:), [num_zigPos_test(finger) 1]);
    std=reshape(arr_mean_dist_Calib_test{1,finger}(2,4,:), [num_zigPos_test(finger) 1]);
    errorbar(x,y,std,'o','MarkerSize', 10, 'Color', color_init_endEffector{finger})
    xlabel('position')
    ylabel('distance error(mm)')
    hold on
end










