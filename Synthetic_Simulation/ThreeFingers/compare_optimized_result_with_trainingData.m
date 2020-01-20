clear
clc
close all

% set device name
device_name='device1';

%load link lengths for thumb, index, and middle devices
arr_links = loadLinkLength();

num_DHjoints = 7; % the joint number in DH table
num_param_per_joint = 4; % DH parameter per joint
num_fingers = 3; % the number of device fingers
num_angles = 4; % device angle

num_zigPos_training = [18, 16, 16]; % thumb, index, middle 
num_samples = 100; % samples per position

% set each finger's origin position
Origin_thumb = eye(4);
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
arr_jointAngles = zeros(num_samples, num_angles*num_fingers, num_zigPos_training(1));

for finger=1:num_fingers
    pos_endEffector_noCalib{1,finger} = zeros(num_samples,3,num_zigPos_training(finger));    
    pos_endEffector_Calib{1,finger}=zeros(num_samples,3,num_zigPos_training(finger)); 
end

% for finger=1:num_fingers
% %     angle_TH1(i) = -30+60*rand(1);
% %     angle_TH2(j) = -30+60*rand(1);
% %     angle_TH3(k) = -30+60*rand(1);
% %     angle_TH4(m) =  90*rand(1);
% %     angle_device = [angle_TH1(i), angle_TH2(j), angle_TH3(k), angle_TH4(m)];
%     DH_temp = DH_ref;
%     DH_temp(2:end, 3) = arr_links(:,finger);
%     DH_table(:,:,finger) = DH_temp;
%     
%     for joint=1:num_joints
%         %transformation matrix
%         mat_transform{1, joint, finger}=transform_DH(DH_table(:,:,finger), joint, joint-1);
%         
%         %frame's transform matrix 
%         if joint == 1
%             frame{1,joint,finger} = Origin(:,:,finger)*cell2mat(mat_transform(1,1,finger));
%         else
%             frame{1,joint, finger} = cell2mat(frame(1,joint-1,finger))*cell2mat(mat_transform(1,joint,finger));
%         end
%         
%         % frame's origin position
%         pos_frame{1,joint,finger}=[frame{1,joint,finger}(1,4);frame{1,joint,finger}(2,4);frame{1,joint,finger}(3,4)];
%     end
% end

% plot three fingers
% plotThreeFingers(Origin, pos_frame)

% load positions for CAD zig
load pos_calibration_thumb_seperately.mat


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
        % plot index and middle finger's zig positions
        for row=1:size(pos_calibZig{1,finger}, 1)
            if row == size(pos_calibZig{1,finger}, 1)
                plot_origin(finger)=plot3(pos_calibZig{1,finger}(row,1), pos_calibZig{1,finger}(row,2), pos_calibZig{1,finger}(row,3), '-o','MarkerSize',8,'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
                
            else
                plot3(pos_calibZig{1,finger}(row,1), pos_calibZig{1,finger}(row,2), pos_calibZig{1,finger}(row,3), '-o','MarkerSize',8,'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
            end
                hold on
        end
        view(-180,0)
        
end

%% plot Origins which projected on the zig plane.
Origin_projToPlane = Origin;

for finger=1:num_fingers
   if finger==1 % thumb 
        subplot(2,3,1);
    elseif finger==2  % index finger
        subplot(2,3,2);
    elseif finger==3 % middle finger
        subplot(2,3,3);
    end
   Origin_projToPlane{1,finger}(2,4) = pos_calibZig{1,finger}(1,2); % y axis
   plot3(Origin_projToPlane{1,finger}(1,4), Origin_projToPlane{1,finger}(2,4), Origin_projToPlane{1,finger}(3,4), '-o','MarkerSize',10,'MarkerFaceColor', color_zigPosition{finger}, 'MarkerEdgeColor', [0 0 0])
   hold on
end

%% draw line to connect zig positions
for finger=1:num_fingers
   if finger==1 % thumb 
        subplot(2,3,1);
    elseif finger==2  % index finger
        subplot(2,3,2);
    elseif finger==3 % middle finger
        subplot(2,3,3);
    end
   for row=1:size(pos_calibZig{1,finger}, 1)
      plot3([Origin_projToPlane{1,finger}(1,4) pos_calibZig{1,finger}(row,1)], [Origin_projToPlane{1,finger}(2,4) pos_calibZig{1,finger}(row,2)], [Origin_projToPlane{1,finger}(3,4) pos_calibZig{1,finger}(row,3)], 'Color', 'k')
      hold on
   end
   
end

% preallocate magnetic data size 
magnetic_data = cell(1, num_zigPos_training(1));
for n_pos=1:num_zigPos_training(1)
   magnetic_data{1,n_pos} = zeros(num_samples, num_angles*num_fingers); 
end

%%  load magnet data from files and calculate estimated end-effector without calibration
for n_pos=1:num_zigPos_training(1) % the number of thumb zig positions

    fileName_magneticData=strcat('DAQ/',device_name,'/training/',device_name,'_DAQ_T',num2str(n_pos),'_I',num2str(n_pos),'_M',num2str(n_pos),'_training.csv');
    magnetic_data{1,n_pos} = load(fileName_magneticData);

    % convert magnetic data into joint angles
    arr_jointAngles(:,:,n_pos) = getJointAngle(magnetic_data{1,n_pos});

    % preallocate the size of pos_frame 
    for finger=1:num_fingers
        for joint=1:num_DHjoints
            pos_frame{1,joint,finger} = zeros(size(arr_jointAngles(:,:,n_pos), 1),3);
        end
    end

    % calculate each joint's transformation matrix and position
    for finger=1:num_fingers
        for row_sample=1:size(arr_jointAngles(:,:,n_pos),1)
            DH_temp = DH_ref;
            jointAngles_temp = arr_jointAngles(:,:,n_pos);
            DH_temp(2,2)=jointAngles_temp(row_sample,4*(finger-1)+1);
            DH_temp(3,2)=jointAngles_temp(row_sample,4*(finger-1)+2);
            DH_temp(5,2)=jointAngles_temp(row_sample,4*(finger-1)+3);
            DH_temp(6,2)=jointAngles_temp(row_sample,4*(finger-1)+4);
            DH_temp(2:end,3) = arr_links(:,finger);

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
        if finger==1
            subplot(2,3,1);
            for row_sample=1:size(arr_jointAngles,1)
                pos_endEffector_noCalib{1,finger}(row_sample,:,n_pos) = pos_frame{1,7,finger}(row_sample,:);
            end
             
        elseif finger==2 && n_pos<num_zigPos_training(2)+1
            subplot(2,3,2);
            for row_sample=1:size(arr_jointAngles,1)
                pos_endEffector_noCalib{1,finger}(row_sample,:,n_pos) = pos_frame{1,7,finger}(row_sample,:);
            end
        elseif finger==3 && n_pos<num_zigPos_training(3)+1
            for row_sample=1:size(arr_jointAngles,1)
                pos_endEffector_noCalib{1,finger}(row_sample,:,n_pos) = pos_frame{1,7,finger}(row_sample,:);
            end
        end
    end
end

%% pre-allocate array for distance error without calibration
arr_distance_noCalib_training = cell(1,3);
% array for distance average and standard deviation without calibration
arr_mean_dist_noCalib_training = cell(1,3);
for finger=1:num_fingers
    arr_distance_noCalib_training{1,finger} = zeros(num_samples, 4, num_zigPos_training(finger)); 
    arr_mean_dist_noCalib_training{1,finger} = zeros(2, 4, num_zigPos_training(finger));
end

%% calculated the distance between zig position and calculated end-effector
% without calibration

for finger=1:num_fingers
    [row,col,page] = size(pos_endEffector_noCalib{1,finger});
    for p=1:page
        %1-3 columns: each axis' distance
        arr_distance_noCalib_training{1,finger}(:,1:3,p)=pos_endEffector_noCalib{1,finger}(:,:,p)-pos_calibZig{1,finger}(p,1:3);
        %4 column : 3D distance
        arr_distance_noCalib_training{1,finger}(:,4,p)=sqrt(sum((pos_endEffector_noCalib{1,finger}(:,:,p)-pos_calibZig{1,finger}(p,1:3)).^2, 2));
    end
end

%% allocate mean and std distance error
for finger=1:num_fingers
    [row,col,page] = size(arr_distance_noCalib_training{1,finger});
    for p=1:page
        for c=1:col
            arr_mean_dist_noCalib_training{1,finger}(1,c,p)=mean(arr_distance_noCalib_training{1,finger}(:,c,p)); 
            arr_mean_dist_noCalib_training{1,finger}(2,c,p)=std(arr_distance_noCalib_training{1,finger}(:,c,p)); 
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
    [row,col,page] = size(arr_distance_noCalib_training{1,finger});
    for p=1:page
        if p==page
            plot_noCalib(finger) = plot3(mean(pos_endEffector_noCalib{1,finger}(:,1,p)),mean(pos_endEffector_noCalib{1,finger}(:,2,p)),mean(pos_endEffector_noCalib{1,finger}(:,3,p)),'-o','MarkerSize',10,'MarkerEdgeColor', color_init_endEffector{finger});
        else
            plot3(mean(pos_endEffector_noCalib{1,finger}(:,1,p)),mean(pos_endEffector_noCalib{1,finger}(:,2,p)),mean(pos_endEffector_noCalib{1,finger}(:,3,p)),'-o','MarkerSize',10,'MarkerEdgeColor', color_init_endEffector{finger});
        end
        hold on
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
   x=1:1:num_zigPos_training(finger);
    y=reshape(arr_mean_dist_noCalib_training{1,finger}(1,4,:), [num_zigPos_training(finger) 1]);
    std=reshape(arr_mean_dist_noCalib_training{1,finger}(2,4,:), [num_zigPos_training(finger) 1]);
    errorbar(x,y,std,'o','MarkerSize', 10, 'Color', color_init_endEffector{finger})
    xlabel('position')
    ylabel('distance error(mm)')
    hold on
end

%% add texts for specific zig positions
subplot(2,3,1);
txt_t1 = {'Postion 1'};
text(pos_calibZig{1,1}(1,1),pos_calibZig{1,1}(1,2),pos_calibZig{1,1}(1,3)-10, txt_t1);
txt_t3 = {'Postion 3'};
text(pos_calibZig{1,1}(3,1),pos_calibZig{1,1}(3,2),pos_calibZig{1,1}(3,3)-10, txt_t3);
txt_t18 = {'Postion 18'};
text(pos_calibZig{1,1}(18,1),pos_calibZig{1,1}(18,2),pos_calibZig{1,1}(18,3)+10, txt_t18);
xlabel('mm')
zlabel('mm')
title('Thumb')
hold on

subplot(2,3,2);
xlabel('mm')
zlabel('mm')
title('Index finger')
hold on

subplot(2,3,3);
xlabel('mm')
zlabel('mm')
title('middle finger')
hold on
% add legend
subplot(2,3,4); legend('thumb w/o calibration');
subplot(2,3,5); legend('index w/o calibration');
subplot(2,3,6); legend('middle w/o calibration');


%% after calibration

for n_pos=1:num_zigPos_training(1)
    
    % convert magnetic data into joint angles
%     arr_jointAngles(:,:,n_pos) = getJointAngle(magnetic_data{1,n_pos});

    % preallocate the size of pos_frame 
    for finger=1:num_fingers
        for joint=1:num_DHjoints
            pos_frame{1,joint,finger} = zeros(size(arr_jointAngles(:,:,n_pos), 1),3);
        end
    end
    
    % calculate each joint's transformation matrix and position
    for finger=1:num_fingers
        for row_sample=1:size(arr_jointAngles(:,:,n_pos),1)
            DH_temp = DH_ref;
            jointAngles_temp = arr_jointAngles(:,:,n_pos);
            DH_temp(2,2)=jointAngles_temp(row_sample,4*(finger-1)+1);
            DH_temp(3,2)=jointAngles_temp(row_sample,4*(finger-1)+2);
            DH_temp(5,2)=jointAngles_temp(row_sample,4*(finger-1)+3);
            DH_temp(6,2)=jointAngles_temp(row_sample,4*(finger-1)+4);
            DH_temp(2:end,3) = arr_links(:,finger);
            % add calibrated parameters
            if finger==1
                load(strcat('Optimized_parameter/',device_name,'/',device_name, '_optimized_parameter_thumb.mat'));
            elseif finger==2
                load(strcat('Optimized_parameter/',device_name,'/',device_name, '_optimized_parameter_index.mat'));
            elseif finger==3
                load(strcat('Optimized_parameter/',device_name,'/',device_name, '_optimized_parameter_middle.mat'));
            end
                % sensor offset
                DH_temp(2,2)=DH_temp(2,2)+list_optParam(1);
                DH_temp(3,2)=DH_temp(3,2)+list_optParam(2);
                DH_temp(5,2)=DH_temp(5,2)+list_optParam(3);
                DH_temp(6,2)=DH_temp(6,2)+list_optParam(4);
                
                % DH parameters
                DH_temp(1,1)=DH_temp(1,1)+list_optParam(5);                DH_temp(1,3)=DH_temp(1,3)+list_optParam(6);
                DH_temp(2,1)=DH_temp(2,1)+list_optParam(7);                DH_temp(2,3)=DH_temp(2,3)+list_optParam(8);
                DH_temp(3,1)=DH_temp(3,1)+list_optParam(9);                DH_temp(3,3)=DH_temp(3,3)+list_optParam(10);
                DH_temp(5,1)=DH_temp(5,1)+list_optParam(11);               DH_temp(5,3)=DH_temp(5,3)+list_optParam(12);
                DH_temp(6,1)=DH_temp(6,1)+list_optParam(13);               DH_temp(6,3)=DH_temp(6,3)+list_optParam(14);
                
                DH_temp(1,2)=DH_temp(1,2)+list_optParam(15);               DH_temp(1,4)=DH_temp(1,4)+list_optParam(16);
                                                                           DH_temp(2,4)=DH_temp(2,4)+list_optParam(17);
                                                                           DH_temp(3,4)=DH_temp(3,4)+list_optParam(18);
                                                                           DH_temp(5,4)=DH_temp(5,4)+list_optParam(19);
                                                                           DH_temp(6,4)=DH_temp(6,4)+list_optParam(20);
                        
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

    % save end-effector positions with calibration
    
    for finger=1:num_fingers 
        if finger==1
            subplot(2,3,1);
            for row_sample=1:size(arr_jointAngles,1)
               pos_endEffector_Calib{1,finger}(row_sample,:,n_pos) = pos_frame{1,7,finger}(row_sample,:);
            end
        elseif finger == 2 && n_pos<num_zigPos_training(2)+1
            subplot(2,3,2);
            for row_sample=1:size(arr_jointAngles,1)
               pos_endEffector_Calib{1,finger}(row_sample,:,n_pos) = pos_frame{1,7,finger}(row_sample,:);
            end
        elseif finger == 3 && n_pos<num_zigPos_training(3)+1
        subplot(2,3,3);
            for row_sample=1:size(arr_jointAngles,1)
               pos_endEffector_Calib{1,finger}(row_sample,:,n_pos) = pos_frame{1,7,finger}(row_sample,:);
            end
        end
    end
end

% array for each axis distance and 3D distance with calibration
arr_distance_Calib_training = cell(1,3);
% array for distance average and standard deviation with calibration
arr_mean_dist_Calib_training = cell(1,3);

for finger=1:num_fingers
    arr_distance_Calib_training{1,finger} = zeros(num_samples, 4, num_zigPos_training(finger));    
    arr_mean_dist_Calib_training{1,finger} = zeros(2, 4, num_zigPos_training(finger));
end


% plot calculated end-effector's mean with calibration
 for finger=1:num_fingers 
    if finger==1
        subplot(2,3,1);
    elseif finger==2 
        subplot(2,3,2);
    elseif finger==3
        subplot(2,3,3);
    end
    [row,col,page] = size(arr_distance_Calib_training{1,finger});
    for p=1:page
        if p==page
            plot_calib(finger)=plot3(mean(pos_endEffector_Calib{1,finger}(:,1,p)),mean(pos_endEffector_Calib{1,finger}(:,2,p)),mean(pos_endEffector_Calib{1,finger}(:,3,p)),'-s','MarkerSize',10,'MarkerFaceColor', color_init_endEffector{finger}, 'MarkerEdgeColor', color_init_endEffector{finger});
        else
            plot3(mean(pos_endEffector_Calib{1,finger}(:,1,p)),mean(pos_endEffector_Calib{1,finger}(:,2,p)),mean(pos_endEffector_Calib{1,finger}(:,3,p)),'-s','MarkerSize',10,'MarkerFaceColor', color_init_endEffector{finger}, 'MarkerEdgeColor', color_init_endEffector{finger});
        end
        hold on
    end
end
  

% calculated the distance between zig position and calculated end-effector
% with calibration

for finger=1:num_fingers
    [row,col,page] = size(pos_endEffector_Calib{1,finger});
    for p=1:page
        %1-3 columns: each axis' distance
        arr_distance_Calib_training{1,finger}(:,1:3,p)=pos_endEffector_Calib{1,finger}(:,:,p)-pos_calibZig{1,finger}(p,1:3);
        %4 column : 3D distance
        arr_distance_Calib_training{1,finger}(:,4,p)=sqrt(sum((pos_endEffector_Calib{1,finger}(:,:,p)-pos_calibZig{1,finger}(p,1:3)).^2, 2));
    end
end

clear std
% array for mean and std distance error with calibration
for finger=1:num_fingers
    [row,col,page] = size(arr_distance_Calib_training{1,finger});
    for p=1:page
        for c=1:col
            arr_mean_dist_Calib_training{1,finger}(1,c,p)=mean(arr_distance_Calib_training{1,finger}(:,c,p)); 
            arr_mean_dist_Calib_training{1,finger}(2,c,p)=std(arr_distance_Calib_training{1,finger}(:,c,p)); 
        end
    end
end

% plot distance error and variance (thumb) with calibration
for finger=1:num_fingers
   if finger==1
       subplot(2,3,4);
       grid on
       
   elseif finger==2 
       subplot(2,3,5);
       grid on
   elseif finger==3
       subplot(2,3,6);
       grid on
   end
   x=1:1:num_zigPos_training(finger);
   y=reshape(arr_mean_dist_Calib_training{1,finger}(1,4,:), [num_zigPos_training(finger) 1]);
   std=reshape(arr_mean_dist_Calib_training{1,finger}(2,4,:), [num_zigPos_training(finger) 1]);
   errorbar(x,y,std,'s','MarkerSize', 10, 'MarkerFaceColor', color_init_endEffector{finger})
   hold on
end

subplot(2,3,4);
title('Distance error compared to CAD position (thumb)');
legend('thumb w/o calibration', 'thumb w/ calibration');
% xticks([0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22])

xticks(linspace(1,num_zigPos_training(1)+1,num_zigPos_training(1)+1))
grid on
hold on

subplot(2,3,5);
title('Distance error compared to CAD position (index)');
legend('index w/o calibration', 'index w/ calibration');
xticks(linspace(1,num_zigPos_training(2)+1,num_zigPos_training(2)+1))
grid on
hold on

subplot(2,3,6);
title('Distance error compared to CAD position (middle)');
legend('middle w/o calibration', 'middle w/ calibration');
xticks(linspace(1,num_zigPos_training(3)+1,num_zigPos_training(3)+1))
grid on
hold on

legend([plot_origin(1) plot_noCalib(1) plot_calib(1)], {'CAD', 'w/o calibration', 'w/ calibration'}, 'location', 'northeast');
legend([plot_origin(2) plot_noCalib(2) plot_calib(2)], {'CAD', 'w/o calibration', 'w/ calibration'}, 'location', 'northeast');
legend([plot_origin(3) plot_noCalib(3) plot_calib(3)], {'CAD', 'w/o calibration', 'w/ calibration'}, 'location', 'northeast');









