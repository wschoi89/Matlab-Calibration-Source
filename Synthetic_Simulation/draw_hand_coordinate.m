 clc,clear,close ('all')
 
Origin_TH = [ 0.5301   -0.6787    0.5083  -88.8053;
            -0.1689    0.5029    0.8477  -30.1988;
            -0.8309   -0.5352    0.1519  -25.3626;
              0       0      0       1];
Origin_IN = eye(4);         
 
Origin_MI = eye(4);Origin_MI(3,4) = 19;

% only variable 
Joint7_MI= [55.610214 -70.365082 11.065424];


figure
hold on

% draw index origin coordinate
draw_coordinate(Origin_TH)
text(Origin_TH(1,4),Origin_TH(2,4),Origin_TH(3,4),'thumb Origin');

% draw index origin coordinate
draw_coordinate(Origin_IN)
text(0,0,0,'Index Origin');

% draw middle origin coordinate
draw_coordinate(Origin_MI)
text(0,0,19,'Middle Origin');

hold on
% draw middle endeffector pssition
scatter3(Joint7_MI(1), Joint7_MI(2), Joint7_MI(3), '*')
text(Joint7_MI(1), Joint7_MI(2), Joint7_MI(3), 'Joint7 MI');

% draw estimated middle finger's origin coordinate
FingerOrigin_MI = Origin_IN*transl(0, Joint7_MI(2),Joint7_MI(3))*troty(90*pi/180); 
draw_coordinate(FingerOrigin_MI)
text(FingerOrigin_MI(1,4), FingerOrigin_MI(2,4),FingerOrigin_MI(3,4), 'Est middle origin');

FingerLength_MI = Joint7_MI(1);

FingerLength_MI_default = 101.6;
L1_MI_default = 46.2; 
L2_MI_default = 28.2; 
L3_MI_default = 27.2; 

scale3 = FingerLength_MI / FingerLength_MI_default;

Joint7 = [64.7867 -45.668 -25.53];
hold on
scatter3(Joint7(1), Joint7(2), Joint7(3), '*')
text(Joint7(1), Joint7(2), Joint7(3), 'Joint7');

% draw estimated index finger's origin coordinate
FingerOrigin = FingerOrigin_MI * transl(24.55989*scale3, -3.742*scale3, -0.2888*scale3);
draw_coordinate(FingerOrigin)
text(FingerOrigin(1,4), FingerOrigin(2,4),FingerOrigin(3,4), 'Est index origin');

FingerLength = sqrt((Joint7(1) - FingerOrigin(1,4))^2 +(Joint7(2) - FingerOrigin(2,4))^2+(Joint7(3) - FingerOrigin(3,4))^2);

FingerLength_default = 87.6;
L1_default = 38.7; 
L2_default = 24.8; 
L3_default = 24.1; 

scale2 = FingerLength/FingerLength_default;


% hand and thumb origin 
HandOrigin = [FingerOrigin(1, 4) - 81.141*scale3 FingerOrigin(2, 4) + 0.986*scale3 FingerOrigin(3, 4) + 29.0*scale3]; %estimated hand ÀÇ wrist 
hold on
scatter3(HandOrigin(1), HandOrigin(2), HandOrigin(3), '*')
text(HandOrigin(1), HandOrigin(2), HandOrigin(3), 'HandOrigin');

Joint7_TH = [3.957768 -58.7796 -49.414825];
hold on
scatter3(Joint7_TH(1), Joint7_TH(2), Joint7_TH(3), '*')
text(Joint7_TH(1), Joint7_TH(2), Joint7_TH(3), 'Joint7 TH');



FingerOriginLoc_TH = zeros(1,3);
FingerOriginLoc_TH(1) = HandOrigin(1) + 27.368*scale3;
FingerOriginLoc_TH(2) = HandOrigin(2) - 20.160*scale3;
FingerOriginLoc_TH(3) = HandOrigin(3) - 27.376*scale3;

hold on
scatter3(FingerOriginLoc_TH(1), FingerOriginLoc_TH(2), FingerOriginLoc_TH(3), '*')
text(FingerOriginLoc_TH(1), FingerOriginLoc_TH(2), FingerOriginLoc_TH(3), 'FingerOriginLoc_TH');


FingerOrigin_TH = Origin_TH*trotz(-45*pi/180)*troty(90*pi/180);


FingerOrigin_TH(1, 4) = FingerOriginLoc_TH(1);
FingerOrigin_TH(2, 4) = FingerOriginLoc_TH(2);
FingerOrigin_TH(3, 4) = FingerOriginLoc_TH(3);

draw_coordinate(FingerOrigin_TH)
text(FingerOrigin_TH(1,4), FingerOrigin_TH(2,4),FingerOrigin_TH(3,4)+10, 'Est thumb origin');

FingerLength_TH = sqrt( (Joint7_TH(1)-FingerOriginLoc_TH(1))^2+(Joint7_TH(2)-FingerOriginLoc_TH(2))^2+(Joint7_TH(3)-FingerOriginLoc_TH(3))^2);

FingerLength_TH_default = 95.5;
L1_TH_default = 35.7; 
L2_TH_default = 31.0; 
L3_TH_default = 28.8; 

scale1 = FingerLength_TH / FingerLength_TH_default;

view(-180, 0)

 


