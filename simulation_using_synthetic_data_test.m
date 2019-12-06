% Simulation using synthetic data
clear
clc
% close all

load matlab.mat
clearvars -except data
    
arr_links = loadLinkLength();
length_data = size(data, 1)-238;
syms A1 real
syms B1 real
syms C1 real
syms D1 real

syms A2 real
syms C2 real
syms D2 real

syms A3 real
syms C3 real
syms D3 real
% syms A4 B4 C4 D4
syms A5 real
syms C5 real
syms D5 real

syms A6 real
syms C6 real
syms D6 real
% syms A7 B7 C7 D7
% 
% 
syms off_TH1 real
syms off_TH2 real
syms off_TH3 real
syms off_TH4 real % device angle offset by sensor misalingment

syms B2 real
syms B3 real
syms B5 real
syms B6 real % joint angle 

parameter = [A1;B1;C1;D1;A2;C2;D2;A3;C3;D3;A5;C5;D5;A6;C6;D6;off_TH1;off_TH2;off_TH3;off_TH4];
num_variable = size(parameter, 1);
% parameter = [A1,B1,C1,D1,A2,C2,D2,A3,C3,D3,A5,C5,D5,A6,C6,D6,off_TH1,off_TH2,off_TH3,off_TH4];
 DHRef = [0+A1 0+B1       0+C1              -pi/2+D1;
         0+A2 B2+off_TH1 arr_links(1,1)+C2 pi/2+D2;
         0+A3 B3+off_TH2 arr_links(2,1)+C3 0+D3;
         0    -pi/2      arr_links(3,1) 0;
         0+A5 B5+off_TH3 arr_links(4,1)+C5 0+D5;
%          0+A6 B6+off_TH4 arr_links(5,1)+C6 0+D6;
         0+A6 B6+off_TH4 arr_links(5,1)+C6 0+D6;
         0    -pi/2      arr_links(6,1) 0;];

 Origin = eye(4);

%offset 각도 있을 때의 reference position
pos_reference = data(:, 12:14);
    
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
    % error = zeros(size(data,1), 1);
    % for iter=1:round(size(data, 1)/2)
    error = sym(0);
    for iter=1:length_data
        error = error + sum((pos_reference(iter,:)-pos_frame7(:)').^2);
        error = subs(error, [B2,B3,B5,B6], [data(iter,1),data(iter,2),data(iter,3),data(iter,4)]);
        

    % error = sqrt(sum((pos_frame7 - pos_reference).^2));
    % error(1,1) = sqrt(((pos_frame7(1) - pos_reference(1))^2));
    % error(2,1) = sqrt(((pos_frame7(2) - pos_reference(2))^2));
    % error(3,1) = sqrt(((pos_frame7(3) - pos_reference(3))^2));

    end
% error = error';
disp("jacobian preallocation")
% pre-allocate jacobian symbolic matrix
J = sym('J', [num_variable, 1]);
% for r=1:1:length_data
  for c=1:1:num_variable
     J(c, 1) = jacobian(error, parameter(c)); 
  end
%  end


% gradError = jacobian(error, parameter);
% [F, J]=return_error_errorJacob(parameter);
disp('call matlabFunction')
% fh = matlabFunction(error,J,'vars',{parameter});
fh = matlabFunction(error,J,'vars',{parameter});

% opts = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'final', 'SpecifyObjectiveGradient',true);
% opts = optimoptions(@lsqnonlin,'Display', 'final', 'SpecifyObjectiveGradient',true);
opts = optimoptions(@lsqnonlin,'Display', 'iter','MaxFunctionEvaluations',2.000000e+10, 'SpecifyObjectiveGradient',true);
A1=0;B1=0;C1=0;D1=0;
A2=0;     C2=0;D2=0;
A3=0;     C3=0;D3=0;
A5=0;     C5=0;D5=0;
A6=0;     C6=0;D6=0;

off_TH1=0;
off_TH2=0;
off_TH3=0;
off_TH4=0;
% initial = zeros(1,20);
% remove workspace
clearvars data pos_reference 


disp('start nonlinear  least square optimization')
% [a, b] = lsqnonlin(fh,[A1;B1;C1;D1;A2;C2;D2;A3;C3;D3;A5;C5;D5;A6;C6;D6;off_TH1;off_TH2;off_TH3;off_TH4;], [], [], opts);
[x, fval] = fminunc(fh, [A1;B1;C1;D1;A2;C2;D2;A3;C3;D3;A5;C5;D5;A6;C6;D6;off_TH1;off_TH2;off_TH3;off_TH4;], opts);
% [x,resnorm,res,eflag,output2] = lsqnonlin(@return_error_errorJacob,,[],[] ,opts);