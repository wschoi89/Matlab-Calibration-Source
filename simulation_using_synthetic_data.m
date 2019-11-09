% Simulation using synthetic data
clear
clc
close all

%load link lengths for thumb, index, and middle devices
arr_links = loadLinkLength();

axis([0 100 -100 20 -150 150]);
view([180, -90])
hold on

% syms A1 B1 C1 D1 
% syms A2 B2 C2 D2  
% syms A3 B3 C3 D3  
% syms A4 B4 C4 D4  
% syms A5 B5 C5 D5  
% syms A6 B6 C6 D6  
% syms A7 B7 C7 D7

syms off_TH1 off_TH2 off_TH3 off_TH4 %device angle offset by sensor misalingment

% CAD DH paramter(joint offset, joint angle, link length, link twist)
% DHRef = [0 0             arr_links(1,1) -pi/2;
%          0 B2+off_TH1    arr_links(2,1) pi/2;
%          0 B3+off_TH2    arr_links(3,1) 0;
%          0 -pi/2         arr_links(4,1) 0;
%          0 B5+off_TH3    arr_links(5,1) 0;
%          0 B6+off_TH4    arr_links(6,1) 0;
%          0 -pi/2         arr_links(7,1) 0;];
% 
% R01=transl(0,0,DHRef(1,1))*[cos(DHRef(1,2)) -sin(DHRef(1,2)) 0 0; sin(DHRef(1,2)) cos(DHRef(1,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(1,3),0,0)*[1 0 0 0; 0 cos(DHRef(1,4)) -sin(DHRef(1,4)) 0; 0 sin(DHRef(1,4)) cos(DHRef(1,4)) 0; 0 0 0 1]

DH_table = [0 0     0              -pi/2;
            0 0     arr_links(1,1)  pi/2;
            0 0     arr_links(2,1)  0;
            0 -pi/2 arr_links(3,1)  0;
            0 0     arr_links(4,1)  0;
            0 0     arr_links(5,1)  0;
            0 -pi/2 arr_links(6,1)  0;];

Origin = eye(4);

%offset 각도 없을 때의 reference position
pos_reference = [27.369;89.664;4.826;];


%transformation matrix using DH paramter table
R01=transform_DH(DH_table, 1, 0);
R12=transform_DH(DH_table, 2, 1);
R23=transform_DH(DH_table, 3, 2);
R34=transform_DH(DH_table, 4, 3);
R45=transform_DH(DH_table, 5, 4);
R56=transform_DH(DH_table, 6, 5);
R67=transform_DH(DH_table, 7, 6);

%transform matrix of frames with respect to Origin
pos_Origin = [Origin(1,4);Origin(2,4);Origin(3,4);];
frame1 = Origin*R01; pos_frame1 = [frame1(1,4);frame1(2,4);frame1(3,4);];
frame2 = frame1*R12; pos_frame2 = [frame2(1,4);frame2(2,4);frame2(3,4);];
frame3 = frame2*R23; pos_frame3 = [frame3(1,4);frame3(2,4);frame3(3,4);];
frame4 = frame3*R34; pos_frame4 = [frame4(1,4);frame4(2,4);frame4(3,4);];
frame5 = frame4*R45; pos_frame5 = [frame5(1,4);frame5(2,4);frame5(3,4);];
frame6 = frame5*R56; pos_frame6 = [frame6(1,4);frame6(2,4);frame6(3,4);];
frame7 = frame6*R67; pos_frame7 = [frame7(1,4);frame7(2,4);frame7(3,4);];

plot3([pos_frame1(1) pos_frame2(1)],[pos_frame1(2) pos_frame2(2)],[pos_frame1(3) pos_frame2(3)],'r.-');
hold on
plot3([pos_frame2(1) pos_frame3(1)],[pos_frame2(2) pos_frame3(2)],[pos_frame2(3) pos_frame3(3)],'b.-');
hold on
plot3([pos_frame3(1) pos_frame4(1)],[pos_frame3(2) pos_frame4(2)],[pos_frame3(3) pos_frame4(3)],'r.-');
hold on
plot3([pos_frame4(1) pos_frame5(1)],[pos_frame4(2) pos_frame5(2)],[pos_frame4(3) pos_frame5(3)],'b.-');
hold on
plot3([pos_frame5(1) pos_frame6(1)],[pos_frame5(2) pos_frame6(2)],[pos_frame5(3) pos_frame6(3)],'r.-');
hold on
plot3([pos_frame6(1) pos_frame7(1)],[pos_frame6(2) pos_frame7(2)],[pos_frame6(3) pos_frame7(3)],'b.-');





