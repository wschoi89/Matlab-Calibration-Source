
device_name='Device4';
close all

magnetic_data_training = cell(1,15);
magnetic_data_test = cell(1,15);
mean_magnetic_data_training = cell(1,15);
mean_magnetic_data_test = cell(1,15);

for n_pos=1:15
    fileName_magneticData_training=strcat('DAQ/',device_name,'/training/',device_name,'_DAQ_T',num2str(n_pos),'_I',num2str(n_pos),'_M',num2str(n_pos),'_training.csv');
    fileName_magneticData_test=strcat('DAQ/',device_name,'/test/',device_name,'_DAQ_T',num2str(n_pos),'_I',num2str(n_pos),'_M',num2str(n_pos),'_test.csv');
    
    magnetic_data_training{1,n_pos} = load(fileName_magneticData_training);
    mean_magnetic_data_training{1,n_pos} = mean(magnetic_data_training{1,n_pos});
    
    magnetic_data_test{1,n_pos} = load(fileName_magneticData_test);
    mean_magnetic_data_test{1,n_pos} = mean(magnetic_data_test{1,n_pos});
end

for n_pos=1:15
%    figure;
   % index and middle finger data¸¸ visualization 
   data = [mean_magnetic_data_training{1,n_pos}(7:end);mean_magnetic_data_test{1,n_pos}(7:end)]'; 
%    bar(data)
%    title(num2str(n_pos));
   difference{1,n_pos} = mean_magnetic_data_training{1,n_pos}(7:end)-mean_magnetic_data_test{1,n_pos}(7:end);
end


for n_pos=1:15
   subplot(5,3,n_pos);
    bar(difference{1,n_pos});
    title(strcat('differnce at pos', num2str(n_pos)));
    ylabel('mT')
end


