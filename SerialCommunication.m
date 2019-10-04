clear
clc
close all

%file open
fileID = fopen('Optimizing_Right02_191004.csv', 'w');

flag_show = 0;

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
ser = serial('COM4');
ser.Baudrate = 115200;
fopen(ser);

%assign the size of data
data = zeros(length_protocol, 1);

%% READ DATA

while(true)
    %read first byte and check whether it is same with the prefix byte
    first_byte = fread(ser, 1);    
    
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
            
           
            
           %% SAVE data
           if flag_show == 0
                fprintf(' sensor1 X value: %04.3f, sensor2 X value: %04.3f\n', bx{1}, bx{2})
           elseif flag_show == 1
                fprintf(' sensor3 X value: %04.3f, sensor4 X value: %04.3f\n', bx{3}, bx{4})
           elseif flag_show == 3
                fprintf(' sensor5 X value: %04.3f, sensor6 X value: %04.3f\n', bx{5}, bx{6})
           else
                fprintf('finished\n')
                exit
           end
%             fprintf(' sensor 1 X value: %04.3f, %04.3f, %04.3f, sensor2 X value: %04.3f, %04.3f, %04.3f', bx{1}, by{1}, bz{1}, bx{2}, by{2}, bz{2})
%             fprintf(' sensor 3: %04.3f, %04.3f, %04.3f, sensor4 : %04.3f, %04.3f, %04.3f', bx{3}, by{3}, bz{3}, bx{4}, by{4}, bz{4})
%             fprintf(' sensor 5: %04.3f, %04.3f, %04.3f, sensor6 : %04.3f, %04.3f, %04.3f\n', bx{5}, by{5}, bz{5}, bx{6}, by{6}, bz{6})
            
            if bx{1} == 0 && bx{2} == 0 && flag_show == 0 
                for idx=1:1:5
                    fprintf(fileID, '%04.3f,%04.3f,%04.3f,', bx{idx}, by{idx}, bz{idx});
                end
                fprintf(fileID, '%04.3f,%04.3f,%04.3f\n', bx{6}, by{6}, bz{6});
                flag_show = bitor(flag_show, 1);
            end
            
            if bx{3} == 0 && bx{4} == 0 && flag_show == 1 
                for idx=1:1:5
                    fprintf(fileID, '%04.3f,%04.3f,%04.3f,', bx{idx}, by{idx}, bz{idx});
                end
                fprintf(fileID, '%04.3f,%04.3f,%04.3f\n', bx{6}, by{6}, bz{6});
                flag_show = bitor(flag_show, 2);
            end
            
            if bx{5} == 0 && bx{6} == 0 && flag_show == 3
                for idx=1:1:5
                    fprintf(fileID, '%04.3f,%04.3f,%04.3f,', bx{idx}, by{idx}, bz{idx});
                end
                fprintf(fileID, '%04.3f,%04.3f,%04.3f\n', bx{6}, by{6}, bz{6});
                flag_show = bitor(flag_show, 4);
                fclose(fileID);
            end
                
                    
%                 fprintf(fileID, '%04.3f,%04.3f,%04.3f', bx{1}, by{1}, bz{1});
%                 fprintf(fileID, '%04.3f,%04.3f,%04.3f', bx{2}, by{1}, bz{1});
%                 fprintf(fileID, '%04.3f,%04.3f,%04.3f', bx{3}, by{1}, bz{1});
%                 fprintf(fileID, '%04.3f,%04.3f,%04.3f', bx{4}, by{1}, bz{1});
%                 fprintf(fileID, '%04.3f,%04.3f,%04.3f', bx{5}, by{1}, bz{1});
%                 fprintf(fileID, '%04.3f,%04.3f,%04.3f', bx{6}, by{1}, bz{1});
            
            
           
                        
        end
    end
end


%close serial COM Port
% fclose(ser);
% delete(ser);
% clear ser
