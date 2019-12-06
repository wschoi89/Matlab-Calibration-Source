clear
clc

% ideal 3D magnetic data(x, y, z)
alpha=0;
beta=0;
gamma=1;

halfpi = pi / 2;

% magnetic data order
T2=0; % thumb distal
T1=1; % thumb proximal
I1=2; % index proximal
I2=3; % index distal
M1=4; % middle proximal
M2=5; % middle distal

%initialize offset
offset = zeros(4, 3);
calibrationFileName = 'Simulation_Right02_191004.csv';


%load 3D magnetic data for calibration
cal_data = csvread(calibrationFileName);
cal_data_thumb_index = [cal_data(100,:);cal_data(200,:);cal_data(300,:);cal_data(400,:);];
cal_data_thumb_middle = [cal_data(500,:);cal_data(600,:);cal_data(700,:);cal_data(800,:);];
%total 8 row; 1~4:thumb&index, 5~8:thumb&middle
calibration = [cal_data_thumb_index;cal_data_thumb_middle];

%open log file for saving calibration process
log_fileID = fopen('calibration_log.csv', 'w');    

% load link length data
linkLength = loadLinkLength();


%% calibrate DH parameters

if contains(offsetFileName, 'right')
    calibrate_mocap_right(lambda, offset, calibration);
elseif contains(offsetFileName, 'left')
%     calibrate_mocap_left(lambda, offset, calibration);
else
    assert(mode ~='', 'please check the mode(right or left)');
end
    

