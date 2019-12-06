function pos_end = calc_endPos(DHRef, arr_links, TH1, TH2, TH3, TH4, offset_TH1, offset_TH2, offset_TH3, offset_TH4)

    TH1 = TH1*pi/180;
    TH2 = TH2*pi/180;
    TH3 = TH3*pi/180;
    TH4 = TH4*pi/180;
    
    offsetTH1 = offsetTH1*pi/180;
    offsetTH2 = offsetTH2*pi/180;
    offsetTH3 = offsetTH3*pi/180;
    offsetTH4 = offsetTH4*pi/180;
    
    DHRef = [0 0             0             -pi/2;
             0 TH1+offsetTH1 arr_links(1,1) pi/2;
             0 TH2+offsetTH2 arr_links(2,1) 0;
             0 -pi/2         arr_links(3,1) 0;
             0 TH3+offsetTH3 arr_links(4,1) 0;
             0 TH4+offsetTH4 arr_links(5,1) 0;
             0 -pi/2         arr_links(6,1) 0;];
     
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
    
    pos_end = pos_frame7; 

end

