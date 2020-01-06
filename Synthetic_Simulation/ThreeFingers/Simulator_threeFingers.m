clear
clc
close all

%load link lengths for thumb, index, and middle devices
arr_links = loadLinkLength();

num_joints = 7;
num_param_per_joint = 4; % DH parameter
num_fingers = 3;

% set each finger's origin position
Origin_index = eye(4);
% reason? depending on the cad model??
Origin_thumb = Origin_index*transl(-88.75,-29.04,-24.35)*trotz(24*pi/180)*trotx(-75*pi/180)*troty(54*pi/180)*trotz(45*pi/180);
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

for finger=1:num_fingers
%     angle_TH1(i) = -30+60*rand(1);
%     angle_TH2(j) = -30+60*rand(1);
%     angle_TH3(k) = -30+60*rand(1);
%     angle_TH4(m) =  90*rand(1);
%     angle_device = [angle_TH1(i), angle_TH2(j), angle_TH3(k), angle_TH4(m)];
    DH_temp = DH_ref;
    DH_temp(2:end, 3) = arr_links(:,finger);
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
        pos_frame{1,joint,finger}=[frame{1,joint,finger}(1,4);frame{1,joint,finger}(2,4);frame{1,joint,finger}(3,4)];
    end
end

% plot three fingers
plotThreeFingers(Origin, pos_frame)

% load positions for CAD zig
load pos_calibration.mat

% plot positions for CAD zig
color_position = {[0 0 0], [1 0 0], [0 0 1]};
for finger=1:num_fingers
    for row=1:size(pos_calibZig{1,finger}, 1)
        plot3(pos_calibZig{1,finger}(row,1), pos_calibZig{1,finger}(row,2), pos_calibZig{1,finger}(row,3), '-o','MarkerSize',4,'MarkerFaceColor', color_position{finger}, 'MarkerEdgeColor', color_position{finger})
        hold on
    end
end







