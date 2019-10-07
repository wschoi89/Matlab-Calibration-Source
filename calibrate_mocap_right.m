function calibrate_mocap_right(lambda, offset, calibration)

halfpi = pi / 2;

syms A0_TH B0_TH C0_TH D0_TH E0_TH F0_TH ...
     A0_MI B0_MI C0_MI D0_MI E0_MI F0_MI ...
     A1 B1 C1 D1 A2 B2 C2 D2 A3 B3 C3 D3 A4 B4 C4 D4 ...
     A5 B5 C5 D5 A6 B6 C6 D6 A7 B7 C7 D7 A8 B8 C8 D8 ...
     A1_TH B1_TH C1_TH D1_TH A2_TH B2_TH C2_TH D2_TH ...
     A3_TH B3_TH C3_TH D3_TH A4_TH B4_TH C4_TH D4_TH ...
     A5_TH B5_TH C5_TH D5_TH A6_TH B6_TH C6_TH D6_TH ...
     A7_TH B7_TH C7_TH D7_TH A8_TH B8_TH C8_TH D8_TH ...
     A1_MI B1_MI C1_MI D1_MI A2_MI B2_MI C2_MI D2_MI ...
     A3_MI B3_MI C3_MI D3_MI A4_MI B4_MI C4_MI D4_MI ...
     A5_MI B5_MI C5_MI D5_MI A6_MI B6_MI C6_MI D6_MI ...
     A7_MI B7_MI C7_MI D7_MI A8_MI B8_MI C8_MI D8_MI
 
    Origin_INDEX=[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];%% initial values
    % Origin_TH=Origin*transl(-86.71,-28.55,22.75)*trotz(24*pi/180)*trotx(-75*pi/180)*troty(54*pi/180)*trotz(45*pi/180);%% initial values
    Origin_TH=Origin_INDEX*transl(-88.75,-29.04,-24.35)*trotz(24*pi/180)*trotx(-75*pi/180)*troty(54*pi/180)*trotz(45*pi/180);%% initial values
    Origin_THParam=[-88.75 -29.04 -24.35 asin(-Origin_TH(2,3)/cos(asin(Origin_TH(1,3)))) asin(Origin_TH(1,3)) asin(-Origin_TH(1,2)/cos(asin(Origin_TH(1,3))))];
    Origin_MI=Origin_INDEX*transl(0,0,19);%% initial values
    Origin_MIParam=[0 0 19 0 0 0];
    
    % load link length data
    link = loadLinkLength();
    
    % initial values 1x17 for index device
    q_INDEX_double=[0 0 0 -halfpi 0 link(1,2) halfpi 0 0 0 link(4, 2) 0 0 0 -halfpi link(6, 2) 0];
    % initial values 1x23 for thumb device
    q_TH_double=[0 0 0 -halfpi 0 link(1, 1) halfpi 0 0 0 link(4, 1) 0 0 0 -halfpi link(6, 1) 0 Origin_THParam(1) Origin_THParam(2) Origin_THParam(3) Origin_THParam(4) Origin_THParam(5) Origin_THParam(6)]; %% initial values
    % initial values 1x23 for middle device
    q_MI_double=[0 0 0 -halfpi 0 link(1, 3) halfpi 0 0 0 link(4, 3) 0 0 0 -halfpi link(6, 3) 0 Origin_MIParam(1) Origin_MIParam(2) Origin_MIParam(3) Origin_MIParam(4) Origin_MIParam(5) Origin_MIParam(6)]; %% initial values
            
    DHinit=[[q_INDEX_double';0;0;0;0;0;0] q_TH_double' q_MI_double'];
    
    qRef_INDEX=[A1 B1 C1 D1 A2 C2 D2 A3 D4 A5 C5 D5 A6 A7 B7 C7 D7]';
    qRef_TH=[A1_TH B1_TH C1_TH D1_TH A2_TH C2_TH D2_TH A3_TH D4_TH A5_TH C5_TH D5_TH A6_TH A7_TH B7_TH C7_TH D7_TH A0_TH B0_TH C0_TH D0_TH E0_TH F0_TH]';
    qRef_MI=[A1_MI B1_MI C1_MI D1_MI A2_MI C2_MI D2_MI A3_MI D4_MI A5_MI C5_MI D5_MI A6_MI A7_MI B7_MI C7_MI D7_MI A0_MI B0_MI C0_MI D0_MI E0_MI F0_MI]';
    
    DHRef = [A1 B1 C1 D1; A2 B2 C2 D2; A3 B3 C3 D3; A4 B4 C4 D4; A5 B5 C5 D5; A6 B6 C6 D6; A7 B7 C7 D7; A8 B8 C8 D8];
    
    R01=transl(0,0,DHRef(1,1))*[cos(DHRef(1,2)) -sin(DHRef(1,2)) 0 0; sin(DHRef(1,2)) cos(DHRef(1,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(1,3),0,0)*[1 0 0 0; 0 cos(DHRef(1,4)) -sin(DHRef(1,4)) 0; 0 sin(DHRef(1,4)) cos(DHRef(1,4)) 0; 0 0 0 1];
    R12=transl(0,0,DHRef(2,1))*[cos(DHRef(2,2)) -sin(DHRef(2,2)) 0 0; sin(DHRef(2,2)) cos(DHRef(2,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(2,3),0,0)*[1 0 0 0; 0 cos(DHRef(2,4)) -sin(DHRef(2,4)) 0; 0 sin(DHRef(2,4)) cos(DHRef(2,4)) 0; 0 0 0 1];
    R23=transl(0,0,DHRef(3,1))*[cos(DHRef(3,2)) -sin(DHRef(3,2)) 0 0; sin(DHRef(3,2)) cos(DHRef(3,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(3,3),0,0)*[1 0 0 0; 0 cos(DHRef(3,4)) -sin(DHRef(3,4)) 0; 0 sin(DHRef(3,4)) cos(DHRef(3,4)) 0; 0 0 0 1];
    R34=transl(0,0,DHRef(4,1))*[cos(DHRef(4,2)) -sin(DHRef(4,2)) 0 0; sin(DHRef(4,2)) cos(DHRef(4,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(4,3),0,0)*[1 0 0 0; 0 cos(DHRef(4,4)) -sin(DHRef(4,4)) 0; 0 sin(DHRef(4,4)) cos(DHRef(4,4)) 0; 0 0 0 1];
    R45=transl(0,0,DHRef(5,1))*[cos(DHRef(5,2)) -sin(DHRef(5,2)) 0 0; sin(DHRef(5,2)) cos(DHRef(5,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(5,3),0,0)*[1 0 0 0; 0 cos(DHRef(5,4)) -sin(DHRef(5,4)) 0; 0 sin(DHRef(5,4)) cos(DHRef(5,4)) 0; 0 0 0 1];
    R56=transl(0,0,DHRef(6,1))*[cos(DHRef(6,2)) -sin(DHRef(6,2)) 0 0; sin(DHRef(6,2)) cos(DHRef(6,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(6,3),0,0)*[1 0 0 0; 0 cos(DHRef(6,4)) -sin(DHRef(6,4)) 0; 0 sin(DHRef(6,4)) cos(DHRef(6,4)) 0; 0 0 0 1];
    R67=transl(0,0,DHRef(7,1))*[cos(DHRef(7,2)) -sin(DHRef(7,2)) 0 0; sin(DHRef(7,2)) cos(DHRef(7,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(7,3),0,0)*[1 0 0 0; 0 cos(DHRef(7,4)) -sin(DHRef(7,4)) 0; 0 sin(DHRef(7,4)) cos(DHRef(7,4)) 0; 0 0 0 1];
    R78=transl(0,0,DHRef(8,1))*[cos(DHRef(8,2)) -sin(DHRef(8,2)) 0 0; sin(DHRef(8,2)) cos(DHRef(8,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(8,3),0,0)*[1 0 0 0; 0 cos(DHRef(8,4)) -sin(DHRef(8,4)) 0; 0 sin(DHRef(8,4)) cos(DHRef(8,4)) 0; 0 0 0 1];

    OriginRef=eye(4);

    R7=OriginRef*R01*R12*R23*R34*R45*R56*R67*R78;
    %end effector position
    Joint7Ref=[R7(1,4); R7(2,4); R7(3,4)];
    
    JacobianMatRef = [diff(Joint7Ref(1),A1) diff(Joint7Ref(1),B1) diff(Joint7Ref(1),C1) diff(Joint7Ref(1),D1) diff(Joint7Ref(1),A2) diff(Joint7Ref(1),C2) diff(Joint7Ref(1),D2) diff(Joint7Ref(1),A3) diff(Joint7Ref(1),D4) diff(Joint7Ref(1),A5) diff(Joint7Ref(1),C5) diff(Joint7Ref(1),D5) diff(Joint7Ref(1),A6) diff(Joint7Ref(1),A7) diff(Joint7Ref(1),B7) diff(Joint7Ref(1),C7) diff(Joint7Ref(1),D7); 
                diff(Joint7Ref(2),A1) diff(Joint7Ref(2),B1) diff(Joint7Ref(2),C1) diff(Joint7Ref(2),D1) diff(Joint7Ref(2),A2) diff(Joint7Ref(2),C2) diff(Joint7Ref(2),D2) diff(Joint7Ref(2),A3) diff(Joint7Ref(2),D4) diff(Joint7Ref(2),A5) diff(Joint7Ref(2),C5) diff(Joint7Ref(2),D5) diff(Joint7Ref(2),A6) diff(Joint7Ref(2),A7) diff(Joint7Ref(2),B7) diff(Joint7Ref(2),C7) diff(Joint7Ref(2),D7); 
                diff(Joint7Ref(3),A1) diff(Joint7Ref(3),B1) diff(Joint7Ref(3),C1) diff(Joint7Ref(3),D1) diff(Joint7Ref(3),A2) diff(Joint7Ref(3),C2) diff(Joint7Ref(3),D2) diff(Joint7Ref(3),A3) diff(Joint7Ref(3),D4) diff(Joint7Ref(3),A5) diff(Joint7Ref(3),C5) diff(Joint7Ref(3),D5) diff(Joint7Ref(3),A6) diff(Joint7Ref(3),A7) diff(Joint7Ref(3),B7) diff(Joint7Ref(3),C7) diff(Joint7Ref(3),D7)];
            
    % ccode(JacobianMatRef,'file','JacobianMatRef2.txt');
    % 'JacobianMatRef written'

    DH_TH=[A1_TH B1_TH C1_TH D1_TH; A2_TH B2_TH C2_TH D2_TH; A3_TH B3_TH C3_TH D3_TH; A4_TH B4_TH C4_TH D4_TH; A5_TH B5_TH C5_TH D5_TH; A6_TH B6_TH C6_TH D6_TH; A7_TH B7_TH C7_TH D7_TH; A8_TH B8_TH C8_TH D8_TH];

    R01_TH=transl(0,0,DH_TH(1,1))*[cos(DH_TH(1,2)) -sin(DH_TH(1,2)) 0 0; sin(DH_TH(1,2)) cos(DH_TH(1,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(1,3),0,0)*[1 0 0 0; 0 cos(DH_TH(1,4)) -sin(DH_TH(1,4)) 0; 0 sin(DH_TH(1,4)) cos(DH_TH(1,4)) 0; 0 0 0 1];
    R12_TH=transl(0,0,DH_TH(2,1))*[cos(DH_TH(2,2)) -sin(DH_TH(2,2)) 0 0; sin(DH_TH(2,2)) cos(DH_TH(2,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(2,3),0,0)*[1 0 0 0; 0 cos(DH_TH(2,4)) -sin(DH_TH(2,4)) 0; 0 sin(DH_TH(2,4)) cos(DH_TH(2,4)) 0; 0 0 0 1];
    R23_TH=transl(0,0,DH_TH(3,1))*[cos(DH_TH(3,2)) -sin(DH_TH(3,2)) 0 0; sin(DH_TH(3,2)) cos(DH_TH(3,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(3,3),0,0)*[1 0 0 0; 0 cos(DH_TH(3,4)) -sin(DH_TH(3,4)) 0; 0 sin(DH_TH(3,4)) cos(DH_TH(3,4)) 0; 0 0 0 1];
    R34_TH=transl(0,0,DH_TH(4,1))*[cos(DH_TH(4,2)) -sin(DH_TH(4,2)) 0 0; sin(DH_TH(4,2)) cos(DH_TH(4,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(4,3),0,0)*[1 0 0 0; 0 cos(DH_TH(4,4)) -sin(DH_TH(4,4)) 0; 0 sin(DH_TH(4,4)) cos(DH_TH(4,4)) 0; 0 0 0 1];
    R45_TH=transl(0,0,DH_TH(5,1))*[cos(DH_TH(5,2)) -sin(DH_TH(5,2)) 0 0; sin(DH_TH(5,2)) cos(DH_TH(5,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(5,3),0,0)*[1 0 0 0; 0 cos(DH_TH(5,4)) -sin(DH_TH(5,4)) 0; 0 sin(DH_TH(5,4)) cos(DH_TH(5,4)) 0; 0 0 0 1];
    R56_TH=transl(0,0,DH_TH(6,1))*[cos(DH_TH(6,2)) -sin(DH_TH(6,2)) 0 0; sin(DH_TH(6,2)) cos(DH_TH(6,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(6,3),0,0)*[1 0 0 0; 0 cos(DH_TH(6,4)) -sin(DH_TH(6,4)) 0; 0 sin(DH_TH(6,4)) cos(DH_TH(6,4)) 0; 0 0 0 1];
    R67_TH=transl(0,0,DH_TH(7,1))*[cos(DH_TH(7,2)) -sin(DH_TH(7,2)) 0 0; sin(DH_TH(7,2)) cos(DH_TH(7,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(7,3),0,0)*[1 0 0 0; 0 cos(DH_TH(7,4)) -sin(DH_TH(7,4)) 0; 0 sin(DH_TH(7,4)) cos(DH_TH(7,4)) 0; 0 0 0 1];
    R78_TH=transl(0,0,DH_TH(8,1))*[cos(DH_TH(8,2)) -sin(DH_TH(8,2)) 0 0; sin(DH_TH(8,2)) cos(DH_TH(8,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(8,3),0,0)*[1 0 0 0; 0 cos(DH_TH(8,4)) -sin(DH_TH(8,4)) 0; 0 sin(DH_TH(8,4)) cos(DH_TH(8,4)) 0; 0 0 0 1];

    Origin_THRef=OriginRef*transl(A0_TH,B0_TH,C0_TH)*[1 0 0 0; 0 cos(D0_TH) -sin(D0_TH) 0; 0 sin(D0_TH) cos(D0_TH) 0; 0 0 0 1]*[cos(E0_TH) 0 sin(E0_TH) 0; 0 1 0 0; -sin(E0_TH) 0 cos(E0_TH) 0; 0 0 0 1]*[cos(F0_TH) -sin(F0_TH) 0 0; sin(F0_TH) cos(F0_TH) 0 0; 0 0 1 0; 0 0 0 1];
    R7_TH=Origin_THRef*R01_TH*R12_TH*R23_TH*R34_TH*R45_TH*R56_TH*R67_TH*R78_TH;
    Joint7Ref_TH=[R7_TH(1,4); R7_TH(2,4); R7_TH(3,4)];

    JacobianMatRef_TH = [diff(Joint7Ref_TH(1),A1_TH) diff(Joint7Ref_TH(1),B1_TH) diff(Joint7Ref_TH(1),C1_TH) diff(Joint7Ref_TH(1),D1_TH) diff(Joint7Ref_TH(1),A2_TH) diff(Joint7Ref_TH(1),C2_TH) diff(Joint7Ref_TH(1),D2_TH) diff(Joint7Ref_TH(1),A3_TH) diff(Joint7Ref_TH(1),D4_TH) diff(Joint7Ref_TH(1),A5_TH) diff(Joint7Ref_TH(1),C5_TH) diff(Joint7Ref_TH(1),D5_TH) diff(Joint7Ref_TH(1),A6_TH) diff(Joint7Ref_TH(1),A7_TH) diff(Joint7Ref_TH(1),B7_TH) diff(Joint7Ref_TH(1),C7_TH) diff(Joint7Ref_TH(1),D7_TH) diff(Joint7Ref_TH(1),A0_TH) diff(Joint7Ref_TH(1),B0_TH) diff(Joint7Ref_TH(1),C0_TH) diff(Joint7Ref_TH(1),D0_TH) diff(Joint7Ref_TH(1),E0_TH) diff(Joint7Ref_TH(1),F0_TH); 
        diff(Joint7Ref_TH(2),A1_TH) diff(Joint7Ref_TH(2),B1_TH) diff(Joint7Ref_TH(2),C1_TH) diff(Joint7Ref_TH(2),D1_TH) diff(Joint7Ref_TH(2),A2_TH) diff(Joint7Ref_TH(2),C2_TH) diff(Joint7Ref_TH(2),D2_TH) diff(Joint7Ref_TH(2),A3_TH) diff(Joint7Ref_TH(2),D4_TH) diff(Joint7Ref_TH(2),A5_TH) diff(Joint7Ref_TH(2),C5_TH) diff(Joint7Ref_TH(2),D5_TH) diff(Joint7Ref_TH(2),A6_TH) diff(Joint7Ref_TH(2),A7_TH) diff(Joint7Ref_TH(2),B7_TH) diff(Joint7Ref_TH(2),C7_TH) diff(Joint7Ref_TH(2),D7_TH) diff(Joint7Ref_TH(2),A0_TH) diff(Joint7Ref_TH(2),B0_TH) diff(Joint7Ref_TH(2),C0_TH) diff(Joint7Ref_TH(2),D0_TH) diff(Joint7Ref_TH(2),E0_TH) diff(Joint7Ref_TH(2),F0_TH); 
        diff(Joint7Ref_TH(3),A1_TH) diff(Joint7Ref_TH(3),B1_TH) diff(Joint7Ref_TH(3),C1_TH) diff(Joint7Ref_TH(3),D1_TH) diff(Joint7Ref_TH(3),A2_TH) diff(Joint7Ref_TH(3),C2_TH) diff(Joint7Ref_TH(3),D2_TH) diff(Joint7Ref_TH(3),A3_TH) diff(Joint7Ref_TH(3),D4_TH) diff(Joint7Ref_TH(3),A5_TH) diff(Joint7Ref_TH(3),C5_TH) diff(Joint7Ref_TH(3),D5_TH) diff(Joint7Ref_TH(3),A6_TH) diff(Joint7Ref_TH(3),A7_TH) diff(Joint7Ref_TH(3),B7_TH) diff(Joint7Ref_TH(3),C7_TH) diff(Joint7Ref_TH(3),D7_TH) diff(Joint7Ref_TH(3),A0_TH) diff(Joint7Ref_TH(3),B0_TH) diff(Joint7Ref_TH(3),C0_TH) diff(Joint7Ref_TH(3),D0_TH) diff(Joint7Ref_TH(3),E0_TH) diff(Joint7Ref_TH(3),F0_TH)];


    DH_MI=[A1_MI B1_MI C1_MI D1_MI; A2_MI B2_MI C2_MI D2_MI; A3_MI B3_MI C3_MI D3_MI; A4_MI B4_MI C4_MI D4_MI; A5_MI B5_MI C5_MI D5_MI; A6_MI B6_MI C6_MI D6_MI; A7_MI B7_MI C7_MI D7_MI; A8_MI B8_MI C8_MI D8_MI];

    R01_MI=transl(0,0,DH_MI(1,1))*[cos(DH_MI(1,2)) -sin(DH_MI(1,2)) 0 0; sin(DH_MI(1,2)) cos(DH_MI(1,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_MI(1,3),0,0)*[1 0 0 0; 0 cos(DH_MI(1,4)) -sin(DH_MI(1,4)) 0; 0 sin(DH_MI(1,4)) cos(DH_MI(1,4)) 0; 0 0 0 1];
    R12_MI=transl(0,0,DH_MI(2,1))*[cos(DH_MI(2,2)) -sin(DH_MI(2,2)) 0 0; sin(DH_MI(2,2)) cos(DH_MI(2,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_MI(2,3),0,0)*[1 0 0 0; 0 cos(DH_MI(2,4)) -sin(DH_MI(2,4)) 0; 0 sin(DH_MI(2,4)) cos(DH_MI(2,4)) 0; 0 0 0 1];
    R23_MI=transl(0,0,DH_MI(3,1))*[cos(DH_MI(3,2)) -sin(DH_MI(3,2)) 0 0; sin(DH_MI(3,2)) cos(DH_MI(3,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_MI(3,3),0,0)*[1 0 0 0; 0 cos(DH_MI(3,4)) -sin(DH_MI(3,4)) 0; 0 sin(DH_MI(3,4)) cos(DH_MI(3,4)) 0; 0 0 0 1];
    R34_MI=transl(0,0,DH_MI(4,1))*[cos(DH_MI(4,2)) -sin(DH_MI(4,2)) 0 0; sin(DH_MI(4,2)) cos(DH_MI(4,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_MI(4,3),0,0)*[1 0 0 0; 0 cos(DH_MI(4,4)) -sin(DH_MI(4,4)) 0; 0 sin(DH_MI(4,4)) cos(DH_MI(4,4)) 0; 0 0 0 1];
    R45_MI=transl(0,0,DH_MI(5,1))*[cos(DH_MI(5,2)) -sin(DH_MI(5,2)) 0 0; sin(DH_MI(5,2)) cos(DH_MI(5,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_MI(5,3),0,0)*[1 0 0 0; 0 cos(DH_MI(5,4)) -sin(DH_MI(5,4)) 0; 0 sin(DH_MI(5,4)) cos(DH_MI(5,4)) 0; 0 0 0 1];
    R56_MI=transl(0,0,DH_MI(6,1))*[cos(DH_MI(6,2)) -sin(DH_MI(6,2)) 0 0; sin(DH_MI(6,2)) cos(DH_MI(6,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_MI(6,3),0,0)*[1 0 0 0; 0 cos(DH_MI(6,4)) -sin(DH_MI(6,4)) 0; 0 sin(DH_MI(6,4)) cos(DH_MI(6,4)) 0; 0 0 0 1];
    R67_MI=transl(0,0,DH_MI(7,1))*[cos(DH_MI(7,2)) -sin(DH_MI(7,2)) 0 0; sin(DH_MI(7,2)) cos(DH_MI(7,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_MI(7,3),0,0)*[1 0 0 0; 0 cos(DH_MI(7,4)) -sin(DH_MI(7,4)) 0; 0 sin(DH_MI(7,4)) cos(DH_MI(7,4)) 0; 0 0 0 1];
    R78_MI=transl(0,0,DH_MI(8,1))*[cos(DH_MI(8,2)) -sin(DH_MI(8,2)) 0 0; sin(DH_MI(8,2)) cos(DH_MI(8,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_MI(8,3),0,0)*[1 0 0 0; 0 cos(DH_MI(8,4)) -sin(DH_MI(8,4)) 0; 0 sin(DH_MI(8,4)) cos(DH_MI(8,4)) 0; 0 0 0 1];

    Origin_MIRef=OriginRef*transl(A0_MI,B0_MI,C0_MI)*[1 0 0 0; 0 cos(D0_MI) -sin(D0_MI) 0; 0 sin(D0_MI) cos(D0_MI) 0; 0 0 0 1]*[cos(E0_MI) 0 sin(E0_MI) 0; 0 1 0 0; -sin(E0_MI) 0 cos(E0_MI) 0; 0 0 0 1]*[cos(F0_MI) -sin(F0_MI) 0 0; sin(F0_MI) cos(F0_MI) 0 0; 0 0 1 0; 0 0 0 1];
    R7_MI=Origin_MIRef*R01_MI*R12_MI*R23_MI*R34_MI*R45_MI*R56_MI*R67_MI*R78_MI;
    Joint7Ref_MI=[R7_MI(1,4); R7_MI(2,4); R7_MI(3,4)];


    JacobianMatRef_MI = [diff(Joint7Ref_MI(1),A1_MI) diff(Joint7Ref_MI(1),B1_MI) diff(Joint7Ref_MI(1),C1_MI) diff(Joint7Ref_MI(1),D1_MI) diff(Joint7Ref_MI(1),A2_MI) diff(Joint7Ref_MI(1),C2_MI) diff(Joint7Ref_MI(1),D2_MI) diff(Joint7Ref_MI(1),A3_MI) diff(Joint7Ref_MI(1),D4_MI) diff(Joint7Ref_MI(1),A5_MI) diff(Joint7Ref_MI(1),C5_MI) diff(Joint7Ref_MI(1),D5_MI) diff(Joint7Ref_MI(1),A6_MI) diff(Joint7Ref_MI(1),A7_MI) diff(Joint7Ref_MI(1),B7_MI) diff(Joint7Ref_MI(1),C7_MI) diff(Joint7Ref_MI(1),D7_MI) diff(Joint7Ref_MI(1),A0_MI) diff(Joint7Ref_MI(1),B0_MI) diff(Joint7Ref_MI(1),C0_MI) diff(Joint7Ref_MI(1),D0_MI) diff(Joint7Ref_MI(1),E0_MI) diff(Joint7Ref_MI(1),F0_MI); 
        diff(Joint7Ref_MI(2),A1_MI) diff(Joint7Ref_MI(2),B1_MI) diff(Joint7Ref_MI(2),C1_MI) diff(Joint7Ref_MI(2),D1_MI) diff(Joint7Ref_MI(2),A2_MI) diff(Joint7Ref_MI(2),C2_MI) diff(Joint7Ref_MI(2),D2_MI) diff(Joint7Ref_MI(2),A3_MI) diff(Joint7Ref_MI(2),D4_MI) diff(Joint7Ref_MI(2),A5_MI) diff(Joint7Ref_MI(2),C5_MI) diff(Joint7Ref_MI(2),D5_MI) diff(Joint7Ref_MI(2),A6_MI) diff(Joint7Ref_MI(2),A7_MI) diff(Joint7Ref_MI(2),B7_MI) diff(Joint7Ref_MI(2),C7_MI) diff(Joint7Ref_MI(2),D7_MI) diff(Joint7Ref_MI(2),A0_MI) diff(Joint7Ref_MI(2),B0_MI) diff(Joint7Ref_MI(2),C0_MI) diff(Joint7Ref_MI(2),D0_MI) diff(Joint7Ref_MI(2),E0_MI) diff(Joint7Ref_MI(2),F0_MI); 
        diff(Joint7Ref_MI(3),A1_MI) diff(Joint7Ref_MI(3),B1_MI) diff(Joint7Ref_MI(3),C1_MI) diff(Joint7Ref_MI(3),D1_MI) diff(Joint7Ref_MI(3),A2_MI) diff(Joint7Ref_MI(3),C2_MI) diff(Joint7Ref_MI(3),D2_MI) diff(Joint7Ref_MI(3),A3_MI) diff(Joint7Ref_MI(3),D4_MI) diff(Joint7Ref_MI(3),A5_MI) diff(Joint7Ref_MI(3),C5_MI) diff(Joint7Ref_MI(3),D5_MI) diff(Joint7Ref_MI(3),A6_MI) diff(Joint7Ref_MI(3),A7_MI) diff(Joint7Ref_MI(3),B7_MI) diff(Joint7Ref_MI(3),C7_MI) diff(Joint7Ref_MI(3),D7_MI) diff(Joint7Ref_MI(3),A0_MI) diff(Joint7Ref_MI(3),B0_MI) diff(Joint7Ref_MI(3),C0_MI) diff(Joint7Ref_MI(3),D0_MI) diff(Joint7Ref_MI(3),E0_MI) diff(Joint7Ref_MI(3),F0_MI)];

   % for loop ºÎºÐ 
 
end

