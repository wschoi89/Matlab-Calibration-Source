% Simulation using synthetic data
% clear
% clc
% close all
clearvars -except data
%create origin coordinate
% figure
% axis equal
% set(gca,'DataAspectRatio',[1 1 1])
% plot3([0 10],[0 0],[0 0],'r.-');
% hold on
% plot3([0 0],[0 10],[0 0],'g.-');
% hold on
% plot3([0 0],[0 0],[0 10],'b.-');
% hold on

%load link lengths for thumb, index, and middle devices
arr_links = loadLinkLength();

% axis([0 100 -100 20 -150 150]);
% view([180, -90])
% hold on

syms A1 B1 C1 D1 
syms A2    C2 D2  
syms A3    C3 D3  
% syms A4 B4 C4 D4
syms A5    C5 D5  
syms A6    C6 D6  
% syms A7 B7 C7 D7

% syms off_TH1 off_TH2 off_TH3 off_TH4 %device angle offset by sensor misalingment
syms off_TH1 off_TH2 off_TH3 off_TH4
syms B2 B3 B5 B6

% to do: off_TH1, off_TH2, off_TH3, off_TH4 test 완료 후 모두 symbolic 변수로 바꾸기
DHRef = [0+A1 0+B1       0+C1              -pi/2+D1;
         0+A2 B2+off_TH1 arr_links(1,1)+C2 pi/2+D2;
         0+A3 B3+off_TH2 arr_links(2,1)+C3 0+D3;
         0    -pi/2      arr_links(3,1) 0;
         0+A5 B5+off_TH3 arr_links(4,1)+C5 0+D5;
         0+A6 B6+off_TH4 arr_links(5,1)+C6 0+D6;
         0    -pi/2      arr_links(6,1) 0;];

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

% DH_table = [0 0     0              -pi/2;
%             0 0     arr_links(1,1)  pi/2;
%             0 0     arr_links(2,1)  0;
%             0 -pi/2 arr_links(3,1)  0;
%             0 0     arr_links(4,1)  0;
%             0 0     arr_links(5,1)  0;
%             0 -pi/2 arr_links(6,1)  0;];

Origin = eye(4);

%offset 각도 있을 때의 reference position

pos_reference = data(:, 12:14);


%transformation matrix using DH paramter table
% R01=transform_DH(DH_table, 1, 0);
% R12=transform_DH(DH_table, 2, 1);
% R23=transform_DH(DH_table, 3, 2);
% R34=transform_DH(DH_table, 4, 3);
% R45=transform_DH(DH_table, 5, 4);
% R56=transform_DH(DH_table, 6, 5);
% R67=transform_DH(DH_table, 7, 6);
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

% off_TH1 = 0;off_TH2 = 0;



pos_frame1 = subs(pos_frame1);
pos_frame2 = subs(pos_frame2);
pos_frame3 = subs(pos_frame3);
pos_frame4 = subs(pos_frame4);
pos_frame5 = subs(pos_frame5);
pos_frame6 = subs(pos_frame6);
pos_frame7 = subs(pos_frame7);

% plot3([pos_frame1(1) pos_frame2(1)],[pos_frame1(2) pos_frame2(2)],[pos_frame1(3) pos_frame2(3)],'r.-');
% hold on
% plot3([pos_frame2(1) pos_frame3(1)],[pos_frame2(2) pos_frame3(2)],[pos_frame2(3) pos_frame3(3)],'b.-');
% hold on
% plot3([pos_frame3(1) pos_frame4(1)],[pos_frame3(2) pos_frame4(2)],[pos_frame3(3) pos_frame4(3)],'r.-');
% hold on
% plot3([pos_frame4(1) pos_frame5(1)],[pos_frame4(2) pos_frame5(2)],[pos_frame4(3) pos_frame5(3)],'b.-');
% hold on
% plot3([pos_frame5(1) pos_frame6(1)],[pos_frame5(2) pos_frame6(2)],[pos_frame5(3) pos_frame6(3)],'r.-');
% hold on
% plot3([pos_frame6(1) pos_frame7(1)],[pos_frame6(2) pos_frame7(2)],[pos_frame6(3) pos_frame7(3)],'b.-');
% hold on

%iterate for the number of row
for iter=1:size(data, 1)
    error(iter, 1) = sqrt(sum((pos_reference(iter,:)-pos_frame7(:)').^2));
    error(iter, 1) = subs(error(iter, 1), [B2,B3,B5,B6], [data(iter,1),data(iter,2),data(iter,3),data(iter,4)]);
% error = sqrt(sum((pos_frame7 - pos_reference).^2));
% error(1,1) = sqrt(((pos_frame7(1) - pos_reference(1))^2));
% error(2,1) = sqrt(((pos_frame7(2) - pos_reference(2))^2));
% error(3,1) = sqrt(((pos_frame7(3) - pos_reference(3))^2));

end
disp('start')
parameter = [A1;B1;C1;D1;A2;C2;D2;A3;C3;D3;A5;C5;D5;A6;C6;D6;off_TH1;off_TH2;off_TH3;off_TH4];

fh = matlabFunction(error,'vars',{parameter});

A1=0;B1=0;C1=0;D1=0;
A2=0;     C2=0;D2=0;
A3=0;     C3=0;D3=0;
A5=0;     C5=0;D5=0;
A6=0;     C6=0;D6=0;


off_TH1=0;
off_TH2=0;
off_TH3=0;
off_TH4=0;
 
% options = optimoptions(@lsqnonlin,'Algorithm','trust-region-reflective', 'Display', 'iter', 'MaxFunctionEvaluations', 500000, 'MaxIterations', 40000, ...
%     'FunctionTolerance', 1.0000e-200000, 'StepTolerance', 1.0000e-10000, 'OptimalityTolerance', 1.0e-1000);
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt', 'Display', 'iter', 'MaxFunctionEvaluations', 4000000, 'MaxIterations', 4000000, 'PlotFcn', 'optimplotx');
lb = [-4;-0.4;-4;-0.4;
    -4;-4;-0.4;
    -4;-4;-0.4;
    -4;-4;-0.4;
%     -4;-4;-0.4;
    -0.4;-0.4;-0.4;-0.4];
ub = [4;0.4;4;0.4;
    4;4;0.4;
    4;4;0.4;
    4;4;0.4;
%     4;4;0.4;
    0.4;0.4;0.4;0.4];
% output = lsqnonlin(fh,[A1;B1;C1;D1;A2;C2;D2;A3;C3;D3;A4;off_TH1;off_TH2;off_TH3;off_TH4;], lb, ub, options);    
output = lsqnonlin(fh,[A1;B1;C1;D1;A2;C2;D2;A3;C3;D3;A5;C5;D5;A6;C6;D6;off_TH1;off_TH2;off_TH3;off_TH4;],[],[], options);    

% output = [output(1) output(2) output(3) output(4);
%           output(5)           output(6) output(7);
%           output(8)           output(9) output(10);
%           
%           output(11)          output(12) output(13);
%           output(14)          output(15) output(16);
%           output(17) output(18) output(19) output(20);];
      



% 
% off_TH1 = output(1);off_TH2 = output(2); off_TH3 = output(3);
% 
% pos_frame1 = subs(pos_frame1);
% pos_frame2 = subs(pos_frame2);
% pos_frame3 = subs(pos_frame3);
% pos_frame4 = subs(pos_frame4);
% pos_frame5 = subs(pos_frame5);
% pos_frame6 = subs(pos_frame6);
% pos_frame7 = subs(pos_frame7);
% 
% 
% plot3([pos_frame1(1) pos_frame2(1)],[pos_frame1(2) pos_frame2(2)],[pos_frame1(3) pos_frame2(3)],'black.-');
% hold on
% plot3([pos_frame2(1) pos_frame3(1)],[pos_frame2(2) pos_frame3(2)],[pos_frame2(3) pos_frame3(3)],'black.-');
% hold on
% plot3([pos_frame3(1) pos_frame4(1)],[pos_frame3(2) pos_frame4(2)],[pos_frame3(3) pos_frame4(3)],'black.-');
% hold on
% plot3([pos_frame4(1) pos_frame5(1)],[pos_frame4(2) pos_frame5(2)],[pos_frame4(3) pos_frame5(3)],'black.-');
% hold on
% plot3([pos_frame5(1) pos_frame6(1)],[pos_frame5(2) pos_frame6(2)],[pos_frame5(3) pos_frame6(3)],'black.-');
% hold on
% plot3([pos_frame6(1) pos_frame7(1)],[pos_frame6(2) pos_frame7(2)],[pos_frame6(3) pos_frame7(3)],'black.-');
