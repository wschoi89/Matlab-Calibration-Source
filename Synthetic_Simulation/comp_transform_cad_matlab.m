
%% calculate transformation matrix of Thumb origin w.r.t Index origin coordinate.

transform_thumb = zeros(4,4);
transform_index = zeros(4,4);

% rotation matrix from solidworks API, row-major
rot_thumb = [-0.844687214233004 -5.46702184259277E-02 -0.53246096319688;
    -0.5352337723626 9.61601150699119E-02 0.839212750851798;
    5.3215630963567E-03 0.993863370633511 -0.110486566962726;];

transl_thumb = [-54.9179252969987 -78.7790464130597 114.051754006815];

transform_thumb(1:3,1:3) = rot_thumb';
transform_thumb(:,4) = [transl_thumb'; 1];

% rotation matrix from solidworks API, row-major
rot_index = [-2.24451969705654E-14 0.500000000000002 -0.866025403784437;
            1.34286534719403E-14 0.866025403784437 0.500000000000002;
            1 -4.06956560035623E-16 -2.61524375054253E-14;];

transl_index = [-29.5553631585038 -8.22350590165543 52.2435300380096];

transform_index(1:3,1:3) = rot_index';
transform_index(:,4) = [transl_index'; 1];
    
transform_thumb_wrt_index = inv(transform_index)*transform_thumb

% transform_thumb_matlabCode = eye(4,4)*transl(-88.75,-29.04,-24.35)*trotz(24*pi/180)*trotx(-75*pi/180)*troty(54*pi/180)*trotz(45*pi/180)

