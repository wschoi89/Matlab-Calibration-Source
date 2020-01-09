
transform_thumb = zeros(4,4);
transform_index = zeros(4,4);

% rotation matrix from solidworks API, row-major
rot_thumb = [-0.831073087909498 -0.168555665338342 -0.530006141695472;
    -0.534952315874943 0.502936510347408 0.678882085711213;
    0.15213001772368 0.847728644226394 -0.508146242203436;];

transl_thumb = [289.585110558779, 22.6140624395133, 493.939187432284];

transform_thumb(1:3,1:3) = rot_thumb';
transform_thumb(:,4) = [transl_thumb'; 1];

% rotation matrix from solidworks API, row-major
rot_index = [-9.36683924326055E-13 -2.80351095930295E-29 -1;
-2.99301705355953E-17 1 0;
1 2.99301705355953E-17 -9.36683924326055E-13;];

transl_index = [313.937353494065, 51.6545882406963, 405.189551659303];

transform_index(1:3,1:3) = rot_index';
transform_index(:,4) = [transl_index'; 1];

    
transform_thumb_wrt_index = inv(transform_index)*transform_thumb

transform_thumb_matlabCode = eye(4,4)*transl(-88.75,-29.04,-24.35)*trotz(24*pi/180)*trotx(-75*pi/180)*troty(54*pi/180)*trotz(45*pi/180)

