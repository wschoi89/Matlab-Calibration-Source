function [F, J] = return_error_erorJacob(parameter)

    load matlab.mat

    arr_links = loadLinkLength();
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
    % to do: off_TH1, off_TH2, off_TH3, off_TH4 test 완료 후 모두 symbolic 변수로 바꾸기
%     DHRef = [0+parameter(1) 0+parameter(2)       0+parameter(3)              -pi/2+parameter(4);
%              0+parameter(5) B2+parameter(17) arr_links(1,1)+parameter(6) pi/2+parameter(7);
%              0+parameter(8) B3+parameter(18) arr_links(2,1)+parameter(9) 0+parameter(10);
%              0    -pi/2      arr_links(3,1) 0;
%              0+parameter(11) B5+parameter(19) arr_links(4,1)+parameter(12) 0+parameter(13);
%     %          0+A6 B6+off_TH4 arr_links(5,1)+C6 0+D6;
%              0+parameter(14) B6+parameter(20) arr_links(5,1)+parameter(15) 0+parameter(16);
%              0    -pi/2      arr_links(6,1) 0;];

    DHRef = [0+A1 0+B1       0+C1              -pi/2+D1;
             0+A2 B2+off_TH1 arr_links(1,1)+C2 pi/2+D2;
             0+A3 B3+off_TH2 arr_links(2,1)+C3 0+D3;
             0    -pi/2      arr_links(3,1) 0;
             0+A5 B5+off_TH3 arr_links(4,1)+C5 0+D5;
    %          0+A6 B6+off_TH4 arr_links(5,1)+C6 0+D6;
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
    for iter=1:size(data, 1)-235
%         error(iter, 1) = sqrt(sum((pos_reference(iter,:)-pos_frame7(:)').^2));
%         error(iter, 1) = subs(error(iter, 1), [B2,B3,B5,B6], [data(iter,1),data(iter,2),data(iter,3),data(iter,4)]);
        error(1, iter) = sqrt(sum((pos_reference(iter,:)-pos_frame7(:)').^2));
        error(1, iter) = subs(error(1, iter), [B2,B3,B5,B6], [data(iter,1),data(iter,2),data(iter,3),data(iter,4)]);        

    % error = sqrt(sum((pos_frame7 - pos_reference).^2));
    % error(1,1) = sqrt(((pos_frame7(1) - pos_reference(1))^2));
    % error(2,1) = sqrt(((pos_frame7(2) - pos_reference(2))^2));
    % error(3,1) = sqrt(((pos_frame7(3) - pos_reference(3))^2));

    end


%     parameter = [A1;B1;C1;D1;A2;C2;D2;A3;C3;D3;A5;C5;D5;A6;C6;D6;off_TH1;off_TH2;off_TH3;off_TH4];
    
    F=error;
    length = size(F, 2);
    num_variable = size(parameter, 2);
    if nargout >1
%        J = zeros(length, num_variable);
%         J = sym('J', [length, num_variable]);
        J = jacobian(error, test);
%        for r=1:1:length
%           for c=1:1:num_variable
%              J(r, c) = jacobian(error(r), parameter(c)); 
%           end
%        end
    end




end