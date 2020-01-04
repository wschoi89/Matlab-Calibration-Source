clear
clc

%load link lengths for thumb, index, and middle devices
arr_links = loadLinkLength();

num_joint = 7;
num_param_per_joint = 4;
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

DH_table = zeros(num_joint, num_param_per_joint, num_fingers);
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
    
    %transformation matrix
    mat_transform{1, 1, finger}=transform_DH(DH_table(:,:,finger), 1, 0);
    mat_transform{1, 2, finger}=transform_DH(DH_table(:,:,finger), 2, 1);
    mat_transform{1, 3, finger}=transform_DH(DH_table(:,:,finger), 3, 2);
    mat_transform{1, 4, finger}=transform_DH(DH_table(:,:,finger), 4, 3);
    mat_transform{1, 5, finger}=transform_DH(DH_table(:,:,finger), 5, 4);
    mat_transform{1, 6, finger}=transform_DH(DH_table(:,:,finger), 6, 5);
    mat_transform{1, 7, finger}=transform_DH(DH_table(:,:,finger), 7, 6);
    
    frame{1, 1, finger} = Origin(:,:,finger)*cell2mat(mat_transform(1,1,finger));
    frame{1, 2, finger} = cell2mat(frame(1,1,finger))*cell2mat(mat_transform(1,2,finger));
    frame{1, 3, finger} = cell2mat(frame(1,2,finger))*cell2mat(mat_transform(1,3,finger));
    frame{1, 4, finger} = cell2mat(frame(1,3,finger))*cell2mat(mat_transform(1,4,finger));
    frame{1, 5, finger} = cell2mat(frame(1,4,finger))*cell2mat(mat_transform(1,5,finger));
    frame{1, 6, finger} = cell2mat(frame(1,5,finger))*cell2mat(mat_transform(1,6,finger));
    frame{1, 7, finger} = cell2mat(frame(1,6,finger))*cell2mat(mat_transform(1,7,finger));
    
    pos_frame{1,1,finger} = [frame{1,1,finger}(1,4);frame{1,1,finger}(2,4);frame{1,1,finger}(3,4)];
    pos_frame{1,2,finger} = [frame{1,2,finger}(1,4);frame{1,2,finger}(2,4);frame{1,2,finger}(3,4)];
    pos_frame{1,3,finger} = [frame{1,3,finger}(1,4);frame{1,3,finger}(2,4);frame{1,3,finger}(3,4)];
    pos_frame{1,4,finger} = [frame{1,4,finger}(1,4);frame{1,4,finger}(2,4);frame{1,4,finger}(3,4)];
    pos_frame{1,5,finger} = [frame{1,5,finger}(1,4);frame{1,5,finger}(2,4);frame{1,5,finger}(3,4)];
    pos_frame{1,6,finger} = [frame{1,6,finger}(1,4);frame{1,6,finger}(2,4);frame{1,6,finger}(3,4)];
    pos_frame{1,7,finger} = [frame{1,7,finger}(1,4);frame{1,7,finger}(2,4);frame{1,7,finger}(3,4)];
end

% plot
for finger=1:num_fingers
    
    plot3([Origin(1,4,finger) pos_frame{1,1,finger}(1)],[Origin(2,4,finger) pos_frame{1,1,finger}(2)],[Origin(3,4,finger) pos_frame{1,1,finger}(3)],'black.-', 'LineWidth', 2);
    hold on
    plot3([pos_frame{1,1,finger}(1) pos_frame{1,2,finger}(1)],[pos_frame{1,1,finger}(2) pos_frame{1,2,finger}(2)],[pos_frame{1,1,finger}(3) pos_frame{1,2,finger}(3)],'black.-', 'LineWidth', 2);
    hold on
    plot3([pos_frame{1,2,finger}(1) pos_frame{1,3,finger}(1)],[pos_frame{1,2,finger}(2) pos_frame{1,3,finger}(2)],[pos_frame{1,2,finger}(3) pos_frame{1,3,finger}(3)],'black.-', 'LineWidth', 2);
    hold on
    plot3([pos_frame{1,3,finger}(1) pos_frame{1,4,finger}(1)],[pos_frame{1,3,finger}(2) pos_frame{1,4,finger}(2)],[pos_frame{1,3,finger}(3) pos_frame{1,4,finger}(3)],'black.-', 'LineWidth', 2);
    hold on
    plot3([pos_frame{1,4,finger}(1) pos_frame{1,5,finger}(1)],[pos_frame{1,4,finger}(2) pos_frame{1,5,finger}(2)],[pos_frame{1,4,finger}(3) pos_frame{1,5,finger}(3)],'black.-', 'LineWidth', 2);
    hold on
    plot3([pos_frame{1,5,finger}(1) pos_frame{1,6,finger}(1)],[pos_frame{1,5,finger}(2) pos_frame{1,6,finger}(2)],[pos_frame{1,5,finger}(3) pos_frame{1,6,finger}(3)],'black.-', 'LineWidth', 2);
    hold on
    plot3([pos_frame{1,6,finger}(1) pos_frame{1,7,finger}(1)],[pos_frame{1,6,finger}(2) pos_frame{1,7,finger}(2)],[pos_frame{1,6,finger}(3) pos_frame{1,7,finger}(3)],'black.-', 'LineWidth', 2);
    hold on
    
%     plot3([pos_frame2(1) pos_frame3(1)],[pos_frame2(2) pos_frame3(2)],[pos_frame2(3) pos_frame3(3)],'black.-', 'LineWidth', 2);
%     hold on
%     plot3([pos_frame3(1) pos_frame4(1)],[pos_frame3(2) pos_frame4(2)],[pos_frame3(3) pos_frame4(3)],'black.-', 'LineWidth', 2);
%     hold on
%     plot3([pos_frame4(1) pos_frame5(1)],[pos_frame4(2) pos_frame5(2)],[pos_frame4(3) pos_frame5(3)],'black.-', 'LineWidth', 2);
%     hold on
%     plot3([pos_frame5(1) pos_frame6(1)],[pos_frame5(2) pos_frame6(2)],[pos_frame5(3) pos_frame6(3)],'black.-', 'LineWidth', 2);
%     hold on
%     endEffector_noOffset_xz= plot3([pos_frame6(1) pos_frame7(1)],[pos_frame6(2) pos_frame7(2)],[pos_frame6(3) pos_frame7(3)],'black.-', 'LineWidth', 2);
%     hold on
end





