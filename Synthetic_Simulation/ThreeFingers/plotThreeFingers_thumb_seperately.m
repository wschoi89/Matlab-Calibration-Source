clear
clc
close all

%load link lengths for thumb, index, and middle devices
arr_links = loadLinkLength();

num_DHjoints = 7;
num_param_per_joint = 4; % DH parameter
num_fingers = 3;
num_angles = 4;
num_zigThumbPos = 21;
num_zigIndexPos = 16;
num_zigMiddlePos = 16;
num_data = 100;

% set each finger's origin position
Origin_index = eye(4);
% depending on the cad model?? yes
Origin_thumb = eye(4);
Origin_middle = Origin_index*transl(0,0,19);

Origin = zeros(4, 4, num_fingers);
Origin(:,:,1) = Origin_thumb;
Origin(:,:,2) = Origin_index;
Origin(:,:,3) = Origin_middle;

DH_ref = [0 0     0   -pi/2;
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
pos_endEffector = cell(1,3);
arr_jointAngles = zeros(num_data, num_angles*num_fingers, num_zigThumbPos);

pos_endEffector{1,1} = zeros(num_data,3,num_zigThumbPos);
pos_endEffector{1,2} = zeros(num_data,3,num_zigIndexPos);
pos_endEffector{1,3} = zeros(num_data,3,num_zigMiddlePos);

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

% color for each finger (thumb, index,and middle finger)
color_position = {[1 0 0], [0 0.5 0], [0 0 1]};
figure;
subplot(2,2,1);
% plot thumb's origin
plot3(Origin_thumb(1,4), Origin_thumb(2,4), Origin_thumb(3,4), '-o','MarkerSize',10,'MarkerFaceColor', color_position{1}, 'MarkerEdgeColor', color_position{1})
hold on
subplot(2,2,2);
% plot index and middle finger's origin
plot3(Origin_index(1,4), Origin_index(2,4), Origin_index(3,4), '-o','MarkerSize',10,'MarkerFaceColor', color_position{2}, 'MarkerEdgeColor', color_position{2})
hold on
plot3(Origin_middle(1,4), Origin_middle(2,4), Origin_middle(3,4), '-o','MarkerSize',10,'MarkerFaceColor',color_position{3}, 'MarkerEdgeColor',color_position{3})
hold on

for finger=1:num_fingers
    if finger==1
        subplot(2,2,1);
        % plot thumb zig positions
        for row=1:size(pos_calibZig{1,finger}, 1)
            plot3(pos_calibZig{1,finger}(row,1), pos_calibZig{1,finger}(row,2), pos_calibZig{1,finger}(row,3), '-o','MarkerSize',8,'MarkerFaceColor', color_position{finger}, 'MarkerEdgeColor', color_position{finger})
            hold on
        end
        view(-180,0)
        
        
    else
        subplot(2,2,2);
        % plot index and middle finger's zig positions
        for row=1:size(pos_calibZig{1,finger}, 1)
            plot3(pos_calibZig{1,finger}(row,1), pos_calibZig{1,finger}(row,2), pos_calibZig{1,finger}(row,3), '-o','MarkerSize',8,'MarkerFaceColor', color_position{finger}, 'MarkerEdgeColor', color_position{finger})
            hold on
        end
        view(-180,0)
    end
end

%% plot Origins which projected on the zig plane.
Origin_projToPlane = Origin;
Origin_projToPlane(2,4,1) = pos_calibZig{1, 1}(1,2);
Origin_projToPlane(2,4,2) = pos_calibZig{1, 2}(1,2);
Origin_projToPlane(2,4,3) = pos_calibZig{1, 3}(1,2);
Origin_thumb_projToPlane = Origin_projToPlane(:,:,1);
Origin_index_projToPlane = Origin_projToPlane(:,:,2);
Origin_middle_projToPlane = Origin_projToPlane(:,:,3);
subplot(2,2,1);
% plot thumb's origin
plot3(Origin_thumb_projToPlane(1,4), Origin_thumb_projToPlane(2,4), Origin_thumb_projToPlane(3,4), '-o','MarkerSize',10,'MarkerFaceColor', color_position{1}, 'MarkerEdgeColor', color_position{1})
hold on
subplot(2,2,2);
% plot index and middle finger's origin
plot3(Origin_index_projToPlane(1,4), Origin_index_projToPlane(2,4), Origin_index_projToPlane(3,4), '-o','MarkerSize',10,'MarkerFaceColor', color_position{2}, 'MarkerEdgeColor', color_position{2})
hold on
plot3(Origin_middle_projToPlane(1,4), Origin_middle_projToPlane(2,4), Origin_middle_projToPlane(3,4), '-o','MarkerSize',10,'MarkerFaceColor',color_position{3}, 'MarkerEdgeColor',color_position{3})
hold on

%% draw line to connect zig positions
subplot(2,2,1);
%thumb
for row=1:size(pos_calibZig{1,1}, 1) 
    plot3([Origin_thumb_projToPlane(1,4) pos_calibZig{1,1}(row,1)], [Origin_thumb_projToPlane(2,4) pos_calibZig{1,1}(row,2)], [Origin_thumb_projToPlane(3,4) pos_calibZig{1,1}(row,3)], 'Color', [1 0 0])
    hold on
end

subplot(2,2,2);
% index finger
for row=1:size(pos_calibZig{1,2}, 1) 
    plot3([Origin_index_projToPlane(1,4) pos_calibZig{1,2}(row,1)], [Origin_index_projToPlane(2,4) pos_calibZig{1,2}(row,2)], [Origin_index_projToPlane(3,4) pos_calibZig{1,2}(row,3)],'Color',[0 0.5 0])
    hold on
end

% middle finger
for row=1:size(pos_calibZig{1,3}, 1) 
    plot3([Origin_middle_projToPlane(1,4) pos_calibZig{1,3}(row,1)], [Origin_middle_projToPlane(2,4) pos_calibZig{1,3}(row,2)], [Origin_middle_projToPlane(3,4) pos_calibZig{1,3}(row,3)],'Color',[0 0 1])
    hold on
end


%%  load magnet data from files

for n_pos=1:num_zigThumbPos
    
    fileName_magneticData=strcat('../DAQ/200102_DAQ_T',num2str(n_pos),'_I',num2str(n_pos),'_M',num2str(n_pos),'.csv');
    magnetic_data = load(fileName_magneticData);

    % convert magnetic data into joint angles
    arr_jointAngles(:,:,n_pos) = getJointAngle(magnetic_data);

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
                    frame{1,joint,finger} = Origin(:,:,finger)*cell2mat(mat_transform(1,1,finger));
                else
                    frame{1,joint, finger} = cell2mat(frame(1,joint-1,finger))*cell2mat(mat_transform(1,joint,finger));
                end

                % frame's origin position
                pos_frame{1,joint,finger}(row_sample,:)=[frame{1,joint,finger}(1,4) frame{1,joint,finger}(2,4) frame{1,joint,finger}(3,4)];
            end
        end
    end

    % plot calculated end-effector positions
    for finger=1:num_fingers 
        if finger==1
            subplot(2,2,1);
            for row_sample=1:size(arr_jointAngles,1)
               plot3(pos_frame{1,7,finger}(row_sample,1),pos_frame{1,7,finger}(row_sample,2),pos_frame{1,7,finger}(row_sample,3),'-o', 'Color', [0.5 0 0])
               hold on
               pos_endEffector{1,finger}(row_sample,:,n_pos) = pos_frame{1,7,finger}(row_sample,:);
            end
        elseif finger == 2 && n_pos<17
            subplot(2,2,2);
            for row_sample=1:size(arr_jointAngles,1)
               plot3(pos_frame{1,7,finger}(row_sample,1),pos_frame{1,7,finger}(row_sample,2),pos_frame{1,7,finger}(row_sample,3),'-o', 'Color', [0 0.2 0]) 
               hold on
               pos_endEffector{1,finger}(row_sample,:,n_pos) = pos_frame{1,7,finger}(row_sample,:);
            end
        elseif finger==3 && n_pos<17
            subplot(2,2,2);
            for row_sample=1:size(arr_jointAngles,1)
               plot3(pos_frame{1,7,finger}(row_sample,1),pos_frame{1,7,finger}(row_sample,2),pos_frame{1,7,finger}(row_sample,3),'-o','Color',[0 0 1]) 
               hold on
               pos_endEffector{1,finger}(row_sample,:,n_pos) = pos_frame{1,7,finger}(row_sample,:);
            end
        end
    end
end

% array for each axis distance and 3D distance
arr_distance = cell(1,3);
arr_distance{1,1} = zeros(num_data, 4, num_zigThumbPos);
arr_distance{1,2} = zeros(num_data, 4, num_zigIndexPos);
arr_distance{1,3} = zeros(num_data, 4, num_zigMiddlePos);
% array for distance average and standard deviation
arr_mean_dist = cell(1,3);
arr_mean_dist{1,1} = zeros(2, 4, num_zigThumbPos);
arr_mean_dist{1,2} = zeros(2, 4, num_zigIndexPos);
arr_mean_dist{1,3} = zeros(2, 4, num_zigMiddlePos);


% calculated the distance between zig position and calculated end-effector
for finger=1:num_fingers
    [row,col,page] = size(pos_endEffector{1,finger});
    for p=1:page
        %1-3 columns: each axis' distance
        arr_distance{1,finger}(:,1:3,p)=pos_endEffector{1,finger}(:,:,p)-pos_calibZig{1,finger}(p,1:3);
        %4 column : 3D distance
        arr_distance{1,finger}(:,4,p)=sqrt(sum((pos_endEffector{1,finger}(:,:,p)-pos_calibZig{1,finger}(p,1:3)).^2, 2));
    end
end

% array for mean and std distance error
for finger=1:num_fingers
    [row,col,page] = size(arr_distance{1,finger});
    for p=1:page
        for c=1:col
            arr_mean_dist{1,finger}(1,c,p)=mean(arr_distance{1,finger}(:,c,p)); 
            arr_mean_dist{1,finger}(2,c,p)=std(arr_distance{1,finger}(:,c,p)); 
        end
    end
end

subplot(2,2,3);
x=1:1:num_zigThumbPos;
y=reshape(arr_mean_dist{1,1}(1,4,:), [21 1]);
std=reshape(arr_mean_dist{1,1}(2,4,:), [21 1]);
errorbar(x,y,std,'s', 'Color', 'r')
xlabel('position')
ylabel('distance error(mm)')

subplot(2,2,4);
x=1:1:num_zigIndexPos;
y=reshape(arr_mean_dist{1,2}(1,4,:), [num_zigIndexPos 1]);
std=reshape(arr_mean_dist{1,2}(2,4,:), [num_zigIndexPos 1]);
errorbar(x,y,std,'s', 'Color', [0 0.5 0])

hold on

x=1:1:num_zigMiddlePos;
y=reshape(arr_mean_dist{1,3}(1,4,:), [num_zigMiddlePos 1]);
std=reshape(arr_mean_dist{1,3}(2,4,:), [num_zigMiddlePos 1]);
errorbar(x,y,std,'s', 'Color', 'b')

xlabel('position')
ylabel('distance error(mm)')




% save data
save('training_test_data.mat', 'arr_jointAngles', 'pos_calibZig', 'pos_endEffector')

% thumb 21개 position(x,y,z) 100 개, 21*3*100
% CAD_thumb : 21개 x,y,z 21*3
% index 16개 position(x,y,z) 100 개, 16*3*100
% CAD_index : 16개 x,y,z, 16*3
% middle 16개 position(x,y,z) 100개, 16*3*100
% CAD_middle : 16개 x,y,z, 16*3











