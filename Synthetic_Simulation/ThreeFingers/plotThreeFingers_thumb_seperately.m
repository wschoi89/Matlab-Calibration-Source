clear
clc
close all

%load link lengths for thumb, index, and middle devices
arr_links = loadLinkLength();

num_joints = 7;
num_param_per_joint = 4; % DH parameter
num_fingers = 3;
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

DH_table = zeros(num_joints, num_param_per_joint, num_fingers);
mat_transform = cell(1, 7, 3);
frame = cell(1, 7, 3);
pos_frame = cell(1, 7, 3);
pos_endEffector = cell(1,3);

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
subplot(1,2,1);
% plot thumb's origin
plot3(Origin_thumb(1,4), Origin_thumb(2,4), Origin_thumb(3,4), '-o','MarkerSize',10,'MarkerFaceColor', color_position{1}, 'MarkerEdgeColor', color_position{1})
hold on
subplot(1,2,2);
% plot index and middle finger's origin
plot3(Origin_index(1,4), Origin_index(2,4), Origin_index(3,4), '-o','MarkerSize',10,'MarkerFaceColor', color_position{2}, 'MarkerEdgeColor', color_position{2})
hold on
plot3(Origin_middle(1,4), Origin_middle(2,4), Origin_middle(3,4), '-o','MarkerSize',10,'MarkerFaceColor',color_position{3}, 'MarkerEdgeColor',color_position{3})
hold on

for finger=1:num_fingers
    if finger==1
        subplot(1,2,1);
        % plot thumb zig positions
        for row=1:size(pos_calibZig{1,finger}, 1)
            plot3(pos_calibZig{1,finger}(row,1), pos_calibZig{1,finger}(row,2), pos_calibZig{1,finger}(row,3), '-o','MarkerSize',8,'MarkerFaceColor', color_position{finger}, 'MarkerEdgeColor', color_position{finger})
            hold on
        end
        view(-180,0)
        
        
    else
        subplot(1,2,2);
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
subplot(1,2,1);
% plot thumb's origin
plot3(Origin_thumb_projToPlane(1,4), Origin_thumb_projToPlane(2,4), Origin_thumb_projToPlane(3,4), '-o','MarkerSize',10,'MarkerFaceColor', color_position{1}, 'MarkerEdgeColor', color_position{1})
hold on
subplot(1,2,2);
% plot index and middle finger's origin
plot3(Origin_index_projToPlane(1,4), Origin_index_projToPlane(2,4), Origin_index_projToPlane(3,4), '-o','MarkerSize',10,'MarkerFaceColor', color_position{2}, 'MarkerEdgeColor', color_position{2})
hold on
plot3(Origin_middle_projToPlane(1,4), Origin_middle_projToPlane(2,4), Origin_middle_projToPlane(3,4), '-o','MarkerSize',10,'MarkerFaceColor',color_position{3}, 'MarkerEdgeColor',color_position{3})
hold on

%% draw line to connect zig positions
subplot(1,2,1);
%thumb
for row=1:size(pos_calibZig{1,1}, 1) 
    plot3([Origin_thumb_projToPlane(1,4) pos_calibZig{1,1}(row,1)], [Origin_thumb_projToPlane(2,4) pos_calibZig{1,1}(row,2)], [Origin_thumb_projToPlane(3,4) pos_calibZig{1,1}(row,3)], 'Color', [1 0 0])
    hold on
end

subplot(1,2,2);
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

fileName_magneticData = '../DAQ/200102_DAQ_T1_I1_M1.csv';
for i=1:21
    
    fileName_magneticData=strcat('../DAQ/200102_DAQ_T',num2str(i),'_I',num2str(i),'_M',num2str(i),'.csv');
    magnetic_data = load(fileName_magneticData);

    % convert magnetic data into joint angles
    jointAngle = getJointAngle(magnetic_data);

    pos_frame = cell(1, num_joints, num_fingers);
    for finger=1:num_fingers
        for joint=1:num_joints
            pos_frame{1,joint,finger} = zeros(size(jointAngle, 1),3);
        end
    end


    for finger=1:num_fingers
        for pos=1:size(jointAngle,1)
            DH_temp = DH_ref;
            DH_temp(2,2)=jointAngle(pos,4*(finger-1)+1);
            DH_temp(3,2)=jointAngle(pos,4*(finger-1)+2);
            DH_temp(5,2)=jointAngle(pos,4*(finger-1)+3);
            DH_temp(6,2)=jointAngle(pos,4*(finger-1)+4);
            DH_temp(2:end,3) = arr_links(:,finger);
            DH_table(:,:,finger) = DH_temp;

            for joint=1:num_joints
                %transformation matrix
                mat_transform{1, joint, finger}=transform_DH(DH_table(:,:,finger), joint, joint-1);

                %frame's transform matrix 
                if joint == 1
                    frame{1,joint,finger} = Origin(:,:,finger)*cell2mat(mat_transform(1,1,finger));
                else
                    frame{1,joint, finger} = cell2mat(frame(1,joint-1,finger))*cell2mat(mat_transform(1,joint,finger));
                end

                % frame's origin position
                pos_frame{1,joint,finger}(pos,:)=[frame{1,joint,finger}(1,4) frame{1,joint,finger}(2,4) frame{1,joint,finger}(3,4)];
            end
        end
    end

    % plot calculated end-effector positions
    for finger=1:num_fingers 
        if finger==1
            subplot(1,2,1);
            for pos=1:size(jointAngle,1)
               plot3(pos_frame{1,7,finger}(pos,1),pos_frame{1,7,finger}(pos,2),pos_frame{1,7,finger}(pos,3),'-o', 'Color', [0.5 0 0])
               hold on
               pos_endEffector{1,finger}(pos,:,i) = pos_frame{1,7,finger}(pos,:);
            end
        elseif finger == 2 && i<17
            subplot(1,2,2);
            for pos=1:size(jointAngle,1)
               plot3(pos_frame{1,7,finger}(pos,1),pos_frame{1,7,finger}(pos,2),pos_frame{1,7,finger}(pos,3),'-o', 'Color', [0 0.2 0]) 
               hold on
               pos_endEffector{1,finger}(pos,:,i) = pos_frame{1,7,finger}(pos,:);
            end
        elseif finger==3 && i<17
            subplot(1,2,2);
            for pos=1:size(jointAngle,1)
               plot3(pos_frame{1,7,finger}(pos,1),pos_frame{1,7,finger}(pos,2),pos_frame{1,7,finger}(pos,3),'-o','Color',[0 0 1]) 
               hold on
               pos_endEffector{1,finger}(pos,:,i) = pos_frame{1,7,finger}(pos,:);
            end
        end
    end
end

% save data
save('training_test_data.mat', 'pos_calibZig', 'pos_endEffector')

% thumb 21�� position(x,y,z) 100 ��, 21*3*100
% CAD_thumb : 21�� x,y,z 21*3
% index 16�� position(x,y,z) 100 ��, 16*3*100
% CAD_index : 16�� x,y,z, 16*3
% middle 16�� position(x,y,z) 100��, 16*3*100
% CAD_middle : 16�� x,y,z, 16*3











