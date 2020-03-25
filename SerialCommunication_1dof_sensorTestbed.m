clear;clc;close all;

%file open for offset data recording
if mkdir('DAQ')==false
    mkdir('DAQ');
end

%% set COM PORT, device number, position for DAQ, and the number of samples
COM_PORT='COM10';

num_device='sensor3_testbed_magnet180_case3';
position='-90';
slide='0'; 
num_samples = 10; 

num_sensors = 6;    
% fileID = fopen(strcat('DAQ/',num_device,'_DAQ_T',position,'_I',position,'_M',position,'_slide',slide,'_training.csv'), 'w');
% fileID = fopen(strcat('DAQ/',num_device,'_DAQ_T',position,'_I',position,'_M',position,'_test.csv'), 'w');
fileID = fopen(strcat('DAQ/',num_device,'_', position, 'degree.csv'), 'w');

disp('Start in 5 seconds!')

% set initial interation number as zero
iter = 0;

% data preallocation 
data_for_plot = zeros(num_samples, num_sensors*3); % 3 means the number of vector components (Bx, By, Bz)

%close existing memory of port object
if ~isempty(instrfind)
     fclose(instrfind);
      delete(instrfind);
end

%data length, prefix, postfix
length_protocol = 46;
hex_prefix = 64;
hex_postfix = 255;

%open serial port
ser = serial(COM_PORT);
ser.Baudrate = 115200;
fopen(ser);

%count number for saving magnetic flux samples
count_bx = 0;

%assign the size of data
data = zeros(length_protocol, 1);

%% READ DATA

while(true)
    % read first byte 
    [first_byte, num_read] = fread(ser, 1);    
   
    %check the USB connection status
    if num_read == 0
        error("please check the USB connection or power ")
        exit
    end 
    
    %check first byte
    if first_byte == hex_prefix
        remain_byte = fread(ser, length_protocol - 1);
                
        %check last byte
        if remain_byte(end) == hex_postfix
            data = [first_byte;remain_byte];
            
            %parsing sensor data (6sensors, 7bytes for each sensor)
            % 왼손
            % sensor 1: 중지 말단
            % sensor 2: 중지 손등
            % sensor 3: 검지 손등
            % sensor 4: 검지 말단
            % sensor 5: 엄지 손등
            % sensor 6: 엄지 말단 
            
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
                      
            
            fprintf('iter %d: ', iter);
            fprintf(' sensor 1: %04.3f, %04.3f, %04.3f, sensor2 : %04.3f, %04.3f, %04.3f', bx{1}, by{1}, bz{1}, bx{2}, by{2}, bz{2})
            fprintf(' sensor 3: %04.3f, %04.3f, %04.3f, sensor4 : %04.3f, %04.3f, %04.3f', bx{3}, by{3}, bz{3}, bx{4}, by{4}, bz{4})
            fprintf(' sensor 5: %04.3f, %04.3f, %04.3f, sensor6 : %04.3f, %04.3f, %04.3f\n', bx{5}, by{5}, bz{5}, bx{6}, by{6}, bz{6})
                     
           iter = iter + 1;
           
           data_for_plot(iter, :) = [ bx{1} by{1} bz{1} bx{2} by{2} bz{2} bx{3} by{3} bz{3} bx{4} by{4} bz{4} bx{5} by{5} bz{5} bx{6} by{6} bz{6}];
           plot(data_for_plot)
           legend bx1 by1 bz1 bx2 by2 bz2 bx3 by3 bz3 bx4 by4 bz4 bx5 by5 bz5 bx6 by6 bz6
           fprintf(fileID, '%04.3f,%04.3f,%04.3f,', bx{1}, by{1}, bz{1});
           fprintf(fileID, '%04.3f,%04.3f,%04.3f,', bx{2}, by{2}, bz{2});
           fprintf(fileID, '%04.3f,%04.3f,%04.3f,', bx{3}, by{3}, bz{3});
           fprintf(fileID, '%04.3f,%04.3f,%04.3f,', bx{4}, by{4}, bz{4});
           fprintf(fileID, '%04.3f,%04.3f,%04.3f,', bx{5}, by{5}, bz{5});
           fprintf(fileID, '%04.3f,%04.3f,%04.3f', bx{6}, by{6}, bz{6});
           fprintf(fileID, '\n');
           
            if iter == num_samples
              break; 
           end
            
           
                        
        end
    end
end

%close csv file
fclose(fileID);
%disconnect serial communication
delete(ser);

disp('finished')


