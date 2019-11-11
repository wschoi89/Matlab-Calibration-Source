%hand mocap kinematics simulator
clear
clc

angle_TH1 = -10:10:10;
angle_TH2 = 0:-10:-20;
angle_TH3 = 0:-10:-20;
%iteration number
count=1;
data = zeros(27, 14);
for i=1:length(angle_TH1)
    for j=1:length(angle_TH2)
        for k=1:length(angle_TH3)
            
            %create origin coordinate
            figure
            axis auto
            set(gca,'DataAspectRatio',[1 1 1])
            plot3([0 10],[0 0],[0 0],'r.-');
            hold on
            plot3([0 0],[0 10],[0 0],'g.-');
            hold on
            plot3([0 0],[0 0],[0 10],'b.-');
            hold on

            %load link lengths for thumb, index, and middle devices
            arr_links = loadLinkLength();

            %hand mocap device angle for one finger

            angle_device = [angle_TH1(i), angle_TH2(j), angle_TH3(k), 0];
            angle_offset = [0, 0, 0, 0];

            %convert degree to radian
            angle_device = angle_device*pi/180;
            angle_offset = angle_offset*pi/180;

            DHRef = [0 0         0             -pi/2;
                     0 angle_device(1)+angle_offset(1) arr_links(1,1) pi/2;
                     0 angle_device(2)+angle_offset(2) arr_links(2,1) 0;
                     0 -pi/2                           arr_links(3,1) 0;
                     0 angle_device(3)+angle_offset(3) arr_links(4,1) 0;
                     0 angle_device(4)+angle_offset(4) arr_links(5,1) 0;
                     0 -pi/2                           arr_links(6,1) 0;];

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
    
            subplot(2,2,1)
            %set origin coordinate
            plot3([0 10],[0 0],[0 0],'r.-');
            hold on
            plot3([0 0],[0 10],[0 0],'g.-');
            hold on
            plot3([0 0],[0 0],[0 10],'b.-');
            hold on
            plot3([pos_frame1(1) pos_frame2(1)],[pos_frame1(2) pos_frame2(2)],[pos_frame1(3) pos_frame2(3)],'black.-');
            hold on
            plot3([pos_frame2(1) pos_frame3(1)],[pos_frame2(2) pos_frame3(2)],[pos_frame2(3) pos_frame3(3)],'black.-');
            hold on
            plot3([pos_frame3(1) pos_frame4(1)],[pos_frame3(2) pos_frame4(2)],[pos_frame3(3) pos_frame4(3)],'black.-');
            hold on
            plot3([pos_frame4(1) pos_frame5(1)],[pos_frame4(2) pos_frame5(2)],[pos_frame4(3) pos_frame5(3)],'black.-');
            hold on
            plot3([pos_frame5(1) pos_frame6(1)],[pos_frame5(2) pos_frame6(2)],[pos_frame5(3) pos_frame6(3)],'black.-');
            hold on
            plot3([pos_frame6(1) pos_frame7(1)],[pos_frame6(2) pos_frame7(2)],[pos_frame6(3) pos_frame7(3)],'black.-');
            view(0, 90);title({'X-Y', strcat('pos : ', num2str(pos_frame7(1)), ', ', num2str(pos_frame7(2)), ', ', num2str(pos_frame7(3)))});
            
            subplot(2,2,2)
            %set origin coordinate
            plot3([0 10],[0 0],[0 0],'r.-');
            hold on
            plot3([0 0],[0 10],[0 0],'g.-');
            hold on
            plot3([0 0],[0 0],[0 10],'b.-');
            hold on
            plot3([pos_frame1(1) pos_frame2(1)],[pos_frame1(2) pos_frame2(2)],[pos_frame1(3) pos_frame2(3)],'black.-');
            hold on
            plot3([pos_frame2(1) pos_frame3(1)],[pos_frame2(2) pos_frame3(2)],[pos_frame2(3) pos_frame3(3)],'black.-');
            hold on
            plot3([pos_frame3(1) pos_frame4(1)],[pos_frame3(2) pos_frame4(2)],[pos_frame3(3) pos_frame4(3)],'black.-');
            hold on
            plot3([pos_frame4(1) pos_frame5(1)],[pos_frame4(2) pos_frame5(2)],[pos_frame4(3) pos_frame5(3)],'black.-');
            hold on
            plot3([pos_frame5(1) pos_frame6(1)],[pos_frame5(2) pos_frame6(2)],[pos_frame5(3) pos_frame6(3)],'black.-');
            hold on
            plot3([pos_frame6(1) pos_frame7(1)],[pos_frame6(2) pos_frame7(2)],[pos_frame6(3) pos_frame7(3)],'black.-');
            view(0, -180);title({'X-Z', strcat('angle : ', num2str(angle_device(1)*180/pi), ', ', num2str(angle_device(2)*180/pi), ', ', num2str(angle_device(3)*180/pi))});
            data(count, 9:11) = pos_frame7;
            %plot offset-reflecting link position
            %hand mocap device angle for one finger

            angle_device = [angle_TH1(i), angle_TH2(j), angle_TH3(k), 0];
            angle_offset = [10, 10, 10, 0];

            %convert degree to radian
            angle_device = angle_device*pi/180;
            angle_offset = angle_offset*pi/180;

            DHRef = [0 0         0             -pi/2;
                     0 angle_device(1)+angle_offset(1) arr_links(1,1) pi/2;
                     0 angle_device(2)+angle_offset(2) arr_links(2,1) 0;
                     0 -pi/2                           arr_links(3,1) 0;
                     0 angle_device(3)+angle_offset(3) arr_links(4,1) 0;
                     0 angle_device(4)+angle_offset(4) arr_links(5,1) 0;
                     0 -pi/2                           arr_links(6,1) 0;];

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
            
            
            subplot(2,2,3)
            %set origin coordinate
            plot3([0 10],[0 0],[0 0],'r.-');
            hold on
            plot3([0 0],[0 10],[0 0],'g.-');
            hold on
            plot3([0 0],[0 0],[0 10],'b.-');
            hold on
            plot3([pos_frame1(1) pos_frame2(1)],[pos_frame1(2) pos_frame2(2)],[pos_frame1(3) pos_frame2(3)],'black.-');
            hold on
            plot3([pos_frame2(1) pos_frame3(1)],[pos_frame2(2) pos_frame3(2)],[pos_frame2(3) pos_frame3(3)],'black.-');
            hold on
            plot3([pos_frame3(1) pos_frame4(1)],[pos_frame3(2) pos_frame4(2)],[pos_frame3(3) pos_frame4(3)],'black.-');
            hold on
            plot3([pos_frame4(1) pos_frame5(1)],[pos_frame4(2) pos_frame5(2)],[pos_frame4(3) pos_frame5(3)],'black.-');
            hold on
            plot3([pos_frame5(1) pos_frame6(1)],[pos_frame5(2) pos_frame6(2)],[pos_frame5(3) pos_frame6(3)],'black.-');
            hold on
            plot3([pos_frame6(1) pos_frame7(1)],[pos_frame6(2) pos_frame7(2)],[pos_frame6(3) pos_frame7(3)],'black.-');
            view(0, 90);title({'offset X-Y', strcat('pos : ', num2str(pos_frame7(1)), ', ', num2str(pos_frame7(2)), ', ', num2str(pos_frame7(3)))});
            
            subplot(2,2,4)
            %set origin coordinate
            plot3([0 10],[0 0],[0 0],'r.-');
            hold on
            plot3([0 0],[0 10],[0 0],'g.-');
            hold on
            plot3([0 0],[0 0],[0 10],'b.-');
            hold on
            plot3([pos_frame1(1) pos_frame2(1)],[pos_frame1(2) pos_frame2(2)],[pos_frame1(3) pos_frame2(3)],'black.-');
            hold on
            plot3([pos_frame2(1) pos_frame3(1)],[pos_frame2(2) pos_frame3(2)],[pos_frame2(3) pos_frame3(3)],'black.-');
            hold on
            plot3([pos_frame3(1) pos_frame4(1)],[pos_frame3(2) pos_frame4(2)],[pos_frame3(3) pos_frame4(3)],'black.-');
            hold on
            plot3([pos_frame4(1) pos_frame5(1)],[pos_frame4(2) pos_frame5(2)],[pos_frame4(3) pos_frame5(3)],'black.-');
            hold on
            plot3([pos_frame5(1) pos_frame6(1)],[pos_frame5(2) pos_frame6(2)],[pos_frame5(3) pos_frame6(3)],'black.-');
            hold on
            plot3([pos_frame6(1) pos_frame7(1)],[pos_frame6(2) pos_frame7(2)],[pos_frame6(3) pos_frame7(3)],'black.-');
            view(0, -180);title({'offset X-Z', strcat('offset angle : ', num2str(angle_offset(1)*180/pi), ', ', num2str(angle_offset(2)*180/pi), ', ', num2str(angle_offset(3)*180/pi))});
            
            saveas(gcf, strcat(num2str(count),'.jpg'));
            data(count, 1:4) = angle_device*180/pi;
            data(count, 5:8) = angle_offset*180/pi;
            data(count, 12:14) = pos_frame7;
            count=count+1;
        end
    end
end