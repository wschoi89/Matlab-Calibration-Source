function [bx, by, bz] = getMagneticValue(sensor_in)
    
    % input : 7 bytes
    % 1st byte = Bx(4~11)
    % 2nd byte = By(4~11)
    % 3rd byte = Bz(4~11)
    % 4th byte = temperature
    % 5th byte = Bx(0~3), By(0~3)
    % 6th byte = Reserve(3), Pd(1), Bz(0~3)
    %% bx 
    upper = sensor_in(1);
    upper_12 = bitshift(upper, 4);% ¿ÞÂÊÀ¸·Î 4Ä­ bitshift, 12bitµÊ
    lower = sensor_in(5);
    lower_4 = bitshift(lower, -4);% ¿À¸¥ÂÊÀ¸·Î 4Ä­ bitshift 

    bx = bitor(upper_12, lower_4);
    bx_bin = dec2bin(bx, 12);% convert decimal to binary

    sign = bitand(bx, bin2dec('1000 00000000')); % Bit-wise AND
    adcVal = bitand(bx, bin2dec('0111 11111111'));

    unit = 0.098;
    if sign
        adcVal = adcVal - 2048;
    end

    val_bx = adcVal*unit;
    %% sensor 1 by
    upper = sensor_in(2);
    upper_12 = bitshift(upper, 4);
    lower = sensor_in(5);
    lower_4 = bitand(lower, bin2dec('00001111'));

    by = bitor(upper_12, lower_4);
    by_bin = dec2bin(by, 12);

    sign = bitand(by, bin2dec('1000 00000000'));
    adcVal = bitand(by, bin2dec('0111 11111111'));

    if sign
        adcVal = adcVal - 2048;
    end

    val_by = adcVal*unit;

    %% sensor 1 bz

    upper = sensor_in(3);
    upper_12 = bitshift(upper, 4);
    lower = sensor_in(6);
    lower_4 = bitand(lower, bin2dec('00001111'));

    by = bitor(upper_12, lower_4);
    by_bin = dec2bin(by, 12);

    sign = bitand(by, bin2dec('1000 00000000'));
    adcVal = bitand(by, bin2dec('0111 11111111'));

    if sign
        adcVal = adcVal - 2048;
    end

    val_bz = adcVal*unit;
    
    bx = val_bx;
    by = val_by;
    bz = val_bz;
    

end

