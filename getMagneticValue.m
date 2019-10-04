function [bx, by, bz] = getMagneticValue(sensor1)
    upper = sensor1(1);
    upper_12 = bitshift(upper, 4);
    lower = sensor1(5);
    lower_4 = bitshift(lower, -4);

    bx = bitor(upper_12, lower_4);
    bx_bin = dec2bin(bx, 12);

    sign = bitand(bx, bin2dec('1000 00000000'));
    adcVal = bitand(bx, bin2dec('0111 11111111'));

    unit = 0.098;
    if sign
        adcVal = adcVal - 2048;
    end

    val_bx = adcVal*unit;
    %% sensor 1 by
    upper = sensor1(2);
    upper_12 = bitshift(upper, 4);
    lower = sensor1(5);
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

    upper = sensor1(3);
    upper_12 = bitshift(upper, 4);
    lower = sensor1(6);
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

