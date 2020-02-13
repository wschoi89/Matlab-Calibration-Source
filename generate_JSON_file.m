filename = 'mech-R1.json';
fileID = fopen(filename, 'w');
fprintf(fileID, '{\n');
fprintf(fileID, '\t"HandSide" : "right",\n\n');
fprintf(fileID, '\t"DH_offset": [\n ');

parameters = zeros(3,20);
load('device1_optimized_parameter_thumb.mat');
parameters(1,:) = list_optParam;
load('device1_optimized_parameter_index.mat');
parameters(2,:) = list_optParam;
load('device1_optimized_parameter_middle.mat');
parameters(3,:) = list_optParam;

for row=1:3
    for col=5:20
        if row==3
            if col==20
                fprintf(fileID, ' %f],', parameters(row,col));
                continue
            end
        end
        fprintf(fileID, ' %f,', parameters(row,col));
    end
    fprintf(fileID, '\n');
end
fprintf(fileID, '\n');
fprintf(fileID, '\t"off_TH1_Thumb": %f,\n', parameters(1,1));
fprintf(fileID, '\t"off_TH2_Thumb": %f,\n', parameters(1,2));
fprintf(fileID, '\t"off_TH3_Thumb": %f,\n', parameters(1,3));
fprintf(fileID, '\t"off_TH4_Thumb": %f,\n\n', parameters(1,4));
fprintf(fileID, '\t"off_TH1_Index": %f,\n', parameters(2,1));
fprintf(fileID, '\t"off_TH2_Index": %f,\n', parameters(2,2));
fprintf(fileID, '\t"off_TH3_Index": %f,\n', parameters(2,3));
fprintf(fileID, '\t"off_TH4_Index": %f,\n\n', parameters(2,4));
fprintf(fileID, '\t"off_TH1_Middle": %f,\n', parameters(3,1));
fprintf(fileID, '\t"off_TH2_Middle": %f,\n', parameters(3,2));
fprintf(fileID, '\t"off_TH3_Middle": %f,\n', parameters(3,3));
fprintf(fileID, '\t"off_TH4_Middle": %f\n', parameters(3,4));
fprintf(fileID, ' }');
fclose(fileID);