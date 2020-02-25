% Simulation using synthetic data
% clear
% clc
% close all

%load link lengths for thumb, index, and middle devices
arr_links = loadLinkLength();

syms off_TH1 off_TH2 off_TH3 off_TH4 %% device angle offset by sensor misalingment
syms A1 B1 C1 D1
syms A2    C2 D2
syms A3    C3 D3
syms A5    C5 D5
syms A6    C6 D6
syms B2 B3 B5 B6 %% joint angle 


% DH table
DHRef_thumb = [0+A1 B1       C1              -pi/2+D1;
         0+A2 B2+off_TH1       arr_links(1,1)+C2  pi/2+D2;
         0+A3 B3+off_TH2       arr_links(2,1)+C3  0+D3;
         0    -pi/2    arr_links(3,1)     0;
         0+A5 B5+off_TH3       arr_links(4,1)+C5  0+D5;
         0+A6 B6+off_TH4       arr_links(5,1)+C6  0+D6;
         0    -pi/2    arr_links(6,1)     0;];
     
DHRef_index = [0+A1 B1       C1              -pi/2+D1;
               0+A2 B2+off_TH1       arr_links(1,2)+C2  pi/2+D2;
               0+A3 B3+off_TH2       arr_links(2,2)+C3  0+D3;
               0    -pi/2            arr_links(3,2)     0;
               0+A5 B5+off_TH3       arr_links(4,2)+C5  0+D5;
               0+A6 B6+off_TH4       arr_links(5,2)+C6  0+D6;
               0    -pi/2            arr_links(6,2)     0;];
           
DHRef_middle = [0+A1 B1       C1              -pi/2+D1;
               0+A2 B2+off_TH1       arr_links(1,3)+C2  pi/2+D2;
               0+A3 B3+off_TH2       arr_links(2,3)+C3  0+D3;
               0    -pi/2            arr_links(3,3)     0;
               0+A5 B5+off_TH3       arr_links(4,3)+C5  0+D5;
               0+A6 B6+off_TH4       arr_links(5,3)+C6  0+D6;
               0    -pi/2            arr_links(6,3)     0;];

Origin_TH = eye(4)*transform_thumb_wrt_index;
Origin = eye(4);
Origin_MI = eye(4)*transl(0,0,19);

%transformation matrix between frames (thumb)
R01_TH = transform_DH(DHRef_thumb, 1, 0);
R12_TH = transform_DH(DHRef_thumb, 2, 1);
R23_TH = transform_DH(DHRef_thumb, 3, 2);
R34_TH = transform_DH(DHRef_thumb, 4, 3);
R45_TH = transform_DH(DHRef_thumb, 5, 4);
R56_TH = transform_DH(DHRef_thumb, 6, 5);
R67_TH = transform_DH(DHRef_thumb, 7, 6);

%transformation matrix between frames (index)
R01=transform_DH(DHRef_index, 1, 0);
R12=transform_DH(DHRef_index, 2, 1);
R23=transform_DH(DHRef_index, 3, 2);
R34=transform_DH(DHRef_index, 4, 3);
R45=transform_DH(DHRef_index, 5, 4);
R56=transform_DH(DHRef_index, 6, 5);
R67=transform_DH(DHRef_index, 7, 6);

%transformation matrix between frames (middle)
R01_MI = transform_DH(DHRef_middle, 1, 0);
R12_MI = transform_DH(DHRef_middle, 2, 1);
R23_MI = transform_DH(DHRef_middle, 3, 2);
R34_MI = transform_DH(DHRef_middle, 4, 3);
R45_MI = transform_DH(DHRef_middle, 5, 4);
R56_MI = transform_DH(DHRef_middle, 6, 5);
R67_MI = transform_DH(DHRef_middle, 7, 6);


%transform matrix of frames with respect to Origin (thumb)
pos_Origin_TH = [Origin_TH(1,4);Origin_TH(2,4);Origin_TH(3,4);];
frame1_TH = Origin_TH*R01_TH; pos_frame1_TH = [frame1_TH(1,4);frame1_TH(2,4);frame1_TH(3,4);];
frame2_TH = frame1_TH*R12_TH; pos_frame2_TH = [frame2_TH(1,4);frame2_TH(2,4);frame2_TH(3,4);];
frame3_TH = frame2_TH*R23_TH; pos_frame3_TH = [frame3_TH(1,4);frame3_TH(2,4);frame3_TH(3,4);];
frame4_TH = frame3_TH*R34_TH; pos_frame4_TH = [frame4_TH(1,4);frame4_TH(2,4);frame4_TH(3,4);];
frame5_TH = frame4_TH*R45_TH; pos_frame5_TH = [frame5_TH(1,4);frame5_TH(2,4);frame5_TH(3,4);];
frame6_TH = frame5_TH*R56_TH; pos_frame6_TH = [frame6_TH(1,4);frame6_TH(2,4);frame6_TH(3,4);];
frame7_TH = frame6_TH*R67_TH; pos_frame7_TH = [frame7_TH(1,4);frame7_TH(2,4);frame7_TH(3,4);];



%transform matrix of frames with respect to Origin (index)
pos_Origin = [Origin(1,4);Origin(2,4);Origin(3,4);];
frame1 = Origin*R01; pos_frame1 = [frame1(1,4);frame1(2,4);frame1(3,4);];
frame2 = frame1*R12; pos_frame2 = [frame2(1,4);frame2(2,4);frame2(3,4);];
frame3 = frame2*R23; pos_frame3 = [frame3(1,4);frame3(2,4);frame3(3,4);];
frame4 = frame3*R34; pos_frame4 = [frame4(1,4);frame4(2,4);frame4(3,4);];
frame5 = frame4*R45; pos_frame5 = [frame5(1,4);frame5(2,4);frame5(3,4);];
frame6 = frame5*R56; pos_frame6 = [frame6(1,4);frame6(2,4);frame6(3,4);];
frame7 = frame6*R67; pos_frame7 = [frame7(1,4);frame7(2,4);frame7(3,4);];

%transform matrix of frames with respect to Origin (middle)
pos_Origin_MI = [Origin_MI(1,4);Origin_MI(2,4);Origin_MI(3,4);];
frame1_MI = Origin_MI*R01_MI; pos_frame1_MI = [frame1_MI(1,4);frame1_MI(2,4);frame1_MI(3,4);];
frame2_MI = frame1_MI*R12_MI; pos_frame2_MI = [frame2_MI(1,4);frame2_MI(2,4);frame2_MI(3,4);];
frame3_MI = frame2_MI*R23_MI; pos_frame3_MI = [frame3_MI(1,4);frame3_MI(2,4);frame3_MI(3,4);];
frame4_MI = frame3_MI*R34_MI; pos_frame4_MI = [frame4_MI(1,4);frame4_MI(2,4);frame4_MI(3,4);];
frame5_MI = frame4_MI*R45_MI; pos_frame5_MI = [frame5_MI(1,4);frame5_MI(2,4);frame5_MI(3,4);];
frame6_MI = frame5_MI*R56_MI; pos_frame6_MI = [frame6_MI(1,4);frame6_MI(2,4);frame6_MI(3,4);];
frame7_MI = frame6_MI*R67_MI; pos_frame7_MI = [frame7_MI(1,4);frame7_MI(2,4);frame7_MI(3,4);];


% set degree of precision
pos_frame1_TH = vpa(pos_frame1_TH, 5);
pos_frame2_TH = vpa(pos_frame2_TH, 5);
pos_frame3_TH = vpa(pos_frame3_TH, 5);
pos_frame4_TH = vpa(pos_frame4_TH, 5);
pos_frame5_TH = vpa(pos_frame5_TH, 5);
pos_frame6_TH = vpa(pos_frame6_TH, 5);
pos_frame7_TH = vpa(pos_frame7_TH, 5)

pos_frame1 = vpa(pos_frame1, 5);
pos_frame2 = vpa(pos_frame2, 5);
pos_frame3 = vpa(pos_frame3, 5);
pos_frame4 = vpa(pos_frame4, 5);
pos_frame5 = vpa(pos_frame5, 5);
pos_frame6 = vpa(pos_frame6, 5);
pos_frame7 = vpa(pos_frame7, 5);

pos_frame1_MI = vpa(pos_frame1_MI, 5);
pos_frame2_MI = vpa(pos_frame2_MI, 5);
pos_frame3_MI = vpa(pos_frame3_MI, 5);
pos_frame4_MI = vpa(pos_frame4_MI, 5);
pos_frame5_MI = vpa(pos_frame5_MI, 5);
pos_frame6_MI = vpa(pos_frame6_MI, 5);
pos_frame7_MI = vpa(pos_frame7_MI, 5);

