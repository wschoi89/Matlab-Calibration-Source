
% disp('start')
% load data.mat

data = testData;
%iteration number
count=1;

% num_row = length(angle_TH1)*length(angle_TH2)*length(angle_TH3)*length(angle_TH4);
num_row = size(data, 1);

%data consists of 18 columns(angle(4), offset angle(4), tip
%position(cad)(3), tip position(reflecting offset)(3), joint angle(4))

sum_distance = 0;
for i=1:size(data, 1)
            
                %create origin coordinate
%                 figure
                %full screen 
                set(gcf, 'Position', get(0, 'Screensize'));
                set(gca,'DataAspectRatio',[1 1 1])
               
                %load link lengths for thumb, index, and middle devices
                arr_links = loadLinkLength();

                % hand mocap device angle for one finger
                angle_device = [data(i, 15),data(i, 16),data(i,17),data(i,18)];
                
                % initialize offset angle as zeros for non-offset forward
                % kinematics plot
%                 angle_offset = [0, 0, 0, 0];

                %convert degree to radian
%                 angle_device = angle_device*pi/180;
%                 angle_offset = angle_offset*pi/180;
                
                DH_offset_simulationResult = zeros(7, 4);
                load parameter_output.mat
                angle_offset = zeros(1,4);
                simulationResult = output;
                angle_offset(1) = simulationResult(1);
                angle_offset(2) = simulationResult(2);
                angle_offset(3) = simulationResult(3);
                angle_offset(4) = simulationResult(4);
                
                %DH table
                DHRef = [0 0                               0             -pi/2;
                         0 angle_device(1)+angle_offset(1) arr_links(1,1) pi/2;
                         0 angle_device(2)+angle_offset(2) arr_links(2,1) 0;
                         0 -pi/2                           arr_links(3,1) 0;
                         0 angle_device(3)+angle_offset(3) arr_links(4,1) 0;
                         0 angle_device(4)+angle_offset(4) arr_links(5,1) 0;
                         0 -pi/2                           arr_links(6,1) 0;];
                  
                DHRef = DHRef+DH_offset_simulationResult;
                     
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

%                 upper figure for non-offset forward kinematics plot(X-Y)
                upper_axes=subplot(2,1,1);
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
                endEffector_optimization_xz=plot3([pos_frame6(1) pos_frame7(1)],[pos_frame6(2) pos_frame7(2)],[pos_frame6(3) pos_frame7(3)],'black.-', 'LineWidth', 2);
                hold on
                
                % plot points at joints
                plot3(pos_frame1(1),pos_frame1(2),pos_frame1(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0])
                hold on
                plot3(pos_frame2(1),pos_frame2(2),pos_frame2(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0])
                hold on
                plot3(pos_frame3(1),pos_frame3(2),pos_frame3(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0])
                hold on
                plot3(pos_frame4(1),pos_frame4(2),pos_frame4(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0])
                hold on
                plot3(pos_frame5(1),pos_frame5(2),pos_frame5(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0])
                hold on
                plot3(pos_frame6(1),pos_frame6(2),pos_frame6(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0])
                hold on
                plot3(pos_frame7(1),pos_frame7(2),pos_frame7(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0],'MarkerEdgeColor', [0 0 0])
                hold on
                
                
                
                % rotate view for X-Y plane
                view(0, 90);

%               % lower figure for non-offset forward kinematics plot(X-Z)
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
                endEffector_optimization_xy=plot3([pos_frame6(1) pos_frame7(1)],[pos_frame6(2) pos_frame7(2)],[pos_frame6(3) pos_frame7(3)],'black.-', 'LineWidth', 2);
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
                plot3(pos_frame7(1),pos_frame7(2),pos_frame7(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
                hold on
                
                view(0, -180);
				%title({'X-Z', strcat('angle : ', num2str(angle_device(1)*180/pi), ', ', num2str(angle_device(2)*180/pi), ', ', num2str(angle_device(3)*180/pi), ', ', num2str(angle_device(4)*180/pi))});
                data(count, 9:11) = pos_frame7;
                
                
                %plot offset-reflecting link position
                %hand mocap device angle for one finger

                angle_device = [data(i, 15),data(i, 16),data(i,17),data(i,18)];
                load offset.mat
                angle_offset = [concat_DHoffset(1), concat_DHoffset(2), concat_DHoffset(3), concat_DHoffset(4)];
                DHparameter_offset = zeros(7, 4);

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


                subplot(2,1,1)
                %set origin coordinate
                plot3([0 10],[0 0],[0 0],'r.-');
                hold on
                plot3([0 0],[0 10],[0 0],'g.-');
                hold on
                plot3([0 0],[0 0],[0 10],'b.-');
                hold on
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
                endEffector_offset_xz=plot3([pos_frame6_offset(1) pos_frame7_offset(1)],[pos_frame6_offset(2) pos_frame7_offset(2)],[pos_frame6_offset(3) pos_frame7_offset(3)],'r.-', 'LineWidth', 2);
                
                hold on
                
                % plot points at joints
                plot3(pos_frame1_offset(1),pos_frame1_offset(2),pos_frame1_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                plot3(pos_frame2_offset(1),pos_frame2_offset(2),pos_frame2_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                plot3(pos_frame3_offset(1),pos_frame3_offset(2),pos_frame3_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                plot3(pos_frame4_offset(1),pos_frame4_offset(2),pos_frame4_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                plot3(pos_frame5_offset(1),pos_frame5_offset(2),pos_frame5_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                plot3(pos_frame6_offset(1),pos_frame6_offset(2),pos_frame6_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                plot3(pos_frame7_offset(1),pos_frame7_offset(2),pos_frame7_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                
                view(0, 90);
                distance = sqrt(sum((pos_frame7-pos_frame7_offset).^2));
%                 title({'X-Y', 'distance: ', num2str(distance), strcat('pos: ', num2str(pos_frame7(1)), ', ', num2str(pos_frame7(2)), ', ', num2str(pos_frame7(3)), strcat(', offset pos :', num2str(pos_frame7_offset(1)), ', ', num2str(pos_frame7_offset(2)), ', ', num2str(pos_frame7_offset(3))))});
                
                xlim([-50 200]);ylim([-200 50]);zlim([-100 100]);
                
                
                subplot(2,1,2)
                %set origin coordinate
                plot3([0 10],[0 0],[0 0],'r.-');
                hold on
                plot3([0 0],[0 10],[0 0],'g.-');
                hold on
                plot3([0 0],[0 0],[0 10],'b.-');
                hold on
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
                endEffector_offset_xy=plot3([pos_frame6_offset(1) pos_frame7_offset(1)],[pos_frame6_offset(2) pos_frame7_offset(2)],[pos_frame6_offset(3) pos_frame7_offset(3)],'r.-', 'LineWidth', 2);
                
                hold on
                % plot points at joints
                plot3(pos_frame1_offset(1),pos_frame1_offset(2),pos_frame1_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                plot3(pos_frame2_offset(1),pos_frame2_offset(2),pos_frame2_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                plot3(pos_frame3_offset(1),pos_frame3_offset(2),pos_frame3_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                plot3(pos_frame4_offset(1),pos_frame4_offset(2),pos_frame4_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                plot3(pos_frame5_offset(1),pos_frame5_offset(2),pos_frame5_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                plot3(pos_frame6_offset(1),pos_frame6_offset(2),pos_frame6_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                plot3(pos_frame7_offset(1),pos_frame7_offset(2),pos_frame7_offset(3), '-o', 'MarkerSize', 8, 'MarkerFaceColor', [1 0 0])
                hold on
                
                
                
                view(0, -180);
%                 title({'offset X-Z', strcat('offset angle : ', num2str(angle_offset(1)*180/pi), ', ', num2str(angle_offset(2)*180/pi), ', ', num2str(angle_offset(3)*180/pi), ', ', num2str(angle_offset(4)*180/pi))});
                % set figure axis limit
                xlim([-50 200]);ylim([-200 50]);zlim([-100 100]);
                
                
%                 data(count, 1:4) = angle_device;
%                 data(count, 5:8) = angle_offset;
%                 data(count, 12:14) = pos_frame7_offset;
                
               
                
                legend(upper_axes, [endEffector_optimization_xz endEffector_offset_xz], {'Optimized OFFSET','Global OFFSET'});
                legend(lower_axes, [endEffector_optimization_xy endEffector_offset_xy], {'Optimized OFFSET','Global OFFSET'});
                
                %distance between end-effectors
                distance = sqrt(sum((pos_frame7-pos_frame7_offset).^2));
                sum_distance = sum_distance + distance;         
                subplot(2, 1, 1)
                title({'X-Y', strcat('distance: ', num2str(distance), ' mm')});
%                 saveas(gcf, strcat(num2str(count),'.jpg'));
                 count=count+1;
                cla reset
                subplot(2, 1, 2)
                cla reset
                

end

average_distance = sum_distance / size(data, 1)


