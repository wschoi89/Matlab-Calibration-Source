%hand mocap kinematics simulator
clear
clc
disp('start')

% flag for whether it visualize kinematics graph or not
bool_plot_visualization = 0;
bool_plot_offset = 0;

% angle range for forward kinematics simulator
% set joint angles, TH1, TH2, TH3  by using random number generator between -30 and 30
% set joint angle,  TH4 by using random number generator between 0 and 90

combination_sample = [2,2,2,2];

angle_TH1 = -30+60*rand(combination_sample(1), 1);
angle_TH2 = -30+60*rand(combination_sample(2), 1);
angle_TH3 = -30+60*rand(combination_sample(3), 1);
angle_TH4 =     90*rand(combination_sample(4), 1);

%set offset angles by using random number generator between -20 and 20

angle_random = -20+40*rand(2);
angle_offset = [angle_random(1), angle_random(2), angle_random(3), angle_random(4)];
angle_offset = angle_offset*pi/180;

%set offset DH parameter lengths between -5 and 5 (mm)
length_DHoffset = -5+10*rand(1,10);
length_DHoffset = zeros(1,10);

%set offset DH parameter angles between -20 and 20 (degree)
angle_DHoffset = -20+40*rand(1,6);
angle_DHoffset = angle_DHoffset*pi/180;
angle_DHoffset = zeros(1, 6);


% concatenate above two arrays to save it. final shape is (1,16) array

% set offset for DH parameters and sensor rotation
DHparameter_offset = zeros(7, 4);

% assign offset values at DHparamter table
DHparameter_offset(1,1)=length_DHoffset(1); DHparameter_offset(1,2)=angle_DHoffset(1); DHparameter_offset(1,3)=length_DHoffset(2);  DHparameter_offset(1,4)=angle_DHoffset(2);
DHparameter_offset(2,1)=length_DHoffset(3);                                            DHparameter_offset(2,3)=length_DHoffset(4);  DHparameter_offset(2,4)=angle_DHoffset(3);
DHparameter_offset(3,1)=length_DHoffset(5);                                            DHparameter_offset(3,3)=length_DHoffset(6);  DHparameter_offset(3,4)=angle_DHoffset(4);

DHparameter_offset(5,1)=length_DHoffset(7);                                            DHparameter_offset(5,3)=length_DHoffset(8);  DHparameter_offset(5,4)=angle_DHoffset(5);
DHparameter_offset(6,1)=length_DHoffset(9);                                            DHparameter_offset(6,3)=length_DHoffset(10); DHparameter_offset(6,4)=angle_DHoffset(6);

% concat_DHoffset = cat(2, angle_offset, length_DHoffset, angle_DHoffset);  
concat_DHoffset = angle_offset;


save('offset.mat', 'concat_DHoffset');
disp('offset data was saved in offset.mat file');

%iteration number
count=1;

% the number of iteration for simulation
num_data = length(angle_TH1)*length(angle_TH2)*length(angle_TH3)*length(angle_TH4);

%data consists of 14 columns(angle(4), offset angle(4), tip position(reference)(3), tip position(reflecting offset)(3))
data = zeros(num_data, 14);

for i=1:length(angle_TH1)
    for j=1:length(angle_TH2)
        for k=1:length(angle_TH3)
            for m=1:length(angle_TH4)
            
                %create origin coordinate
%               %full screen 
%                 set(gcf, 'Position', get(0, 'Screensize'));
                
               
                %load link lengths for thumb, index, and middle devices
                arr_links = loadLinkLength();

                % hand mocap device angle for one finger
                angle_device = [angle_TH1(i), angle_TH2(j), angle_TH3(k), angle_TH4(m)];
                
                % initialize offset angle as zeros for non-offset forward
                % kinematics plot
                

                %convert degree to radian
                angle_device = angle_device*pi/180;
                

                %DH table
                DHRef = [0 0               0             -pi/2;
                         0 angle_device(1) arr_links(1,1) pi/2;
                         0 angle_device(2) arr_links(2,1) 0;
                         0 -pi/2           arr_links(3,1) 0;
                         0 angle_device(3) arr_links(4,1) 0;
                         0 angle_device(4) arr_links(5,1) 0;
                         0 -pi/2           arr_links(6,1) 0;];

                Origin = eye(4);
                %transformation matrix
                R01=transform_DH(DHRef, 1, 0);
                R12=transform_DH(DHRef, 2, 1);
                R23=transform_DH(DHRef, 3, 2);
                R34=transform_DH(DHRef, 4, 3);
                R45=transform_DH(DHRef, 5, 4);
                R56=transform_DH(DHRef, 6, 5);
                R67=transform_DH(DHRef, 7, 6);

                %transform matrix of frames with respect to Origin
                pos_Origin = [Origin(1,4);Origin(2,4);Origin(3,4);];
                frame1 = Origin*R01; pos_frame1 = [frame1(1,4);frame1(2,4);frame1(3,4);];
                frame2 = frame1*R12; pos_frame2 = [frame2(1,4);frame2(2,4);frame2(3,4);];
                frame3 = frame2*R23; pos_frame3 = [frame3(1,4);frame3(2,4);frame3(3,4);];
                frame4 = frame3*R34; pos_frame4 = [frame4(1,4);frame4(2,4);frame4(3,4);];
                frame5 = frame4*R45; pos_frame5 = [frame5(1,4);frame5(2,4);frame5(3,4);];
                frame6 = frame5*R56; pos_frame6 = [frame6(1,4);frame6(2,4);frame6(3,4);];
                frame7 = frame6*R67; pos_frame7 = [frame7(1,4);frame7(2,4);frame7(3,4);];

                
                % upper figure for non-offset forward kinematics plot(X-Y)
                
                if bool_plot_visualization == true
                    
                    upper_axes = subplot(2,1,1);
                    
                    %set origin coordiante using RGB 
                    plot3([0 10],[0 0],[0 0],'r.-','LineWidth', 2);
                    hold on
                    plot3([0 0],[0 10],[0 0],'g.-', 'LineWidth', 2);
                    hold on
                    plot3([0 0],[0 0],[0 10],'b.-', 'LineWidth', 2);
                    hold on
                    
                    % plot links for forward kinematics
                    plot3([pos_frame1(1) pos_frame2(1)],[pos_frame1(2) pos_frame2(2)],[pos_frame1(3) pos_frame2(3)],'black.-', 'LineWidth', 2);
                    hold on
                    plot3([pos_frame2(1) pos_frame3(1)],[pos_frame2(2) pos_frame3(2)],[pos_frame2(3) pos_frame3(3)],'black.-', 'LineWidth', 2);
                    hold on
                    plot3([pos_frame3(1) pos_frame4(1)],[pos_frame3(2) pos_frame4(2)],[pos_frame3(3) pos_frame4(3)],'black.-', 'LineWidth', 2);
                    hold on
                    plot3([pos_frame4(1) pos_frame5(1)],[pos_frame4(2) pos_frame5(2)],[pos_frame4(3) pos_frame5(3)],'black.-', 'LineWidth', 2);
                    hold on
                    plot3([pos_frame5(1) pos_frame6(1)],[pos_frame5(2) pos_frame6(2)],[pos_frame5(3) pos_frame6(3)],'black.-', 'LineWidth', 2);
                    hold on
                    endEffector_noOffset_xz= plot3([pos_frame6(1) pos_frame7(1)],[pos_frame6(2) pos_frame7(2)],[pos_frame6(3) pos_frame7(3)],'black.-', 'LineWidth', 2);
                    hold on
                    xlim([-50 200]);ylim([-200 50]);zlim([-100 100]);
                    
                    % plot points at joints
                    plot3(pos_frame1(1),pos_frame1(2),pos_frame1(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    plot3(pos_frame2(1),pos_frame2(2),pos_frame2(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    plot3(pos_frame3(1),pos_frame3(2),pos_frame3(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    plot3(pos_frame4(1),pos_frame4(2),pos_frame4(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    plot3(pos_frame5(1),pos_frame5(2),pos_frame5(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    plot3(pos_frame6(1),pos_frame6(2),pos_frame6(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    plot3(pos_frame7(1),pos_frame7(2),pos_frame7(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 1 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    
                    
                    % rotate view for X-Y plane
                    view(0, 90);

                    % lower figure for non-offset forward kinematics plot(X-Z)
                    lower_axes=subplot(2,1,2);
                    %set origin coordinate
                    plot3([0 10],[0 0],[0 0],'r.-');
                    hold on
                    plot3([0 0],[0 10],[0 0],'g.-');
                    hold on
                    plot3([0 0],[0 0],[0 10],'b.-');
                    hold on
                  
                    plot3([pos_frame1(1) pos_frame2(1)],[pos_frame1(2) pos_frame2(2)],[pos_frame1(3) pos_frame2(3)],'black.-', 'LineWidth', 2);
                    hold on
                    plot3([pos_frame2(1) pos_frame3(1)],[pos_frame2(2) pos_frame3(2)],[pos_frame2(3) pos_frame3(3)],'black.-', 'LineWidth', 2);
                    hold on
                    plot3([pos_frame3(1) pos_frame4(1)],[pos_frame3(2) pos_frame4(2)],[pos_frame3(3) pos_frame4(3)],'black.-', 'LineWidth', 2);
                    hold on
                    plot3([pos_frame4(1) pos_frame5(1)],[pos_frame4(2) pos_frame5(2)],[pos_frame4(3) pos_frame5(3)],'black.-', 'LineWidth', 2);
                    hold on
                    plot3([pos_frame5(1) pos_frame6(1)],[pos_frame5(2) pos_frame6(2)],[pos_frame5(3) pos_frame6(3)],'black.-', 'LineWidth', 2);
                    hold on
                    endEffector_noOffset_xy=plot3([pos_frame6(1) pos_frame7(1)],[pos_frame6(2) pos_frame7(2)],[pos_frame6(3) pos_frame7(3)],'black.-', 'LineWidth', 2);
                    hold on
                    
                    % plot points at joints
                    plot3(pos_frame1(1),pos_frame1(2),pos_frame1(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    plot3(pos_frame2(1),pos_frame2(2),pos_frame2(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    plot3(pos_frame3(1),pos_frame3(2),pos_frame3(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    plot3(pos_frame4(1),pos_frame4(2),pos_frame4(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    plot3(pos_frame5(1),pos_frame5(2),pos_frame5(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    plot3(pos_frame6(1),pos_frame6(2),pos_frame6(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    plot3(pos_frame7(1),pos_frame7(2),pos_frame7(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 1 0], 'MarkerEdgeColor', [0 0 0])
                    hold on
                    
%                     xlim([-50 200]);ylim([-200 50]);zlim([-100 100]);
                    view(0, -180);

                end
                data(count, 9:11) = pos_frame7;
                data(count, 15:18) = angle_device;
                                
                
                %% plot offset-reflecting link position
                  %hand mocap device angle for one finger

                angle_device = [angle_TH1(i), angle_TH2(j), angle_TH3(k), angle_TH4(m)];
                
                %convert degree to radian
                angle_device = angle_device*pi/180;
%                 angle_offset = angle_offset*pi/180;

                % add angle offset
                DHRef_offset = [0 0                               0             -pi/2;
                                0 angle_device(1)+angle_offset(1) arr_links(1,1) pi/2;
                                0 angle_device(2)+angle_offset(2) arr_links(2,1) 0;
                                0 -pi/2                           arr_links(3,1) 0;
                                0 angle_device(3)+angle_offset(3) arr_links(4,1) 0;
                                0 angle_device(4)+angle_offset(4) arr_links(5,1) 0;
                                0 -pi/2                           arr_links(6,1) 0;];
                     
                % add DH paramter offset
                DHRef_offset = DHRef_offset + DHparameter_offset;

                Origin = eye(4);
                %transformation matrix
                R01_offset=transform_DH(DHRef_offset, 1, 0);
                R12_offset=transform_DH(DHRef_offset, 2, 1);
                R23_offset=transform_DH(DHRef_offset, 3, 2);
                R34_offset=transform_DH(DHRef_offset, 4, 3);
                R45_offset=transform_DH(DHRef_offset, 5, 4);
                R56_offset=transform_DH(DHRef_offset, 6, 5);
                R67_offset=transform_DH(DHRef_offset, 7, 6);

                %transform matrix of frames with respect to Origin
                pos_Origin = [Origin(1,4);Origin(2,4);Origin(3,4);];
                frame1_offset = Origin*R01_offset;        pos_frame1_offset = [frame1_offset(1,4);frame1_offset(2,4);frame1_offset(3,4);];
                frame2_offset = frame1_offset*R12_offset; pos_frame2_offset = [frame2_offset(1,4);frame2_offset(2,4);frame2_offset(3,4);];
                frame3_offset = frame2_offset*R23_offset; pos_frame3_offset = [frame3_offset(1,4);frame3_offset(2,4);frame3_offset(3,4);];
                frame4_offset = frame3_offset*R34_offset; pos_frame4_offset = [frame4_offset(1,4);frame4_offset(2,4);frame4_offset(3,4);];
                frame5_offset = frame4_offset*R45_offset; pos_frame5_offset = [frame5_offset(1,4);frame5_offset(2,4);frame5_offset(3,4);];
                frame6_offset = frame5_offset*R56_offset; pos_frame6_offset = [frame6_offset(1,4);frame6_offset(2,4);frame6_offset(3,4);];
                frame7_offset = frame6_offset*R67_offset; pos_frame7_offset = [frame7_offset(1,4);frame7_offset(2,4);frame7_offset(3,4);];


            if bool_plot_visualization == true && bool_plot_offset == true
                subplot(2,1,1)
                
                plot3([pos_frame1_offset(1) pos_frame2_offset(1)],[pos_frame1_offset(2) pos_frame2_offset(2)],[pos_frame1_offset(3) pos_frame2_offset(3)],'r.-', 'LineWidth', 2);
                hold on
                plot3([pos_frame2_offset(1) pos_frame3_offset(1)],[pos_frame2_offset(2) pos_frame3_offset(2)],[pos_frame2_offset(3) pos_frame3_offset(3)],'r.-', 'LineWidth', 2);
                hold on
                plot3([pos_frame3_offset(1) pos_frame4_offset(1)],[pos_frame3_offset(2) pos_frame4_offset(2)],[pos_frame3_offset(3) pos_frame4_offset(3)],'r.-', 'LineWidth', 2);
                hold on
                plot3([pos_frame4_offset(1) pos_frame5_offset(1)],[pos_frame4_offset(2) pos_frame5_offset(2)],[pos_frame4_offset(3) pos_frame5_offset(3)],'r.-', 'LineWidth', 2);
                hold on
                plot3([pos_frame5_offset(1) pos_frame6_offset(1)],[pos_frame5_offset(2) pos_frame6_offset(2)],[pos_frame5_offset(3) pos_frame6_offset(3)],'r.-', 'LineWidth', 2);
                hold on
                endEffector_Offset_xz = plot3([pos_frame6_offset(1) pos_frame7_offset(1)],[pos_frame6_offset(2) pos_frame7_offset(2)],[pos_frame6_offset(3) pos_frame7_offset(3)],'r.-', 'LineWidth', 2);
                hold on
                
                % plot points at joints
                plot3(pos_frame1_offset(1),pos_frame1_offset(2),pos_frame1_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                plot3(pos_frame2_offset(1),pos_frame2_offset(2),pos_frame2_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                plot3(pos_frame3_offset(1),pos_frame3_offset(2),pos_frame3_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                plot3(pos_frame4_offset(1),pos_frame4_offset(2),pos_frame4_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                plot3(pos_frame5_offset(1),pos_frame5_offset(2),pos_frame5_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                plot3(pos_frame6_offset(1),pos_frame6_offset(2),pos_frame6_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                plot3(pos_frame7_offset(1),pos_frame7_offset(2),pos_frame7_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 1 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                
                view(0, 90);
                
                %distance between end-effectors
                distance = sqrt(sum((pos_frame7-pos_frame7_offset).^2));

                title({'X-Y', strcat('angle: ', num2str(angle_TH1), ', ', num2str(angle_TH2), ', ', num2str(angle_TH3), ', ', num2str(angle_TH4))});
                xlim([-50 200]);ylim([-200 50]);zlim([-100 100]);
                
                
                subplot(2,1,2)
                %set origin coordinate
%                 plot3([0 10],[0 0],[0 0],'r.-');
%                 hold on
%                 plot3([0 0],[0 10],[0 0],'g.-');
%                 hold on
%                 plot3([0 0],[0 0],[0 10],'b.-');
%                 hold on
                plot3([pos_frame1_offset(1) pos_frame2_offset(1)],[pos_frame1_offset(2) pos_frame2_offset(2)],[pos_frame1_offset(3) pos_frame2_offset(3)],'r.-', 'LineWidth', 2);
                hold on
                plot3([pos_frame2_offset(1) pos_frame3_offset(1)],[pos_frame2_offset(2) pos_frame3_offset(2)],[pos_frame2_offset(3) pos_frame3_offset(3)],'r.-', 'LineWidth', 2);
                hold on
                plot3([pos_frame3_offset(1) pos_frame4_offset(1)],[pos_frame3_offset(2) pos_frame4_offset(2)],[pos_frame3_offset(3) pos_frame4_offset(3)],'r.-', 'LineWidth', 2);
                hold on
                plot3([pos_frame4_offset(1) pos_frame5_offset(1)],[pos_frame4_offset(2) pos_frame5_offset(2)],[pos_frame4_offset(3) pos_frame5_offset(3)],'r.-', 'LineWidth', 2);
                hold on
                plot3([pos_frame5_offset(1) pos_frame6_offset(1)],[pos_frame5_offset(2) pos_frame6_offset(2)],[pos_frame5_offset(3) pos_frame6_offset(3)],'r.-', 'LineWidth', 2);
                hold on
                endEffector_Offset_xy=plot3([pos_frame6_offset(1) pos_frame7_offset(1)],[pos_frame6_offset(2) pos_frame7_offset(2)],[pos_frame6_offset(3) pos_frame7_offset(3)],'r.-', 'LineWidth', 2);
                hold on

                % plot points at joints
                plot3(pos_frame1_offset(1),pos_frame1_offset(2),pos_frame1_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                plot3(pos_frame2_offset(1),pos_frame2_offset(2),pos_frame2_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                plot3(pos_frame3_offset(1),pos_frame3_offset(2),pos_frame3_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                plot3(pos_frame4_offset(1),pos_frame4_offset(2),pos_frame4_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                plot3(pos_frame5_offset(1),pos_frame5_offset(2),pos_frame5_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                plot3(pos_frame6_offset(1),pos_frame6_offset(2),pos_frame6_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                plot3(pos_frame7_offset(1),pos_frame7_offset(2),pos_frame7_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 1 0], 'MarkerEdgeColor', [1 0 0])
                hold on
                
                view(0, -180);
                title({'X-Z', strcat('distance between end-effectors: ', num2str(distance), ' mm')});
%                 title({'offset X-Z', strcat('offset angle : ', num2str(angle_offset(1)*180/pi), ', ', num2str(angle_offset(2)*180/pi), ', ', num2str(angle_offset(3)*180/pi), ', ', num2str(angle_offset(4)*180/pi))});
                % set figure axis limit
%                 xlim([-50 200]);ylim([-200 50]);zlim([-100 100]);
            end
                
%                 saveas(gcf, strcat(num2str(count),'.jpg'));
                data(count, 1:4) = angle_device;
                data(count, 5:8) = angle_offset;
                data(count, 12:14) = pos_frame7_offset;
                
                count=count+1;
                
%                 
%                 
%                 subplot(2, 1, 1)
%                 cla reset
%                 subplot(2, 1, 2)
%                 cla reset
                
            end
        end
    end
end

% add legend depending on visualization flag
if bool_plot_visualization == true && bool_plot_offset == true
    legend(upper_axes, [endEffector_noOffset_xz endEffector_Offset_xz], {'OFFSET X','OFFSET O'});
    legend(lower_axes, [endEffector_noOffset_xy endEffector_Offset_xy], {'OFFSET X','OFFSET O'});
end
% endEffector_noOffset_xy
save('data.mat', 'data');
disp('data was saved in data.mat file')
disp('finish')
% close all