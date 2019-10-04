clc, clear, close ('all')

data3=csvread('simulation_Left08_03.csv');
alpha=0;
beta=0;
gamma=1;

iteration=5;
% 
% l1=24.2;
% l2=56.03;
% l3=12.94;
% l4=47.5;
% l5=19.5;
% l6=20.94;
% l7=7.3;
% l8=14.95;
% 
% l1_TH=24.2;
% l2_TH=56.03;
% l3_TH=12.94;
% l4_TH=57.5;
% l5_TH=19.5;
% l6_TH=23.49;
% l7_TH=-8.65;
% l8_TH=15.4;
% 
% l1_MI=24.2;
% l2_MI=56.03;
% l3_MI=12.94;
% l4_MI=47.5;
% l5_MI=19.5;
% l6_MI=20.94;
% l7_MI=7.3;
% l8_MI=14.95;

%% LEFT FINGER_Siggraph 2018
% l1=24.2;
% l2=56.03;
% l3=12.94;
% l4=47.5;
% l5=18.5;
% l6=23.5;
% l7=10.37;
% l8=16.5;
% 
% l1_TH=24.2;
% l2_TH=56.03;
% l3_TH=12.94;
% l4_TH=57.5;
% l5_TH=18.5;
% l6_TH=26.5;
% l7_TH=-10.37;
% l8_TH=16.5;
% 
% l1_MI=24.2;
% l2_MI=56.03;
% l3_MI=12.94;
% l4_MI=47.5;
% l5_MI=18.5;
% l6_MI=25;
% l7_MI=10.37;
% l8_MI=16.5;

%% LEFT FINGER_Revised_190114

l1=24.2;
l2=56.03;
l3=12.94;
l4=47.5;
l5=19.5;
l6=22.96;
l7=10.42;
l8=16.61;

l1_TH=24.2;
l2_TH=56.03;
l3_TH=12.94;
l4_TH=57.5;
l5_TH=19.5;
l6_TH=24.82;
l7_TH=-10.42;
l8_TH=16.61;

l1_MI=24.2;
l2_MI=56.03;
l3_MI=12.94;
l4_MI=47.5;
l5_MI=19.5;
l6_MI=22.93;
l7_MI=10.42;
l8_MI=16.61;

T1=4;
T2=5;
I1=2;
I2=3;
M1=1;
M2=0;

lambda=10000;

syms A0_TH B0_TH C0_TH D0_TH E0_TH F0_TH A0_MI B0_MI C0_MI D0_MI E0_MI F0_MI A1 B1 C1 D1 A2 B2 C2 D2 A3 B3 C3 D3 A4 B4 C4 D4 A5 B5 C5 D5 A6 B6 C6 D6 A7 B7 C7 D7 A8 B8 C8 D8 A1_TH B1_TH C1_TH D1_TH A2_TH B2_TH C2_TH D2_TH A3_TH B3_TH C3_TH D3_TH A4_TH B4_TH C4_TH D4_TH A5_TH B5_TH C5_TH D5_TH A6_TH B6_TH C6_TH D6_TH A7_TH B7_TH C7_TH D7_TH A8_TH B8_TH C8_TH D8_TH A1_MI B1_MI C1_MI D1_MI A2_MI B2_MI C2_MI D2_MI A3_MI B3_MI C3_MI D3_MI A4_MI B4_MI C4_MI D4_MI A5_MI B5_MI C5_MI D5_MI A6_MI B6_MI C6_MI D6_MI A7_MI B7_MI C7_MI D7_MI A8_MI B8_MI C8_MI D8_MI


Origin=[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];%% initial values
Origin_TH=Origin*transl(-88.75,-29.04,24.35)*trotz(24*pi/180)*trotx(75*pi/180)*troty(-54*pi/180)*trotz(45*pi/180);%% initial values
Origin_THParam=[-88.75 -29.04 24.35 asin(-Origin_TH(2,3)/cos(asin(Origin_TH(1,3)))) asin(Origin_TH(1,3)) asin(-Origin_TH(1,2)/cos(asin(Origin_TH(1,3))))];
Origin_MI=Origin*transl(0,0,-19);%% initial values
Origin_MIParam=[0 0 -19 0 0 0];

q_double=[0 0 0 -pi/2 0 l1 pi/2 0 0 0 l4 0 0 0 -pi/2 l6 0]; %% initial values
q_TH_double=[0 0 0 -pi/2 0 l1_TH pi/2 0 0 0 l4_TH 0 0 0 -pi/2 l6_TH 0 Origin_THParam(1) Origin_THParam(2) Origin_THParam(3) Origin_THParam(4) Origin_THParam(5) Origin_THParam(6)]; %% initial values
q_MI_double=[0 0 0 -pi/2 0 l1_MI pi/2 0 0 0 l4_MI 0 0 0 -pi/2 l6_MI 0 Origin_MIParam(1) Origin_MIParam(2) Origin_MIParam(3) Origin_MIParam(4) Origin_MIParam(5) Origin_MIParam(6)]; %% initial values

DHinit=[[q_double';0;0;0;0;0;0] q_TH_double' q_MI_double'];

off_TH1=0;
off_TH2=0.006787226093711;
off_TH3=-0.031110291362206;
off_TH4=0;

off_TH1_MI=0;
off_TH2_MI=-0.050990245118409;
off_TH3_MI=-0.033190931497112;
off_TH4_MI=0;

off_TH1_TH=0;
off_TH2_TH=0.057166560412573;
off_TH3_TH=0.029349368221312;
off_TH4_TH=0;

qRef=[A1 B1 C1 D1 A2 C2 D2 A3 D4 A5 C5 D5 A6 A7 B7 C7 D7]';
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
Joint7Ref=[R7(1,4); R7(2,4); R7(3,4)];

% ccode(Joint7Ref,'file','Joint7Ref2.txt');
% 'Joint7Ref written'

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

% ccode(Joint7Ref_TH,'file','Joint7Ref_TH2.txt');
% 'Joint7Ref_TH written'

JacobianMatRef_TH = [diff(Joint7Ref_TH(1),A1_TH) diff(Joint7Ref_TH(1),B1_TH) diff(Joint7Ref_TH(1),C1_TH) diff(Joint7Ref_TH(1),D1_TH) diff(Joint7Ref_TH(1),A2_TH) diff(Joint7Ref_TH(1),C2_TH) diff(Joint7Ref_TH(1),D2_TH) diff(Joint7Ref_TH(1),A3_TH) diff(Joint7Ref_TH(1),D4_TH) diff(Joint7Ref_TH(1),A5_TH) diff(Joint7Ref_TH(1),C5_TH) diff(Joint7Ref_TH(1),D5_TH) diff(Joint7Ref_TH(1),A6_TH) diff(Joint7Ref_TH(1),A7_TH) diff(Joint7Ref_TH(1),B7_TH) diff(Joint7Ref_TH(1),C7_TH) diff(Joint7Ref_TH(1),D7_TH) diff(Joint7Ref_TH(1),A0_TH) diff(Joint7Ref_TH(1),B0_TH) diff(Joint7Ref_TH(1),C0_TH) diff(Joint7Ref_TH(1),D0_TH) diff(Joint7Ref_TH(1),E0_TH) diff(Joint7Ref_TH(1),F0_TH); 
    diff(Joint7Ref_TH(2),A1_TH) diff(Joint7Ref_TH(2),B1_TH) diff(Joint7Ref_TH(2),C1_TH) diff(Joint7Ref_TH(2),D1_TH) diff(Joint7Ref_TH(2),A2_TH) diff(Joint7Ref_TH(2),C2_TH) diff(Joint7Ref_TH(2),D2_TH) diff(Joint7Ref_TH(2),A3_TH) diff(Joint7Ref_TH(2),D4_TH) diff(Joint7Ref_TH(2),A5_TH) diff(Joint7Ref_TH(2),C5_TH) diff(Joint7Ref_TH(2),D5_TH) diff(Joint7Ref_TH(2),A6_TH) diff(Joint7Ref_TH(2),A7_TH) diff(Joint7Ref_TH(2),B7_TH) diff(Joint7Ref_TH(2),C7_TH) diff(Joint7Ref_TH(2),D7_TH) diff(Joint7Ref_TH(2),A0_TH) diff(Joint7Ref_TH(2),B0_TH) diff(Joint7Ref_TH(2),C0_TH) diff(Joint7Ref_TH(2),D0_TH) diff(Joint7Ref_TH(2),E0_TH) diff(Joint7Ref_TH(2),F0_TH); 
    diff(Joint7Ref_TH(3),A1_TH) diff(Joint7Ref_TH(3),B1_TH) diff(Joint7Ref_TH(3),C1_TH) diff(Joint7Ref_TH(3),D1_TH) diff(Joint7Ref_TH(3),A2_TH) diff(Joint7Ref_TH(3),C2_TH) diff(Joint7Ref_TH(3),D2_TH) diff(Joint7Ref_TH(3),A3_TH) diff(Joint7Ref_TH(3),D4_TH) diff(Joint7Ref_TH(3),A5_TH) diff(Joint7Ref_TH(3),C5_TH) diff(Joint7Ref_TH(3),D5_TH) diff(Joint7Ref_TH(3),A6_TH) diff(Joint7Ref_TH(3),A7_TH) diff(Joint7Ref_TH(3),B7_TH) diff(Joint7Ref_TH(3),C7_TH) diff(Joint7Ref_TH(3),D7_TH) diff(Joint7Ref_TH(3),A0_TH) diff(Joint7Ref_TH(3),B0_TH) diff(Joint7Ref_TH(3),C0_TH) diff(Joint7Ref_TH(3),D0_TH) diff(Joint7Ref_TH(3),E0_TH) diff(Joint7Ref_TH(3),F0_TH)];

% ccode(JacobianMatRef_TH,'file','JacobianMatRef_TH2.txt');
% 'JacobianMatRef_TH written'

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

% ccode(Joint7Ref_MI,'file','Joint7Ref_MI2.txt');
% 'Joint7Ref_MI written'

JacobianMatRef_MI = [diff(Joint7Ref_MI(1),A1_MI) diff(Joint7Ref_MI(1),B1_MI) diff(Joint7Ref_MI(1),C1_MI) diff(Joint7Ref_MI(1),D1_MI) diff(Joint7Ref_MI(1),A2_MI) diff(Joint7Ref_MI(1),C2_MI) diff(Joint7Ref_MI(1),D2_MI) diff(Joint7Ref_MI(1),A3_MI) diff(Joint7Ref_MI(1),D4_MI) diff(Joint7Ref_MI(1),A5_MI) diff(Joint7Ref_MI(1),C5_MI) diff(Joint7Ref_MI(1),D5_MI) diff(Joint7Ref_MI(1),A6_MI) diff(Joint7Ref_MI(1),A7_MI) diff(Joint7Ref_MI(1),B7_MI) diff(Joint7Ref_MI(1),C7_MI) diff(Joint7Ref_MI(1),D7_MI) diff(Joint7Ref_MI(1),A0_MI) diff(Joint7Ref_MI(1),B0_MI) diff(Joint7Ref_MI(1),C0_MI) diff(Joint7Ref_MI(1),D0_MI) diff(Joint7Ref_MI(1),E0_MI) diff(Joint7Ref_MI(1),F0_MI); 
    diff(Joint7Ref_MI(2),A1_MI) diff(Joint7Ref_MI(2),B1_MI) diff(Joint7Ref_MI(2),C1_MI) diff(Joint7Ref_MI(2),D1_MI) diff(Joint7Ref_MI(2),A2_MI) diff(Joint7Ref_MI(2),C2_MI) diff(Joint7Ref_MI(2),D2_MI) diff(Joint7Ref_MI(2),A3_MI) diff(Joint7Ref_MI(2),D4_MI) diff(Joint7Ref_MI(2),A5_MI) diff(Joint7Ref_MI(2),C5_MI) diff(Joint7Ref_MI(2),D5_MI) diff(Joint7Ref_MI(2),A6_MI) diff(Joint7Ref_MI(2),A7_MI) diff(Joint7Ref_MI(2),B7_MI) diff(Joint7Ref_MI(2),C7_MI) diff(Joint7Ref_MI(2),D7_MI) diff(Joint7Ref_MI(2),A0_MI) diff(Joint7Ref_MI(2),B0_MI) diff(Joint7Ref_MI(2),C0_MI) diff(Joint7Ref_MI(2),D0_MI) diff(Joint7Ref_MI(2),E0_MI) diff(Joint7Ref_MI(2),F0_MI); 
    diff(Joint7Ref_MI(3),A1_MI) diff(Joint7Ref_MI(3),B1_MI) diff(Joint7Ref_MI(3),C1_MI) diff(Joint7Ref_MI(3),D1_MI) diff(Joint7Ref_MI(3),A2_MI) diff(Joint7Ref_MI(3),C2_MI) diff(Joint7Ref_MI(3),D2_MI) diff(Joint7Ref_MI(3),A3_MI) diff(Joint7Ref_MI(3),D4_MI) diff(Joint7Ref_MI(3),A5_MI) diff(Joint7Ref_MI(3),C5_MI) diff(Joint7Ref_MI(3),D5_MI) diff(Joint7Ref_MI(3),A6_MI) diff(Joint7Ref_MI(3),A7_MI) diff(Joint7Ref_MI(3),B7_MI) diff(Joint7Ref_MI(3),C7_MI) diff(Joint7Ref_MI(3),D7_MI) diff(Joint7Ref_MI(3),A0_MI) diff(Joint7Ref_MI(3),B0_MI) diff(Joint7Ref_MI(3),C0_MI) diff(Joint7Ref_MI(3),D0_MI) diff(Joint7Ref_MI(3),E0_MI) diff(Joint7Ref_MI(3),F0_MI)];

% ccode(JacobianMatRef_MI,'file','JacobianMatRef_MI2.txt');
% 'JacobianMatRef_MI written'

for iter=2500:500:4000
    
    mag=sqrt(data3(iter,T1*3+1)^2+data3(iter,T1*3+2)^2+data3(iter,T1*3+3)^2);
    a=data3(iter,T1*3+1)/mag;
    b=data3(iter,T1*3+2)/mag;

    X=atan2(gamma,alpha);
    if alpha*alpha+gamma*gamma-a*a>0
        TH1_TH(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
    else
        TH1_TH(iter)=atan2(0,a)-X;
    end

    if TH1_TH(iter)>pi/2
        TH1_TH(iter)=pi/2;
    elseif TH1_TH(iter)<-pi/2
        TH1_TH(iter)=-pi/2;
    end

    Y(iter)=sin(TH1_TH(iter))*alpha+cos(TH1_TH(iter))*gamma;
    if Y(iter)*Y(iter)+beta*beta-b*b<0
        TH2_TH(iter)=atan2(b,0)-atan2(beta,Y(iter));
    else
        TH2_TH(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
    end

    if TH2_TH(iter)>pi/2
        TH2_TH(iter)=pi/2;
    elseif TH2_TH(iter)<-pi/2
        TH2_TH(iter)=-pi/2;
    end

    
    mag=sqrt(data3(iter,T2*3+1)^2+data3(iter,T2*3+2)^2+data3(iter,T2*3+3)^2);
    a=data3(iter,T2*3+1)/mag;
    b=data3(iter,T2*3+2)/mag;

    X=atan2(alpha,gamma);
    if alpha*alpha+gamma*gamma-a*a>0
        TH4_TH(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
    else
        TH4_TH(iter)=atan2(a,0)-X;
    end

    if TH4_TH(iter)>pi/2
        TH4_TH(iter)=pi/2;
    elseif TH4_TH(iter)<-pi/2
        TH4_TH(iter)=-pi/2;
    end

    Y(iter)=-sin(TH4_TH(iter))*alpha+cos(TH4_TH(iter))*gamma;
    if Y(iter) == 0
        Y(iter)=0.00001;
    end
    if Y(iter)*Y(iter)+beta*beta-b*b<0
        TH3_TH(iter)=atan2(0,b)-atan2(Y(iter),beta);
    else
        TH3_TH(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
    end

    if TH3_TH(iter)>pi/2
        TH3_TH(iter)=pi/2;
    elseif TH3_TH(iter)<-pi/2
        TH3_TH(iter)=-pi/2;
    end

    TH4_TH(iter)=TH4_TH(iter)+pi/4;

    TH1_TH(iter)=TH1_TH(iter)-off_TH1_TH;
    TH2_TH(iter)=TH2_TH(iter)-off_TH2_TH;
    TH3_TH(iter)=TH3_TH(iter)-off_TH3_TH;
    TH4_TH(iter)=TH4_TH(iter)-off_TH4_TH;
    
    
    mag=sqrt(data3(iter,M1*3+1)^2+data3(iter,M1*3+2)^2+data3(iter,M1*3+3)^2);
    a=data3(iter,M1*3+1)/mag;
    b=data3(iter,M1*3+2)/mag;

    X=atan2(gamma,alpha);
    if alpha*alpha+gamma*gamma-a*a>0
        TH1_MI(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
    else
        TH1_MI(iter)=atan2(0,a)-X;
    end

    if TH1_MI(iter)>pi/2
        TH1_MI(iter)=pi/2;
    elseif TH1_MI(iter)<-pi/2
        TH1_MI(iter)=-pi/2;
    end

    Y(iter)=sin(TH1_MI(iter))*alpha+cos(TH1_MI(iter))*gamma;
    if Y(iter)*Y(iter)+beta*beta-b*b<0
        TH2_MI(iter)=atan2(b,0)-atan2(beta,Y(iter));
    else
        TH2_MI(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
    end

    if TH2_MI(iter)>pi/2
        TH2_MI(iter)=pi/2;
    elseif TH2_MI(iter)<-pi/2
        TH2_MI(iter)=-pi/2;
    end
    
    mag=sqrt(data3(iter,M2*3+1)^2+data3(iter,M2*3+2)^2+data3(iter,M2*3+3)^2);
    a=data3(iter,M2*3+1)/mag;
    b=data3(iter,M2*3+2)/mag;

    X=atan2(alpha,gamma);
    if alpha*alpha+gamma*gamma-a*a>0
        TH4_MI(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
    else
        TH4_MI(iter)=atan2(a,0)-X;
    end

    if TH4_MI(iter)>pi/2
        TH4_MI(iter)=pi/2;
    elseif TH4_MI(iter)<-pi/2
        TH4_MI(iter)=-pi/2;
    end

    Y(iter)=-sin(TH4_MI(iter))*alpha+cos(TH4_MI(iter))*gamma;
    if Y(iter) == 0
        Y(iter)=0.00001;
    end
    if Y(iter)*Y(iter)+beta*beta-b*b<0
        TH3_MI(iter)=atan2(0,b)-atan2(Y(iter),beta);
    else
        TH3_MI(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
    end

    if TH3_MI(iter)>pi/2
        TH3_MI(iter)=pi/2;
    elseif TH3_MI(iter)<-pi/2
        TH3_MI(iter)=-pi/2;
    end

    TH4_MI(iter)=TH4_MI(iter)+pi/4;

    TH1_MI(iter)=TH1_MI(iter)-off_TH1_MI;
    TH2_MI(iter)=TH2_MI(iter)-off_TH2_MI;
    TH3_MI(iter)=TH3_MI(iter)-off_TH3_MI;
    TH4_MI(iter)=TH4_MI(iter)-off_TH4_MI;
    
    A1_TH=q_TH_double(1); B1_TH=q_TH_double(2); C1_TH=q_TH_double(3); D1_TH=q_TH_double(4);
    A2_TH=q_TH_double(5); B2_TH=TH1_TH(iter); C2_TH=q_TH_double(6); D2_TH=q_TH_double(7);
    A3_TH=q_TH_double(8); B3_TH=TH2_TH(iter); C3_TH=l2_TH; D3_TH=0;
    A4_TH=0; B4_TH=-pi/2; C4_TH=l3_TH; D4_TH=q_TH_double(9);
    A5_TH=q_TH_double(10); B5_TH=TH3_TH(iter); C5_TH=q_TH_double(11); D5_TH=q_TH_double(12);
    A6_TH=q_TH_double(13); B6_TH=TH4_TH(iter); C6_TH=l5_TH; D6_TH=0;
    A7_TH=q_TH_double(14); B7_TH=q_TH_double(15); C7_TH=q_TH_double(16); D7_TH=q_TH_double(17);
    A8_TH=l7_TH; B8_TH=pi/2; C8_TH=l8_TH; D8_TH=0; A0_TH=q_TH_double(18); B0_TH=q_TH_double(19); C0_TH=q_TH_double(20); D0_TH=q_TH_double(21); E0_TH=q_TH_double(22); F0_TH=q_TH_double(23);
    
    A1_MI=q_MI_double(1); B1_MI=q_MI_double(2); C1_MI=q_MI_double(3); D1_MI=q_MI_double(4);
    A2_MI=q_MI_double(5); B2_MI=TH1_MI(iter); C2_MI=q_MI_double(6); D2_MI=q_MI_double(7);
    A3_MI=q_MI_double(8); B3_MI=TH2_MI(iter); C3_MI=l2_MI; D3_MI=0;
    A4_MI=0; B4_MI=-pi/2; C4_MI=l3_MI; D4_MI=q_MI_double(9);
    A5_MI=q_MI_double(10); B5_MI=TH3_MI(iter); C5_MI=q_MI_double(11); D5_MI=q_MI_double(12);
    A6_MI=q_MI_double(13); B6_MI=TH4_MI(iter); C6_MI=l5_MI; D6_MI=0;
    A7_MI=q_MI_double(14); B7_MI=q_MI_double(15); C7_MI=q_MI_double(16); D7_MI=q_MI_double(17);
    A8_MI=l7_MI; B8_MI=pi/2; C8_MI=l8_MI; D8_MI=0; A0_MI=q_MI_double(18); B0_MI=q_MI_double(19); C0_MI=q_MI_double(20); D0_MI=q_MI_double(21); E0_MI=q_MI_double(22); F0_MI=q_MI_double(23);
   
    Joint7_TH=  subs(Joint7Ref_TH);
    Joint7_TH = vpa(Joint7_TH);
    Joint7_MI= subs(Joint7Ref_MI);
    Joint7_MI = vpa(Joint7_MI);
    
    for i=1:iteration
        error_TH=Joint7_MI-Joint7_TH;

        JacobianMat_TH=subs(JacobianMatRef_TH);
        JacobianMat_TH=vpa(JacobianMat_TH);

        dq_TH_=(JacobianMat_TH*JacobianMat_TH'+lambda*eye(3))\error_TH;
        dq_TH=JacobianMat_TH'*dq_TH_;
        q_TH_double=subs(qRef_TH);
        q_TH_double=vpa(q_TH_double+dq_TH);

        A1_TH=q_TH_double(1); B1_TH=q_TH_double(2); C1_TH=q_TH_double(3); D1_TH=q_TH_double(4);
        A2_TH=q_TH_double(5); C2_TH=q_TH_double(6); D2_TH=q_TH_double(7);
        A3_TH=q_TH_double(8); C3_TH=l2_TH; D3_TH=0;
        A4_TH=0; B4_TH=-pi/2; C4_TH=l3_TH; D4_TH=q_TH_double(9);
        A5_TH=q_TH_double(10); C5_TH=q_TH_double(11); D5_TH=q_TH_double(12);
        A6_TH=q_TH_double(13); C6_TH=l5_TH; D6_TH=0;
        A7_TH=q_TH_double(14); B7_TH=q_TH_double(15); C7_TH=q_TH_double(16); D7_TH=q_TH_double(17);
        A8_TH=l7_TH; B8_TH=pi/2; C8_TH=l8_TH; D8_TH=0; A0_TH=q_TH_double(18); B0_TH=q_TH_double(19); C0_TH=q_TH_double(20); D0_TH=q_TH_double(21); E0_TH=q_TH_double(22); F0_TH=q_TH_double(23);

        Joint7_TH=subs(Joint7Ref_TH);
        Joint7_TH=vpa(Joint7_TH);
        
        error_MI=Joint7_TH-Joint7_MI;      
        
        JacobianMat_MI=subs(JacobianMatRef_MI);
        %JacobianMat=double(JacobianMat);

        dq_MI_=(JacobianMat_MI*JacobianMat_MI'+lambda*eye(3))\error_MI;
        dq_MI=JacobianMat_MI'*dq_MI_;
        q_MI_double=subs(qRef_MI);
        q_MI_double=vpa(q_MI_double+dq_MI);

        A1_MI=q_MI_double(1); B1_MI=q_MI_double(2); C1_MI=q_MI_double(3); D1_MI=q_MI_double(4);
        A2_MI=q_MI_double(5); C2_MI=q_MI_double(6); D2_MI=q_MI_double(7);
        A3_MI=q_MI_double(8); C3_MI=l2_MI; D3_MI=0;
        A4_MI=0; B4_MI=-pi/2; C4_MI=l3_MI; D4_MI=q_MI_double(9);
        A5_MI=q_MI_double(10); C5_MI=q_MI_double(11); D5_MI=q_MI_double(12);
        A6_MI=q_MI_double(13); C6_MI=l5_MI; D6_MI=0;
        A7_MI=q_MI_double(14); B7_MI=q_MI_double(15); C7_MI=q_MI_double(16); D7_MI=q_MI_double(17);
        A8_MI=l7_MI; B8_MI=pi/2; C8_MI=l8_MI; D8_MI=0; A0_MI=q_MI_double(18); B0_MI=q_MI_double(19); C0_MI=q_MI_double(20); D0_MI=q_MI_double(21); E0_MI=q_MI_double(22); F0_MI=q_MI_double(23);

        Joint7_MI=subs(Joint7Ref_MI);
        Joint7_MI=vpa(Joint7_MI);
    end
end


for iter=500:500:2000
    
    mag=sqrt(data3(iter,T1*3+1)^2+data3(iter,T1*3+2)^2+data3(iter,T1*3+3)^2);
    a=data3(iter,T1*3+1)/mag;
    b=data3(iter,T1*3+2)/mag;
    

    X=atan2(gamma,alpha);
    if alpha*alpha+gamma*gamma-a*a>0
        TH1_TH(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
    else
        TH1_TH(iter)=atan2(0,a)-X;
    end

    if TH1_TH(iter)>pi/2
        TH1_TH(iter)=pi/2;
    elseif TH1_TH(iter)<-pi/2
        TH1_TH(iter)=-pi/2;
    end

    Y(iter)=sin(TH1_TH(iter))*alpha+cos(TH1_TH(iter))*gamma;
    if Y(iter)*Y(iter)+beta*beta-b*b<0
        TH2_TH(iter)=atan2(b,0)-atan2(beta,Y(iter));
    else
        TH2_TH(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
    end

    if TH2_TH(iter)>pi/2
        TH2_TH(iter)=pi/2;
    elseif TH2_TH(iter)<-pi/2
        TH2_TH(iter)=-pi/2;
    end

    
    mag=sqrt(data3(iter,T2*3+1)^2+data3(iter,T2*3+2)^2+data3(iter,T2*3+3)^2);
    a=data3(iter,T2*3+1)/mag;
    b=data3(iter,T2*3+2)/mag;

    X=atan2(alpha,gamma);
    if alpha*alpha+gamma*gamma-a*a>0
        TH4_TH(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
    else
        TH4_TH(iter)=atan2(a,0)-X;
    end

    if TH4_TH(iter)>pi/2
        TH4_TH(iter)=pi/2;
    elseif TH4_TH(iter)<-pi/2
        TH4_TH(iter)=-pi/2;
    end

    Y(iter)=-sin(TH4_TH(iter))*alpha+cos(TH4_TH(iter))*gamma;
    if Y(iter) == 0
        Y(iter)=0.00001;
    end
    if Y(iter)*Y(iter)+beta*beta-b*b<0
        TH3_TH(iter)=atan2(0,b)-atan2(Y(iter),beta);
    else
        TH3_TH(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
    end

    if TH3_TH(iter)>pi/2
        TH3_TH(iter)=pi/2;
    elseif TH3_TH(iter)<-pi/2
        TH3_TH(iter)=-pi/2;
    end

    TH4_TH(iter)=TH4_TH(iter)+pi/4;

    TH1_TH(iter)=TH1_TH(iter)-off_TH1_TH;
    TH2_TH(iter)=TH2_TH(iter)-off_TH2_TH;
    TH3_TH(iter)=TH3_TH(iter)-off_TH3_TH;
    TH4_TH(iter)=TH4_TH(iter)-off_TH4_TH;
    
    mag=sqrt(data3(iter,I1*3+1)^2+data3(iter,I1*3+2)^2+data3(iter,I1*3+3)^2);
    a=data3(iter,I1*3+1)/mag;
    b=data3(iter,I1*3+2)/mag;

    X=atan2(gamma,alpha);
    if alpha*alpha+gamma*gamma-a*a>0
        TH1(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
    else
        TH1(iter)=atan2(0,a)-X;
    end

    if TH1(iter)>pi/2
        TH1(iter)=pi/2;
    elseif TH1(iter)<-pi/2
        TH1(iter)=-pi/2;
    end

    Y(iter)=sin(TH1(iter))*alpha+cos(TH1(iter))*gamma;
    if Y(iter)*Y(iter)+beta*beta-b*b<0
        TH2(iter)=atan2(b,0)-atan2(beta,Y(iter));
    else
        TH2(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
    end

    if TH2(iter)>pi/2
        TH2(iter)=pi/2;
    elseif TH2(iter)<-pi/2
        TH2(iter)=-pi/2;
    end
    
    mag=sqrt(data3(iter,I2*3+1)^2+data3(iter,I2*3+2)^2+data3(iter,I2*3+3)^2);
    a=data3(iter,I2*3+1)/mag;
    b=data3(iter,I2*3+2)/mag;

    X=atan2(alpha,gamma);
    if alpha*alpha+gamma*gamma-a*a>0
        TH4(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
    else
        TH4(iter)=atan2(a,0)-X;
    end

    if TH4(iter)>pi/2
        TH4(iter)=pi/2;
    elseif TH4(iter)<-pi/2
        TH4(iter)=-pi/2;
    end


    Y(iter)=-sin(TH4(iter))*alpha+cos(TH4(iter))*gamma;
    if Y(iter) == 0
        Y(iter)=0.00001;
    end
    if Y(iter)*Y(iter)+beta*beta-b*b<0
        TH3(iter)=atan2(0,b)-atan2(Y(iter),beta);
    else
        TH3(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
    end

    if TH3(iter)>pi/2
        TH3(iter)=pi/2;
    elseif TH3(iter)<-pi/2
        TH3(iter)=-pi/2;
    end

    TH4(iter)=TH4(iter)+pi/4;

    TH1(iter)=TH1(iter)-off_TH1;
    TH2(iter)=TH2(iter)-off_TH2;
    TH3(iter)=TH3(iter)-off_TH3;
    TH4(iter)=TH4(iter)-off_TH4;

    A1_TH=q_TH_double(1); B1_TH=q_TH_double(2); C1_TH=q_TH_double(3); D1_TH=q_TH_double(4);
    A2_TH=q_TH_double(5); B2_TH=TH1_TH(iter); C2_TH=q_TH_double(6); D2_TH=q_TH_double(7);
    A3_TH=q_TH_double(8); B3_TH=TH2_TH(iter); C3_TH=l2_TH; D3_TH=0;
    A4_TH=0; B4_TH=-pi/2; C4_TH=l3_TH; D4_TH=q_TH_double(9);
    A5_TH=q_TH_double(10); B5_TH=TH3_TH(iter); C5_TH=q_TH_double(11); D5_TH=q_TH_double(12);
    A6_TH=q_TH_double(13); B6_TH=TH4_TH(iter); C6_TH=l5_TH; D6_TH=0;
    A7_TH=q_TH_double(14); B7_TH=q_TH_double(15); C7_TH=q_TH_double(16); D7_TH=q_TH_double(17);
    A8_TH=l7_TH; B8_TH=pi/2; C8_TH=l8_TH; D8_TH=0; A0_TH=q_TH_double(18); B0_TH=q_TH_double(19); C0_TH=q_TH_double(20); D0_TH=q_TH_double(21); E0_TH=q_TH_double(22); F0_TH=q_TH_double(23);

    A1=q_double(1); B1=q_double(2); C1=q_double(3); D1=q_double(4);
    A2=q_double(5); B2=TH1(iter); C2=q_double(6); D2=q_double(7);
    A3=q_double(8); B3=TH2(iter); C3=l2; D3=0;
    A4=0; B4=-pi/2; C4=l3; D4=q_double(9);
    A5=q_double(10); B5=TH3(iter); C5=q_double(11); D5=q_double(12);
    A6=q_double(13); B6=TH4(iter); C6=l5; D6=0;
    A7=q_double(14); B7=q_double(15); C7=q_double(16); D7=q_double(17);
    A8=l7; B8=pi/2; C8=l8; D8=0;

    Joint7_TH=  subs(Joint7Ref_TH);
    Joint7_TH = vpa(Joint7_TH)
    Joint7= subs(Joint7Ref);
    Joint7 = vpa(Joint7)
    
    for i=1:iteration
        error=Joint7_TH-Joint7;
        
        JacobianMat=subs(JacobianMatRef);
        JacobianMat=vpa(JacobianMat);

        dq_=(JacobianMat*JacobianMat'+lambda*eye(3))\error;
        dq=JacobianMat'*dq_;
        q_double=subs(qRef);
        q_double=vpa(q_double+dq);

        A1=q_double(1); B1=q_double(2); C1=q_double(3); D1=q_double(4);
        A2=q_double(5); C2=q_double(6); D2=q_double(7);
        A3=q_double(8); C3=l2; D3=0;
        A4=0; B4=-pi/2; C4=l3; D4=q_double(9);
        A5=q_double(10); C5=q_double(11); D5=q_double(12);
        A6=q_double(13); C6=l5; D6=0;
        A7=q_double(14); B7=q_double(15); C7=q_double(16); D7=q_double(17);
        A8=l7; B8=pi/2; C8=l8; D8=0;
    
        Joint7=subs(Joint7Ref);
        Joint7=vpa(Joint7);
    end
end

DHoff=[subs(q_double) subs(q_TH_double) subs(q_MI_double)];
% 
% for iter=1:4
%     
%     mag=sqrt(data3(iter,1)^2+data3(iter,2)^2+data3(iter,3)^2);
%     a=data3(iter,1)/mag;
%     b=data3(iter,2)/mag;
% 
%     X=atan2(gamma,alpha);
%     if alpha*alpha+gamma*gamma-a*a>0
%         TH1_TH(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
%     else
%         TH1_TH(iter)=atan2(0,a)-X;
%     end
% 
%     if TH1_TH(iter)>pi/2
%         TH1_TH(iter)=pi/2;
%     elseif TH1_TH(iter)<-pi/2
%         TH1_TH(iter)=-pi/2;
%     end
% 
%     Y(iter)=sin(TH1_TH(iter))*alpha+cos(TH1_TH(iter))*gamma;
%     if Y(iter)*Y(iter)+beta*beta-b*b<0
%         TH2_TH(iter)=atan2(b,0)-atan2(beta,Y(iter));
%     else
%         TH2_TH(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
%     end
% 
%     if TH2_TH(iter)>pi/2
%         TH2_TH(iter)=pi/2;
%     elseif TH2_TH(iter)<-pi/2
%         TH2_TH(iter)=-pi/2;
%     end
% 
%     mag=sqrt(data3(iter,4)^2+data3(iter,5)^2+data3(iter,6)^2);
%     a=data3(iter,4)/mag;
%     b=data3(iter,5)/mag;
% 
%     X=atan2(alpha,gamma);
%     if alpha*alpha+gamma*gamma-a*a>0
%         TH4_TH(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
%     else
%         TH4_TH(iter)=atan2(a,0)-X;
%     end
% 
%     if TH4_TH(iter)>pi/2
%         TH4_TH(iter)=pi/2;
%     elseif TH4_TH(iter)<-pi/2
%         TH4_TH(iter)=-pi/2;
%     end
% 
%     Y(iter)=-sin(TH4_TH(iter))*alpha+cos(TH4_TH(iter))*gamma;
%     if Y(iter) == 0
%         Y(iter)=0.00001;
%     end
%     if Y(iter)*Y(iter)+beta*beta-b*b<0
%         TH3_TH(iter)=atan2(0,b)-atan2(Y(iter),beta);
%     else
%         TH3_TH(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
%     end
% 
%     if TH3_TH(iter)>pi/2
%         TH3_TH(iter)=pi/2;
%     elseif TH3_TH(iter)<-pi/2
%         TH3_TH(iter)=-pi/2;
%     end
% 
%     TH4_TH(iter)=TH4_TH(iter)+pi/4;
% 
%     TH1_TH(iter)=TH1_TH(iter)-off_TH1_TH;
%     TH2_TH(iter)=TH2_TH(iter)-off_TH2_TH;
%     TH3_TH(iter)=TH3_TH(iter)-off_TH3_TH;
%     TH4_TH(iter)=TH4_TH(iter)-off_TH4_TH;
%     
%     mag=sqrt(data3(iter,I1*3+1)^2+data3(iter,I1*3+2)^2+data3(iter,I1*3+3)^2);
%     a=data3(iter,I1*3+1)/mag;
%     b=data3(iter,I1*3+2)/mag;
% 
%     X=atan2(gamma,alpha);
%     if alpha*alpha+gamma*gamma-a*a>0
%         TH1(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
%     else
%         TH1(iter)=atan2(0,a)-X;
%     end
% 
%     if TH1(iter)>pi/2
%         TH1(iter)=pi/2;
%     elseif TH1(iter)<-pi/2
%         TH1(iter)=-pi/2;
%     end
% 
%     Y(iter)=-sin(TH1(iter))*alpha+cos(TH1(iter))*gamma;
%     if Y(iter)*Y(iter)+beta*beta-b*b<0
%         TH2(iter)=atan2(b,0)-atan2(beta,Y(iter));
%     else
%         TH2(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
%     end
% 
%     if TH2(iter)>pi/2
%         TH2(iter)=pi/2;
%     elseif TH2(iter)<-pi/2
%         TH2(iter)=-pi/2;
%     end
% 
%     
%     mag=sqrt(data3(iter,I2*3+1)^2+data3(iter,I2*3+2)^2+data3(iter,I2*3+3)^2);
%     a=data3(iter,I2*3+1)/mag;
%     b=data3(iter,I2*3+2)/mag;
% 
%     X=atan2(alpha,gamma);
%     if alpha*alpha+gamma*gamma-a*a>0
%         TH4(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
%     else
%         TH4(iter)=atan2(a,0)-X;
%     end
% 
%     if TH4(iter)>pi/2
%         TH4(iter)=pi/2;
%     elseif TH4(iter)<-pi/2
%         TH4(iter)=-pi/2;
%     end
% 
% 
%     Y(iter)=-sin(TH4(iter))*alpha+cos(TH4(iter))*gamma;
%     if Y(iter) == 0
%         Y(iter)=0.00001;
%     end
%     if Y(iter)*Y(iter)+beta*beta-b*b<0
%         TH3(iter)=atan2(0,b)-atan2(Y(iter),beta);
%     else
%         TH3(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
%     end
% 
%     if TH3(iter)>pi/2
%         TH3(iter)=pi/2;
%     elseif TH3(iter)<-pi/2
%         TH3(iter)=-pi/2;
%     end
% 
%     TH4(iter)=TH4(iter)+pi/4;
% 
%     TH1(iter)=TH1(iter)-off_TH1;
%     TH2(iter)=TH2(iter)-off_TH2;
%     TH3(iter)=TH3(iter)-off_TH3;
%     TH4(iter)=TH4(iter)-off_TH4;
%     
%     A1_TH=q_TH_double(1); B1_TH=q_TH_double(2); C1_TH=q_TH_double(3); D1_TH=q_TH_double(4);
%     A2_TH=q_TH_double(5); B2_TH=TH1_TH(iter); C2_TH=q_TH_double(6); D2_TH=q_TH_double(7);
%     A3_TH=q_TH_double(8); B3_TH=TH2_TH(iter); C3_TH=l2_TH; D3_TH=0;
%     A4_TH=0; B4_TH=-pi/2; C4_TH=l3_TH; D4_TH=q_TH_double(9);
%     A5_TH=q_TH_double(10); B5_TH=TH3_TH(iter); C5_TH=q_TH_double(11); D5_TH=q_TH_double(12);
%     A6_TH=q_TH_double(13); B6_TH=TH4_TH(iter); C6_TH=l5_TH; D6_TH=0;
%     A7_TH=q_TH_double(14); B7_TH=q_TH_double(15); C7_TH=q_TH_double(16); D7_TH=q_TH_double(17);
%     A8_TH=l7_TH; B8_TH=pi/2; C8_TH=l8_TH; D8_TH=0; A0_TH=q_TH_double(18); B0_TH=q_TH_double(19); C0_TH=q_TH_double(20); D0_TH=q_TH_double(21); E0_TH=q_TH_double(22); F0_TH=q_TH_double(23);
% 
%     A1=q_double(1); B1=q_double(2); C1=q_double(3); D1=q_double(4);
%     A2=q_double(5); B2=TH1(iter); C2=q_double(6); D2=q_double(7);
%     A3=q_double(8); B3=TH2(iter); C3=l2; D3=0;
%     A4=0; B4=-pi/2; C4=l3; D4=q_double(9);
%     A5=q_double(10); B5=TH3(iter); C5=q_double(11); D5=q_double(12);
%     A6=q_double(13); B6=TH4(iter); C6=l5; D6=0;
%     A7=q_double(14); B7=q_double(15); C7=q_double(16); D7=q_double(17);
%     A8=l7; B8=pi/2; C8=l8; D8=0;
%     
%     Joint7_TH=  subs(Joint7Ref_TH);
%     Joint7_TH = vpa(Joint7_TH);
%     Joint7= subs(Joint7Ref);
%     Joint7 = vpa(Joint7);
%     
%     Results(:,iter)=Joint7_TH-Joint7;
% end
% 
% for iter=5:8
%     
%     mag=sqrt(data3(iter,T1*3+1)^2+data3(iter,T1*3+2)^2+data3(iter,T1*3+3)^2);
%     a=data3(iter,T1*3+1)/mag;
%     b=data3(iter,T1*3+2)/mag;
% 
%     X=atan2(gamma,alpha);
%     if alpha*alpha+gamma*gamma-a*a>0
%         TH1_TH(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
%     else
%         TH1_TH(iter)=atan2(0,a)-X;
%     end
% 
%     if TH1_TH(iter)>pi/2
%         TH1_TH(iter)=pi/2;
%     elseif TH1_TH(iter)<-pi/2
%         TH1_TH(iter)=-pi/2;
%     end
% 
%     Y(iter)=sin(TH1_TH(iter))*alpha+cos(TH1_TH(iter))*gamma;
%     if Y(iter)*Y(iter)+beta*beta-b*b<0
%         TH2_TH(iter)=atan2(b,0)-atan2(beta,Y(iter));
%     else
%         TH2_TH(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
%     end
% 
%     if TH2_TH(iter)>pi/2
%         TH2_TH(iter)=pi/2;
%     elseif TH2_TH(iter)<-pi/2
%         TH2_TH(iter)=-pi/2;
%     end
% 
%     
%     mag=sqrt(data3(iter,T2*3+1)^2+data3(iter,T2*3+2)^2+data3(iter,T2*3+3)^2);
%     a=data3(iter,T2*3+1)/mag;
%     b=data3(iter,T2*3+2)/mag;
% 
%     X=atan2(alpha,gamma);
%     if alpha*alpha+gamma*gamma-a*a>0
%         TH4_TH(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
%     else
%         TH4_TH(iter)=atan2(a,0)-X;
%     end
% 
%     if TH4_TH(iter)>pi/2
%         TH4_TH(iter)=pi/2;
%     elseif TH4_TH(iter)<-pi/2
%         TH4_TH(iter)=-pi/2;
%     end
% 
%     Y(iter)=-sin(TH4_TH(iter))*alpha+cos(TH4_TH(iter))*gamma;
%     if Y(iter) == 0
%         Y(iter)=0.00001;
%     end
%     if Y(iter)*Y(iter)+beta*beta-b*b<0
%         TH3_TH(iter)=atan2(0,b)-atan2(Y(iter),beta);
%     else
%         TH3_TH(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
%     end
% 
%     if TH3_TH(iter)>pi/2
%         TH3_TH(iter)=pi/2;
%     elseif TH3_TH(iter)<-pi/2
%         TH3_TH(iter)=-pi/2;
%     end
% 
%     TH4_TH(iter)=TH4_TH(iter)+pi/4;
% 
%     TH1_TH(iter)=TH1_TH(iter)-off_TH1_TH;
%     TH2_TH(iter)=TH2_TH(iter)-off_TH2_TH;
%     TH3_TH(iter)=TH3_TH(iter)-off_TH3_TH;
%     TH4_TH(iter)=TH4_TH(iter)-off_TH4_TH;
%     
%     
%     mag=sqrt(data3(iter,M1*3+1)^2+data3(iter,M1*3+2)^2+data3(iter,M1*3+3)^2);
%     a=data3(iter,M1*3+1)/mag;
%     b=data3(iter,M1*3+2)/mag;
% 
%     X=atan2(gamma,alpha);
%     if alpha*alpha+gamma*gamma-a*a>0
%         TH1_MI(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
%     else
%         TH1_MI(iter)=atan2(0,a)-X;
%     end
% 
%     if TH1_MI(iter)>pi/2
%         TH1_MI(iter)=pi/2;
%     elseif TH1_MI(iter)<-pi/2
%         TH1_MI(iter)=-pi/2;
%     end
% 
%     Y(iter)=sin(TH1_MI(iter))*alpha+cos(TH1_MI(iter))*gamma;
%     if Y(iter)*Y(iter)+beta*beta-b*b<0
%         TH2_MI(iter)=atan2(b,0)-atan2(beta,Y(iter));
%     else
%         TH2_MI(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
%     end
% 
%     if TH2_MI(iter)>pi/2
%         TH2_MI(iter)=pi/2;
%     elseif TH2_MI(iter)<-pi/2
%         TH2_MI(iter)=-pi/2;
%     end
%     
%     mag=sqrt(data3(iter,M2*3+1)^2+data3(iter,M2*3+2)^2+data3(iter,M2*3+3)^2);
%     a=data3(iter,M2*3+1)/mag;
%     b=data3(iter,M2*3+2)/mag;
% 
%     X=atan2(alpha,gamma);
%     if alpha*alpha+gamma*gamma-a*a>0
%         TH4_MI(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
%     else
%         TH4_MI(iter)=atan2(a,0)-X;
%     end
% 
%     if TH4_MI(iter)>pi/2
%         TH4_MI(iter)=pi/2;
%     elseif TH4_MI(iter)<-pi/2
%         TH4_MI(iter)=-pi/2;
%     end
% 
%     Y(iter)=-sin(TH4_MI(iter))*alpha+cos(TH4_MI(iter))*gamma;
%     if Y(iter) == 0
%         Y(iter)=0.00001;
%     end
%     if Y(iter)*Y(iter)+beta*beta-b*b<0
%         TH3_MI(iter)=atan2(0,b)-atan2(Y(iter),beta);
%     else
%         TH3_MI(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
%     end
% 
%     if TH3_MI(iter)>pi/2
%         TH3_MI(iter)=pi/2;
%     elseif TH3_MI(iter)<-pi/2
%         TH3_MI(iter)=-pi/2;
%     end
% 
%     TH4_MI(iter)=TH4_MI(iter)+pi/4;
% 
%     TH1_MI(iter)=TH1_MI(iter)-off_TH1_MI;
%     TH2_MI(iter)=TH2_MI(iter)-off_TH2_MI;
%     TH3_MI(iter)=TH3_MI(iter)-off_TH3_MI;
%     TH4_MI(iter)=TH4_MI(iter)-off_TH4_MI;
%     
%     A1_TH=q_TH_double(1); B1_TH=q_TH_double(2); C1_TH=q_TH_double(3); D1_TH=q_TH_double(4);
%     A2_TH=q_TH_double(5); B2_TH=TH1_TH(iter); C2_TH=q_TH_double(6); D2_TH=q_TH_double(7);
%     A3_TH=q_TH_double(8); B3_TH=TH2_TH(iter); C3_TH=l2_TH; D3_TH=0;
%     A4_TH=0; B4_TH=-pi/2; C4_TH=l3_TH; D4_TH=q_TH_double(9);
%     A5_TH=q_TH_double(10); B5_TH=TH3_TH(iter); C5_TH=q_TH_double(11); D5_TH=q_TH_double(12);
%     A6_TH=q_TH_double(13); B6_TH=TH4_TH(iter); C6_TH=l5_TH; D6_TH=0;
%     A7_TH=q_TH_double(14); B7_TH=q_TH_double(15); C7_TH=q_TH_double(16); D7_TH=q_TH_double(17);
%     A8_TH=l7_TH; B8_TH=pi/2; C8_TH=l8_TH; D8_TH=0; A0_TH=q_TH_double(18); B0_TH=q_TH_double(19); C0_TH=q_TH_double(20); D0_TH=q_TH_double(21); E0_TH=q_TH_double(22); F0_TH=q_TH_double(23);
%     
%     A1_MI=q_MI_double(1); B1_MI=q_MI_double(2); C1_MI=q_MI_double(3); D1_MI=q_MI_double(4);
%     A2_MI=q_MI_double(5); B2_MI=TH1_MI(iter); C2_MI=q_MI_double(6); D2_MI=q_MI_double(7);
%     A3_MI=q_MI_double(8); B3_MI=TH2_MI(iter); C3_MI=l2_MI; D3_MI=0;
%     A4_MI=0; B4_MI=-pi/2; C4_MI=l3_MI; D4_MI=q_MI_double(9);
%     A5_MI=q_MI_double(10); B5_MI=TH3_MI(iter); C5_MI=q_MI_double(11); D5_MI=q_MI_double(12);
%     A6_MI=q_MI_double(13); B6_MI=TH4_MI(iter); C6_MI=l5_MI; D6_MI=0;
%     A7_MI=q_MI_double(14); B7_MI=q_MI_double(15); C7_MI=q_MI_double(16); D7_MI=q_MI_double(17);
%     A8_MI=l7_MI; B8_MI=pi/2; C8_MI=l8_MI; D8_MI=0; A0_MI=q_MI_double(18); B0_MI=q_MI_double(19); C0_MI=q_MI_double(20); D0_MI=q_MI_double(21); E0_MI=q_MI_double(22); F0_MI=q_MI_double(23);
%  
%     Joint7_TH=  subs(Joint7Ref_TH);
%     Joint7_TH = vpa(Joint7_TH);
%     Joint7_MI= subs(Joint7Ref_MI);
%     Joint7_MI = vpa(Joint7_MI);
%     
%     Results(:,iter)=Joint7_TH-Joint7_MI;
% end

DHinit-double(DHoff)