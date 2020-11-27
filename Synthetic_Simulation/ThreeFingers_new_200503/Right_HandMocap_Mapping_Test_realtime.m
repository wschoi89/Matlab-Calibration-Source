%% clear workspace and close all figures

clear
clc
close all
disp('Start in 5 seconds!')

num_DHjoints = 7; % the joint number in DH table
num_param_per_joint = 4; % DH parameter per joint
num_fingers = 3; % the number of device fingers
num_angles = 4; % device angle

flag_init=0;

COM_PORT='COM9';
%load optimized DH parameters
DH_json = jsondecode(fileread('mech-R6.json'));
DHoffset = reshape(DH_json.DH_offset, 32, 3)';
%load device angle offset
%thumb
off_TH1_TH = DH_json.off_TH1_Thumb;
off_TH2_TH = DH_json.off_TH2_Thumb;
off_TH3_TH = DH_json.off_TH3_Thumb;
off_TH4_TH = DH_json.off_TH4_Thumb;

off_ext_thumb = [off_TH1_TH,off_TH2_TH,off_TH3_TH,off_TH4_TH]; 

%index
off_TH1 = DH_json.off_TH1_Index;
off_TH2 = DH_json.off_TH2_Index;
off_TH3 = DH_json.off_TH3_Index;
off_TH4 = DH_json.off_TH4_Index;

off_ext_index = [off_TH1,off_TH2,off_TH3,off_TH4]; 

%middle
off_TH1_MI = DH_json.off_TH1_Middle;
off_TH2_MI = DH_json.off_TH2_Middle;
off_TH3_MI = DH_json.off_TH3_Middle;
off_TH4_MI = DH_json.off_TH4_Middle;

off_ext_middle = [off_TH1_MI,off_TH2_MI,off_TH3_MI,off_TH4_MI]; 

%close existing memory of port object
if ~isempty(instrfind)
     fclose(instrfind);
      delete(instrfind);
end

%open serial port
ser = serial(COM_PORT);
ser.Baudrate = 115200;

load('mat_files/pos_calibration_integrated.mat');

%thumb, index, middle finger number (right)
T1=1;
T2=0;
I1=2;
I2=3;
M1=4;
M2=5;

%load link lengths for thumb, index, and middle devices
arr_links = loadLinkLength();


%% connect serial port 

%data length, prefix, postfix
length_protocol = 46;
hex_prefix = 64;
hex_postfix = 255;


% 5초 정도 시간 소요됨 
fopen(ser);

%assign the size of data
data = zeros(length_protocol, 1);
   
while(true)
    % read first byte 
    [first_byte, num_read] = fread(ser, 1);    
   
    %check the USB connection status
    if num_read == 0
        error("please check the USB connection or power ")
        exit
    end
    
    % check first byte
    if first_byte == hex_prefix
        remain_byte = fread(ser, length_protocol - 1);

        % check last byte
        if remain_byte(end) == hex_postfix
            data = [first_byte;remain_byte];
            break;
        end
    end
end



%parsing sensor data (6sensors, 7bytes for each sensor)
%           왼손        오른손
% sensor 1: 중지 말단   엄지 말단
% sensor 2: 중지 손등   엄지 손등
% sensor 3: 검지 손등   검지 손등
% sensor 4: 검지 말단   검지 말단
% sensor 5: 엄지 손등   중지 손등
% sensor 6: 엄지 말단   중지 말단

sensor1 = data(4:10);
sensor2 = data(11:17);
sensor3 = data(18:24);
sensor4 = data(25:31);
sensor5 = data(32:38);
sensor6 = data(39:45);
sensor_data = {sensor1, sensor2, sensor3, sensor4, sensor5, sensor6};

bx = cell(1, 6);
by = cell(1, 6);
bz = cell(1, 6);


[bx{1}, by{1}, bz{1}] = getMagneticValue(sensor1);
[bx{2}, by{2}, bz{2}] = getMagneticValue(sensor2);
[bx{3}, by{3}, bz{3}] = getMagneticValue(sensor3);
[bx{4}, by{4}, bz{4}] = getMagneticValue(sensor4);
[bx{5}, by{5}, bz{5}] = getMagneticValue(sensor5);
[bx{6}, by{6}, bz{6}] = getMagneticValue(sensor6);

magneticValue = zeros(1, 18);
for i=1:6
    magneticValue(1, 3*(i-1)+1) = bx{i};
    magneticValue(1, 3*(i-1)+2) = by{i};
    magneticValue(1, 3*(i-1)+3) = bz{i};
end



figure;
axis([-250 250 -150 150 -150 150]);
view([172, -44])
hold on
% axis('equal')

Origin=eye(4);%% initial values
load('mat_files/transform_thumb_wrt_index.mat');
Origin_TH=Origin*transform_thumb_wrt_index;%% initial values

Origin_MI=Origin*transl(0,0,19);%% initial values

DH_ref = [0 0      0   -pi/2;
          0 0      0   pi/2;
          0 0      0   0;
          0 -pi/2  0   0;
          0 0      0   0;
          0 0      0   0;
          0 -pi/2  0   0;];
      
DH_table = zeros(num_DHjoints, num_param_per_joint, num_fingers);

% plot Origin 
Link1_1=Origin*transl(-37,0,-15);
Link1_2=Origin*transl(-37,0,15);
plot3([Origin(1,4) Link1_1(1,4)],[Origin(2,4) Link1_1(2,4)],[Origin(3,4) Link1_1(3,4)],'black-');
plot3([Link1_2(1,4) Link1_1(1,4)],[Link1_2(2,4) Link1_1(2,4)],[Link1_2(3,4) Link1_1(3,4)],'black-');
plot3([Origin(1,4) Link1_2(1,4)],[Origin(2,4) Link1_2(2,4)],[Origin(3,4) Link1_2(3,4)],'black-');
Link2_1=Origin_TH*transl(-37,0,-15);
Link2_2=Origin_TH*transl(-37,0,15);
plot3([Origin_TH(1,4) Link2_1(1,4)],[Origin_TH(2,4) Link2_1(2,4)],[Origin_TH(3,4) Link2_1(3,4)],'black-');
plot3([Link2_2(1,4) Link2_1(1,4)],[Link2_2(2,4) Link2_1(2,4)],[Link2_2(3,4) Link2_1(3,4)],'black-');
plot3([Origin_TH(1,4) Link2_2(1,4)],[Origin_TH(2,4) Link2_2(2,4)],[Origin_TH(3,4) Link2_2(3,4)],'black-');
Link3_1=Origin_MI*transl(-37,0,-15);
Link3_2=Origin_MI*transl(-37,0,15);
plot3([Origin_MI(1,4) Link3_1(1,4)],[Origin_MI(2,4) Link3_1(2,4)],[Origin_MI(3,4) Link3_1(3,4)],'black-');
plot3([Link3_2(1,4) Link3_1(1,4)],[Link3_2(2,4) Link3_1(2,4)],[Link3_2(3,4) Link3_1(3,4)],'black-');
plot3([Origin_MI(1,4) Link3_2(1,4)],[Origin_MI(2,4) Link3_2(2,4)],[Origin_MI(3,4) Link3_2(3,4)],'black-');

alpha=0;
beta=0;
gamma=1;

%% Mechanism & Finger Drawing
while(true)
    
    %read first byte and check whether it is same with the prefix byte
    first_byte = fread(ser, 1);    
    %check first byte
    if first_byte == hex_prefix
        remain_byte = fread(ser, length_protocol - 1);

        %check last byte
        if remain_byte(end) == hex_postfix
            data = [first_byte;remain_byte];
        end
    else
        continue;
    end
 

    %parsing sensor data (6sensors, 7bytes for each sensor)
    % 왼손
    % sensor 1: 중지 말단
    % sensor 2: 중지 손등
    % sensor 3: 검지 손등
    % sensor 4: 검지 말단
    % sensor 5: 엄지 손등
    % sensor 6: 엄지 말단 

    % 오른손
    % sensor 1: 엄지 말단
    % sensor 2: 엄지 손등
    % sensor 3: 검지 손등
    % sensor 4: 검지 말단
    % sensor 5: 중지 손등
    % sensor 6: 중지 말단 
    
    sensor1 = data(4:10);
    sensor2 = data(11:17);
    sensor3 = data(18:24);
    sensor4 = data(25:31);
    sensor5 = data(32:38);
    sensor6 = data(39:45);
    sensor_data = {sensor1, sensor2, sensor3, sensor4, sensor5, sensor6};

    bx = cell(1, 6);
    by = cell(1, 6);
    bz = cell(1, 6);

    [bx{1}, by{1}, bz{1}] = getMagneticValue(sensor1);
    [bx{2}, by{2}, bz{2}] = getMagneticValue(sensor2);
    [bx{3}, by{3}, bz{3}] = getMagneticValue(sensor3);
    [bx{4}, by{4}, bz{4}] = getMagneticValue(sensor4);
    [bx{5}, by{5}, bz{5}] = getMagneticValue(sensor5);
    [bx{6}, by{6}, bz{6}] = getMagneticValue(sensor6);

    % magneticValue=csvread('Simulation_Right02_191004.csv');
    magneticValue = zeros(1, 18);
    for i=1:6
        magneticValue(1, 3*(i-1)+1) = bx{i};
        magneticValue(1, 3*(i-1)+2) = by{i};
        magneticValue(1, 3*(i-1)+3) = bz{i};
    end

   % jointAngles array includes thumb, index, and middle device angles
   
   jointAngles = getJointAngle_updated(magneticValue, DHoffset(1,17:32),DHoffset(2,17:32), DHoffset(3,17:32),off_ext_thumb,off_ext_index, off_ext_middle );
    
   
   %% thumb 
   TH1_TH=jointAngles(1);
   TH2_TH=jointAngles(2);
   TH3_TH=jointAngles(3);
   TH4_TH=jointAngles(4);

   if flag_init == 0 
       DH_TH = DH_ref;
       DH_TH(2:end, 3) = arr_links(:, 1);

       % DH parameters
       DH_TH(1,1)=DH_TH(1,1)+DHoffset(1,1);                DH_TH(1,3)=DH_TH(1,3)+DHoffset(1,2);
       DH_TH(2,1)=DH_TH(2,1)+DHoffset(1,3);                DH_TH(2,3)=DH_TH(2,3)+DHoffset(1,4);
       DH_TH(3,1)=DH_TH(3,1)+DHoffset(1,5);                DH_TH(3,3)=DH_TH(3,3)+DHoffset(1,6);
       DH_TH(5,1)=DH_TH(5,1)+DHoffset(1,7);                DH_TH(5,3)=DH_TH(5,3)+DHoffset(1,8);
       DH_TH(6,1)=DH_TH(6,1)+DHoffset(1,9);                DH_TH(6,3)=DH_TH(6,3)+DHoffset(1,10);

       DH_TH(1,2)=DH_TH(1,2)+DHoffset(1,11);               DH_TH(1,4)=DH_TH(1,4)+DHoffset(1,12);
                                                           DH_TH(2,4)=DH_TH(2,4)+DHoffset(1,13);
                                                           DH_TH(3,4)=DH_TH(3,4)+DHoffset(1,14);
                                                           DH_TH(5,4)=DH_TH(5,4)+DHoffset(1,15);
                                                           DH_TH(6,4)=DH_TH(6,4)+DHoffset(1,16);
   end
                                                       
    DH_TH(2,2) = TH1_TH;
    DH_TH(3,2) = TH2_TH;
    DH_TH(5,2) = TH3_TH;
    DH_TH(6,2) = TH4_TH;                                                   

    R01_TH=transl(0,0,DH_TH(1,1))*trotz(DH_TH(1,2))*transl(DH_TH(1,3),0,0)*trotx(DH_TH(1,4));
    R12_TH=transl(0,0,DH_TH(2,1))*trotz(DH_TH(2,2))*transl(DH_TH(2,3),0,0)*trotx(DH_TH(2,4));
    R23_TH=transl(0,0,DH_TH(3,1))*trotz(DH_TH(3,2))*transl(DH_TH(3,3),0,0)*trotx(DH_TH(3,4));
    R34_TH=transl(0,0,DH_TH(4,1))*trotz(DH_TH(4,2))*transl(DH_TH(4,3),0,0)*trotx(DH_TH(4,4));
    R45_TH=transl(0,0,DH_TH(5,1))*trotz(DH_TH(5,2))*transl(DH_TH(5,3),0,0)*trotx(DH_TH(5,4));
    R56_TH=transl(0,0,DH_TH(6,1))*trotz(DH_TH(6,2))*transl(DH_TH(6,3),0,0)*trotx(DH_TH(6,4));
    R67_TH=transl(0,0,DH_TH(7,1))*trotz(DH_TH(7,2))*transl(DH_TH(7,3),0,0)*trotx(DH_TH(7,4));

    R78_TH=transl(0,0,6)*trotz(pi/2)*transl(4,0,0);


    R1_TH=Origin_TH*R01_TH*R12_TH;
    Joint1_TH=[R1_TH(1,4); R1_TH(2,4); R1_TH(3,4)];
    R2_TH=R1_TH*R23_TH;
    Joint2_TH=[R2_TH(1,4); R2_TH(2,4); R2_TH(3,4)];
    R3_TH=R2_TH*R34_TH;
    Joint3_TH=[R3_TH(1,4); R3_TH(2,4); R3_TH(3,4)];
    R4_TH=R3_TH*R45_TH;
    Joint4_TH=[R4_TH(1,4); R4_TH(2,4); R4_TH(3,4)];
    R5_TH=R4_TH*R56_TH;
    Joint5_TH=[R5_TH(1,4); R5_TH(2,4); R5_TH(3,4)];
    R6_TH=R5_TH*R67_TH;
    Joint6_TH=[R6_TH(1,4); R6_TH(2,4); R6_TH(3,4)];
    R7_TH=R6_TH*R78_TH;
    Joint7_TH=[R7_TH(1,4); R7_TH(2,4); R7_TH(3,4)];

    if flag_init == 0 

        pp8=plot3([Origin_TH(1,4) Joint1_TH(1)],[Origin_TH(2,4) Joint1_TH(2)],[Origin_TH(3,4) Joint1_TH(3)],'r.-');
        pp8.XDataSource = '[Origin_TH(1,4) Joint1_TH(1)]';
        pp8.YDataSource = '[Origin_TH(2,4) Joint1_TH(2)]';
        pp8.ZDataSource = '[Origin_TH(3,4) Joint1_TH(3)]';

        pp9=plot3([Joint1_TH(1) Joint2_TH(1)],[Joint1_TH(2) Joint2_TH(2)],[Joint1_TH(3) Joint2_TH(3)],'r.-');
        pp10=plot3([Joint2_TH(1) Joint3_TH(1)],[Joint2_TH(2) Joint3_TH(2)],[Joint2_TH(3) Joint3_TH(3)],'r.-');
        pp11=plot3([Joint3_TH(1) Joint4_TH(1)],[Joint3_TH(2) Joint4_TH(2)],[Joint3_TH(3) Joint4_TH(3)],'r.-');
        pp12=plot3([Joint4_TH(1) Joint5_TH(1)],[Joint4_TH(2) Joint5_TH(2)],[Joint4_TH(3) Joint5_TH(3)],'r.-');
        pp13=plot3([Joint5_TH(1) Joint6_TH(1)],[Joint5_TH(2) Joint6_TH(2)],[Joint5_TH(3) Joint6_TH(3)],'r.-');
        pp14=plot3([Joint6_TH(1) Joint7_TH(1)],[Joint6_TH(2) Joint7_TH(2)],[Joint6_TH(3) Joint7_TH(3)],'r.-');

    end
    
    set(pp8, 'XData', [Origin_TH(1,4) Joint1_TH(1)]);set(pp8, 'YData', [Origin_TH(2,4) Joint1_TH(2)]);set(pp8, 'ZData', [Origin_TH(3,4) Joint1_TH(3)]);
    set(pp9, 'XData', [Joint1_TH(1) Joint2_TH(1)]);set(pp9, 'YData', [Joint1_TH(2) Joint2_TH(2)]);set(pp9, 'ZData', [Joint1_TH(3) Joint2_TH(3)]);
    set(pp10, 'XData', [Joint2_TH(1) Joint3_TH(1)]);set(pp10, 'YData', [Joint2_TH(2) Joint3_TH(2)]);set(pp10, 'ZData', [Joint2_TH(3) Joint3_TH(3)]);
    set(pp11, 'XData', [Joint3_TH(1) Joint4_TH(1)]);set(pp11, 'YData', [Joint3_TH(2) Joint4_TH(2)]);set(pp11, 'ZData', [Joint3_TH(3) Joint4_TH(3)]);
    set(pp12, 'XData', [Joint4_TH(1) Joint5_TH(1)]);set(pp12, 'YData', [Joint4_TH(2) Joint5_TH(2)]);set(pp12, 'ZData', [Joint4_TH(3) Joint5_TH(3)]);
    set(pp13, 'XData', [Joint5_TH(1) Joint6_TH(1)]);set(pp13, 'YData', [Joint5_TH(2) Joint6_TH(2)]);set(pp13, 'ZData', [Joint5_TH(3) Joint6_TH(3)]);
    set(pp14, 'XData', [Joint6_TH(1) Joint7_TH(1)]);set(pp14, 'YData', [Joint6_TH(2) Joint7_TH(2)]);set(pp14, 'ZData', [Joint6_TH(3) Joint7_TH(3)]);


%% index
    TH1 = jointAngles(5);
    TH2 = jointAngles(6);
    TH3 = jointAngles(7);
    TH4 = jointAngles(8);

    if flag_init ==0 
        DH = DH_ref;
        DH(2:end, 3) = arr_links(:, 2);

        % DH parameters
        DH(1,1)=DH(1,1)+DHoffset(2,1);                DH(1,3)=DH(1,3)+DHoffset(2,2);
        DH(2,1)=DH(2,1)+DHoffset(2,3);                DH(2,3)=DH(2,3)+DHoffset(2,4);
        DH(3,1)=DH(3,1)+DHoffset(2,5);                DH(3,3)=DH(3,3)+DHoffset(2,6);
        DH(5,1)=DH(5,1)+DHoffset(2,7);                DH(5,3)=DH(5,3)+DHoffset(2,8);
        DH(6,1)=DH(6,1)+DHoffset(2,9);                DH(6,3)=DH(6,3)+DHoffset(2,10);

        DH(1,2)=DH(1,2)+DHoffset(2,11);               DH(1,4)=DH(1,4)+DHoffset(2,12);
                                                      DH(2,4)=DH(2,4)+DHoffset(2,13);
                                                      DH(3,4)=DH(3,4)+DHoffset(2,14);
                                                      DH(5,4)=DH(5,4)+DHoffset(2,15);
                                                      DH(6,4)=DH(6,4)+DHoffset(2,16);
        
    end

    DH(2,2) = TH1;
    DH(3,2) = TH2;
    DH(5,2) = TH3;
    DH(6,2) = TH4;


    R01=transl(0,0,DH(1,1))*trotz(DH(1,2))*transl(DH(1,3),0,0)*trotx(DH(1,4));
    R12=transl(0,0,DH(2,1))*trotz(DH(2,2))*transl(DH(2,3),0,0)*trotx(DH(2,4));
    R23=transl(0,0,DH(3,1))*trotz(DH(3,2))*transl(DH(3,3),0,0)*trotx(DH(3,4));
    R34=transl(0,0,DH(4,1))*trotz(DH(4,2))*transl(DH(4,3),0,0)*trotx(DH(4,4));
    R45=transl(0,0,DH(5,1))*trotz(DH(5,2))*transl(DH(5,3),0,0)*trotx(DH(5,4));
    R56=transl(0,0,DH(6,1))*trotz(DH(6,2))*transl(DH(6,3),0,0)*trotx(DH(6,4));
    R67=transl(0,0,DH(7,1))*trotz(DH(7,2))*transl(DH(7,3),0,0)*trotx(DH(7,4));
    R78=transl(0,0,-6)*trotz(pi/2)*transl(4,0,0);

    R1=Origin*R01*R12;
    Joint1=[R1(1,4); R1(2,4); R1(3,4)];
    R2=R1*R23;
    Joint2=[R2(1,4); R2(2,4); R2(3,4)];
    R3=R2*R34;
    Joint3=[R3(1,4); R3(2,4); R3(3,4)];
    R4=R3*R45;
    Joint4=[R4(1,4); R4(2,4); R4(3,4)];
    R5=R4*R56;
    Joint5=[R5(1,4); R5(2,4); R5(3,4)];
    R6=R5*R67;
    Joint6=[R6(1,4); R6(2,4); R6(3,4)];
    R7=R6*R78;
    Joint7=[R7(1,4); R7(2,4); R7(3,4)];

    if flag_init == 0
        pp1=plot3([Origin(1,4) Joint1(1)],[Origin(2,4) Joint1(2)],[Origin(3,4) Joint1(3)],'g.-');
        pp1.XDataSource = '[Origin(1, 4) Joint1(1)]';
        pp1.YDataSource = '[Origin(2, 4) Joint1(2)]';
        pp1.ZDataSource = '[Origin(3, 4) Joint1(3)]';

        pp2=plot3([Joint1(1) Joint2(1)],[Joint1(2) Joint2(2)],[Joint1(3) Joint2(3)],'g.-');
        pp3=plot3([Joint2(1) Joint3(1)],[Joint2(2) Joint3(2)],[Joint2(3) Joint3(3)],'g.-');
        pp4=plot3([Joint3(1) Joint4(1)],[Joint3(2) Joint4(2)],[Joint3(3) Joint4(3)],'g.-');
        pp5=plot3([Joint4(1) Joint5(1)],[Joint4(2) Joint5(2)],[Joint4(3) Joint5(3)],'g.-');
        pp6=plot3([Joint5(1) Joint6(1)],[Joint5(2) Joint6(2)],[Joint5(3) Joint6(3)],'g.-');
        pp7=plot3([Joint6(1) Joint7(1)],[Joint6(2) Joint7(2)],[Joint6(3) Joint7(3)],'g.-');

    end

    set(pp1, 'XData', [Origin(1, 4) Joint1(1)]);set(pp1, 'YData', [Origin(2, 4) Joint1(2)]);set(pp1, 'ZData', [Origin(3, 4) Joint1(3)]);
    set(pp2, 'XData', [Joint1(1) Joint2(1)]);   set(pp2, 'YData', [Joint1(2) Joint2(2)]);   set(pp2, 'ZData', [Joint1(3) Joint2(3)]);
    set(pp3, 'XData', [Joint2(1) Joint3(1)]);   set(pp3, 'YData', [Joint2(2) Joint3(2)]);   set(pp3, 'ZData', [Joint2(3) Joint3(3)]);
    set(pp4, 'XData', [Joint3(1) Joint4(1)]);   set(pp4, 'YData', [Joint3(2) Joint4(2)]);   set(pp4, 'ZData', [Joint3(3) Joint4(3)]);
    set(pp5, 'XData', [Joint4(1) Joint5(1)]);   set(pp5, 'YData', [Joint4(2) Joint5(2)]);   set(pp5, 'ZData', [Joint4(3) Joint5(3)]);
    set(pp6, 'XData', [Joint5(1) Joint6(1)]);   set(pp6, 'YData', [Joint5(2) Joint6(2)]);   set(pp6, 'ZData', [Joint5(3) Joint6(3)]);
    set(pp7, 'XData', [Joint6(1) Joint7(1)]);   set(pp7, 'YData', [Joint6(2) Joint7(2)]);   set(pp7, 'ZData', [Joint6(3) Joint7(3)]);



%% Middle
    
    TH1_MI=jointAngles(9);
    TH2_MI=jointAngles(10);
    TH3_MI=jointAngles(11);
    TH4_MI=jointAngles(12);
    
    % initialize time-invariant paramters
    if flag_init == 0
       DH_MI = DH_ref;
        DH_MI(2:end, 3) = arr_links(:, 3);


        % DH parameters
        DH_MI(1,1)=DH_MI(1,1)+DHoffset(3,1);                DH_MI(1,3)=DH_MI(1,3)+DHoffset(3,2);
        DH_MI(2,1)=DH_MI(2,1)+DHoffset(3,3);                DH_MI(2,3)=DH_MI(2,3)+DHoffset(3,4);
        DH_MI(3,1)=DH_MI(3,1)+DHoffset(3,5);                DH_MI(3,3)=DH_MI(3,3)+DHoffset(3,6);
        DH_MI(5,1)=DH_MI(5,1)+DHoffset(3,7);                DH_MI(5,3)=DH_MI(5,3)+DHoffset(3,8);
        DH_MI(6,1)=DH_MI(6,1)+DHoffset(3,9);               DH_MI(6,3)=DH_MI(6,3)+DHoffset(3,10);

        DH_MI(1,2)=DH_MI(1,2)+DHoffset(3,11);             DH_MI(1,4)=DH_MI(1,4)+DHoffset(3,12);
                                                          DH_MI(2,4)=DH_MI(2,4)+DHoffset(3,13);
                                                          DH_MI(3,4)=DH_MI(3,4)+DHoffset(3,14);
                                                          DH_MI(5,4)=DH_MI(5,4)+DHoffset(3,15);
                                                          DH_MI(6,4)=DH_MI(6,4)+DHoffset(3,16); 
    end
    
    DH_MI(2,2) = TH1_MI;
    DH_MI(3,2) = TH2_MI;
    DH_MI(5,2) = TH3_MI;
    DH_MI(6,2) = TH4_MI;

    R01_MI=transl(0,0,DH_MI(1,1))*trotz(DH_MI(1,2))*transl(DH_MI(1,3),0,0)*trotx(DH_MI(1,4));
    R12_MI=transl(0,0,DH_MI(2,1))*trotz(DH_MI(2,2))*transl(DH_MI(2,3),0,0)*trotx(DH_MI(2,4));
    R23_MI=transl(0,0,DH_MI(3,1))*trotz(DH_MI(3,2))*transl(DH_MI(3,3),0,0)*trotx(DH_MI(3,4));
    R34_MI=transl(0,0,DH_MI(4,1))*trotz(DH_MI(4,2))*transl(DH_MI(4,3),0,0)*trotx(DH_MI(4,4));
    R45_MI=transl(0,0,DH_MI(5,1))*trotz(DH_MI(5,2))*transl(DH_MI(5,3),0,0)*trotx(DH_MI(5,4));
    R56_MI=transl(0,0,DH_MI(6,1))*trotz(DH_MI(6,2))*transl(DH_MI(6,3),0,0)*trotx(DH_MI(6,4));
    R67_MI=transl(0,0,DH_MI(7,1))*trotz(DH_MI(7,2))*transl(DH_MI(7,3),0,0)*trotx(DH_MI(7,4));
    R78_MI=transl(0,0,-6)*trotz(pi/2)*transl(4,0,0);

    R1_MI=Origin_MI*R01_MI*R12_MI;
    Joint1_MI=[R1_MI(1,4); R1_MI(2,4); R1_MI(3,4)];
    R2_MI=R1_MI*R23_MI;
    Joint2_MI=[R2_MI(1,4); R2_MI(2,4); R2_MI(3,4)];
    R3_MI=R2_MI*R34_MI;
    Joint3_MI=[R3_MI(1,4); R3_MI(2,4); R3_MI(3,4)];
    R4_MI=R3_MI*R45_MI;
    Joint4_MI=[R4_MI(1,4); R4_MI(2,4); R4_MI(3,4)];
    R5_MI=R4_MI*R56_MI;
    Joint5_MI=[R5_MI(1,4); R5_MI(2,4); R5_MI(3,4)];
    R6_MI=R5_MI*R67_MI;
    Joint6_MI=[R6_MI(1,4); R6_MI(2,4); R6_MI(3,4)];
    R7_MI = R6_MI*R78_MI;
    Joint7_MI=[R7_MI(1,4); R7_MI(2,4); R7_MI(3,4)];

    if flag_init == 0
        pp15=plot3([Origin_MI(1,4) Joint1_MI(1)],[Origin_MI(2,4) Joint1_MI(2)],[Origin_MI(3,4) Joint1_MI(3)],'b.-');
        pp15.XDataSource = '[Origin_MI(1, 4) Joint1_MI(1)]';
        pp15.YDataSource = '[Origin_MI(2, 4) Joint1_MI(2)]';
        pp15.ZDataSource = '[Origin_MI(3, 4) Joint1_MI(3)]';

        pp16=plot3([Joint1_MI(1) Joint2_MI(1)],[Joint1_MI(2) Joint2_MI(2)],[Joint1_MI(3) Joint2_MI(3)],'b.-');
        pp17=plot3([Joint2_MI(1) Joint3_MI(1)],[Joint2_MI(2) Joint3_MI(2)],[Joint2_MI(3) Joint3_MI(3)],'b.-');
        pp18=plot3([Joint3_MI(1) Joint4_MI(1)],[Joint3_MI(2) Joint4_MI(2)],[Joint3_MI(3) Joint4_MI(3)],'b.-');
        pp19=plot3([Joint4_MI(1) Joint5_MI(1)],[Joint4_MI(2) Joint5_MI(2)],[Joint4_MI(3) Joint5_MI(3)],'b.-');
        pp20=plot3([Joint5_MI(1) Joint6_MI(1)],[Joint5_MI(2) Joint6_MI(2)],[Joint5_MI(3) Joint6_MI(3)],'b.-');
        pp21=plot3([Joint6_MI(1) Joint7_MI(1)],[Joint6_MI(2) Joint7_MI(2)],[Joint6_MI(3) Joint7_MI(3)],'b.-');

    end

    set(pp15, 'XData', [Origin_MI(1, 4) Joint1_MI(1)]);set(pp15, 'YData', [Origin_MI(2, 4) Joint1_MI(2)]);set(pp15, 'ZData', [Origin_MI(3, 4) Joint1_MI(3)]);
    set(pp16, 'XData', [Joint1_MI(1) Joint2_MI(1)]);   set(pp16, 'YData', [Joint1_MI(2) Joint2_MI(2)]);   set(pp16, 'ZData', [Joint1_MI(3) Joint2_MI(3)]);
    set(pp17, 'XData', [Joint2_MI(1) Joint3_MI(1)]);   set(pp17, 'YData', [Joint2_MI(2) Joint3_MI(2)]);   set(pp17, 'ZData', [Joint2_MI(3) Joint3_MI(3)]);
    set(pp18, 'XData', [Joint3_MI(1) Joint4_MI(1)]);   set(pp18, 'YData', [Joint3_MI(2) Joint4_MI(2)]);   set(pp18, 'ZData', [Joint3_MI(3) Joint4_MI(3)]);
    set(pp19, 'XData', [Joint4_MI(1) Joint5_MI(1)]);   set(pp19, 'YData', [Joint4_MI(2) Joint5_MI(2)]);   set(pp19, 'ZData', [Joint4_MI(3) Joint5_MI(3)]);
    set(pp20, 'XData', [Joint5_MI(1) Joint6_MI(1)]);   set(pp20, 'YData', [Joint5_MI(2) Joint6_MI(2)]);   set(pp20, 'ZData', [Joint5_MI(3) Joint6_MI(3)]);
    set(pp21, 'XData', [Joint6_MI(1) Joint7_MI(1)]);   set(pp21, 'YData', [Joint6_MI(2) Joint7_MI(2)]);   set(pp21, 'ZData', [Joint6_MI(3) Joint7_MI(3)]);


    drawnow;
    % % distance between end effectors
    dist_thumb_index = sqrt((Joint6(1)-Joint6_TH(1))^2+(Joint6(2)-Joint6_TH(2))^2+(Joint6(3)-Joint6_TH(3))^2);
    dist_thumb_middle = sqrt((Joint6_MI(1)-Joint6_TH(1))^2+(Joint6_MI(2)-Joint6_TH(2))^2+(Joint6_MI(3)-Joint6_TH(3))^2);
    fprintf('<DISTANCE> TH_INDEX : %3.3f, TH_MIDDLE : %3.3f\n', dist_thumb_index, dist_thumb_middle);
    

    % position
%     fprintf('Thumb: %3.3f, %3.3f, %3.3f\n', Joint6_TH(1), Joint6_TH(2), Joint6_TH(3));
    % fprintf('Index R6: %3.3f, %3.3f, %3.3f\n', Joint6(1), Joint6(2), Joint6(3));
    % fprintf('Index R7: %3.3f, %3.3f, %3.3f\n', Joint7(1), Joint7(2), Joint7(3));
    % fprintf('middle: %3.3f, %3.3f, %3.3f \n', Joint6_MI(1), Joint6_MI(2), Joint6_MI(3));

    % angle
    % fprintf('Index angle: %3.3f, %3.3f, %3.3f, %3.3f\n', TH1*180/pi, TH2*180/pi, TH3*180/pi, TH4*180/pi);

    view(180, -90)
    flag_init = 1;
end

