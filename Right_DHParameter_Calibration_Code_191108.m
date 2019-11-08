%three finger experiment - 착용한 상황에서 thumb_index, thumb_middle이 닿은 상태의 data를
%얻은 후 lsqnonlin 사용해서 test
clear
clc
close all

%load csv data
data_thumb_index = csvread('R6_thumb_index.csv'); data_thumb_index = data_thumb_index(1:50, :);
data_thumb_middle = csvread('R6_thumb_middle.csv'); data_thumb_middle = data_thumb_middle(50:100, :);

alpha=0;
beta=0;
gamma=1;

% L6 is not constant, but variable
linkLength = loadLinkLength();

% DH paramters for thumb device
syms A1_THB B1_THB C1_THB D1_THB 
syms A2_THB B2_THB C2_THB D2_THB  
syms A3_THB B3_THB C3_THB D3_THB 
syms A4_THB B4_THB C4_THB D4_THB 
syms A5_THB B5_THB C5_THB D5_THB
syms A6_THB B6_THB C6_THB D6_THB 
syms A7_THB B7_THB C7_THB D7_THB
syms A8_THB B8_THB C8_THB D8_THB
% DH paramters for index device
syms A1_IDX B1_IDX C1_IDX D1_IDX 
syms A2_IDX B2_IDX C2_IDX D2_IDX  
syms A3_IDX B3_IDX C3_IDX D3_IDX  
syms A4_IDX B4_IDX C4_IDX D4_IDX  
syms A5_IDX B5_IDX C5_IDX D5_IDX  
syms A6_IDX B6_IDX C6_IDX D6_IDX  
syms A7_IDX B7_IDX C7_IDX D7_IDX
syms A8_IDX B8_IDX C8_IDX D8_IDX
% DH paramters for middle device
syms A1_MID B1_MID C1_MID D1_MID 
syms A2_MID B2_MID C2_MID D2_MID  
syms A3_MID B3_MID C3_MID D3_MID  
syms A4_MID B4_MID C4_MID D4_MID  
syms A5_MID B5_MID C5_MID D5_MID  
syms A6_MID B6_MID C6_MID D6_MID  
syms A7_MID B7_MID C7_MID D7_MID
syms A8_MID B8_MID C8_MID D8_MID

syms off_TH1_THB off_TH2_THB off_TH3_THB off_TH4_THB % thumb  device angle offset by sensor mis-alignment
syms off_TH1_IDX off_TH2_IDX off_TH3_IDX off_TH4_IDX % index  device angle offset by sensor mis-alignment
syms off_TH1_MID off_TH2_MID off_TH3_MID off_TH4_MID % middle device angle offset by sensor mis-alignment

DH_THB = [A1_THB B1_THB             C1_THB D1_THB;
          A2_THB B2_THB+off_TH1_THB C2_THB D2_THB;
          A3_THB B3_THB+off_TH2_THB C3_THB D3_THB;
          A4_THB B4_THB             C4_THB D4_THB;
          A5_THB B5_THB+off_TH3_THB C5_THB D5_THB;
          A6_THB B6_THB+off_TH4_THB C6_THB D6_THB;
          A7_THB B7_THB             C7_THB D7_THB;
          A8_THB B8_THB             C8_THB D8_THB;];

DH_IDX = [A1_IDX B1_IDX             C1_IDX D1_IDX;
          A2_IDX B2_IDX+off_TH1_IDX C2_IDX D2_IDX;
          A3_IDX B3_IDX+off_TH2_IDX C3_IDX D3_IDX;
          A4_IDX B4_IDX             C4_IDX D4_IDX;
          A5_IDX B5_IDX+off_TH3_IDX C5_IDX D5_IDX;
          A6_IDX B6_IDX+off_TH4_IDX C6_IDX D6_IDX;
          A7_IDX B7_IDX             C7_IDX D7_IDX;
          A8_IDX B8_IDX             C8_IDX D8_IDX;];

DH_MID = [A1_MID B1_MID             C1_MID D1_MID;
          A2_MID B2_MID+off_TH1_MID C2_MID D2_MID;
          A3_MID B3_MID+off_TH2_MID C3_MID D3_MID;
          A4_MID B4_MID             C4_MID D4_MID;
          A5_MID B5_MID+off_TH3_MID C5_MID D5_MID;
          A6_MID B6_MID+off_TH4_MID C6_MID D6_MID;
          A7_MID B7_MID             C7_MID D7_MID;
          A8_MID B8_MID             C8_MID D8_MID;];
   
R01_THB = transl(0,0,DH_THB(1,1))*[cos(DH_THB(1,2)) -sin(DH_THB(1,2)) 0 0; sin(DH_THB(1,2)) cos(DH_THB(1,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(1,3),0,0)*[1 0 0 0; 0 cos(DH_TH(1,4)) -sin(DH_TH(1,4)) 0; 0 sin(DH_TH(1,4)) cos(DH_TH(1,4)) 0; 0 0 0 1];
R12_THB = transl(0,0,DH_THB(2,1))*[cos(DH_THB(2,2)) -sin(DH_THB(2,2)) 0 0; sin(DH_THB(2,2)) cos(DH_THB(2,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(2,3),0,0)*[1 0 0 0; 0 cos(DH_TH(2,4)) -sin(DH_TH(2,4)) 0; 0 sin(DH_TH(2,4)) cos(DH_TH(2,4)) 0; 0 0 0 1];
R23_THB = transl(0,0,DH_THB(3,1))*[cos(DH_THB(3,2)) -sin(DH_THB(3,2)) 0 0; sin(DH_THB(3,2)) cos(DH_THB(3,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(3,3),0,0)*[1 0 0 0; 0 cos(DH_TH(3,4)) -sin(DH_TH(3,4)) 0; 0 sin(DH_TH(3,4)) cos(DH_TH(3,4)) 0; 0 0 0 1];
R34_THB = transl(0,0,DH_THB(4,1))*[cos(DH_THB(4,2)) -sin(DH_TH(4,2)) 0 0; sin(DH_TH(4,2)) cos(DH_TH(4,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(4,3),0,0)*[1 0 0 0; 0 cos(DH_TH(4,4)) -sin(DH_TH(4,4)) 0; 0 sin(DH_TH(4,4)) cos(DH_TH(4,4)) 0; 0 0 0 1];
R45_THB = transl(0,0,DH_THB(5,1))*[cos(DH_THB(5,2)) -sin(DH_TH(5,2)) 0 0; sin(DH_TH(5,2)) cos(DH_TH(5,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(5,3),0,0)*[1 0 0 0; 0 cos(DH_TH(5,4)) -sin(DH_TH(5,4)) 0; 0 sin(DH_TH(5,4)) cos(DH_TH(5,4)) 0; 0 0 0 1];
R56_THB = transl(0,0,DH_THB(6,1))*[cos(DH_THB(6,2)) -sin(DH_TH(6,2)) 0 0; sin(DH_TH(6,2)) cos(DH_TH(6,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(6,3),0,0)*[1 0 0 0; 0 cos(DH_TH(6,4)) -sin(DH_TH(6,4)) 0; 0 sin(DH_TH(6,4)) cos(DH_TH(6,4)) 0; 0 0 0 1];
R67_THB = transl(0,0,DH_THB(7,1))*[cos(DH_THB(7,2)) -sin(DH_TH(7,2)) 0 0; sin(DH_TH(7,2)) cos(DH_TH(7,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(7,3),0,0)*[1 0 0 0; 0 cos(DH_TH(7,4)) -sin(DH_TH(7,4)) 0; 0 sin(DH_TH(7,4)) cos(DH_TH(7,4)) 0; 0 0 0 1];
R78_THB = transl(0,0,DH_THB(8,1))*[cos(DH_THB(8,2)) -sin(DH_TH(8,2)) 0 0; sin(DH_TH(8,2)) cos(DH_TH(8,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DH_TH(8,3),0,0)*[1 0 0 0; 0 cos(DH_TH(8,4)) -sin(DH_TH(8,4)) 0; 0 sin(DH_TH(8,4)) cos(DH_TH(8,4)) 0; 0 0 0 1];
  