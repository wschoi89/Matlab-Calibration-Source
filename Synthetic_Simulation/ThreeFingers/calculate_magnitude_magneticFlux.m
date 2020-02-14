
num_zigPos = 3;
mag_vec = zeros(num_zigPos(1),18);
for n_pos=1:num_zigPos(1)
    
    fileName_magneticData=strcat('DAQ/device2_/device2__DAQ_T',num2str(n_pos),'_I',num2str(n_pos),'_M',num2str(n_pos),'_training','.csv');
    magnetic_data = load(fileName_magneticData);
    mean_magnet(n_pos, :) = mean(magnetic_data);
%     for i=1:6
%         mag_vec(n_pos, i) = sqrt(mean_magnet(3*(i-1)+1)^2+mean_magnet(3*(i-1)+2)^2+mean_magnet(3*i)^2);
%     end
end

mean(mag_vec)
clear std
std(mag_vec)




