%magnetic flux
mean_magnetic_data_training = [mean(magnetic_data_training{1,1}(:,7:12));
                                mean(magnetic_data_training{1,2}(:,7:12));
                                mean(magnetic_data_training{1,3}(:,7:12));];

clear std

std_magnetic_data_training = [std(magnetic_data_training{1,1}(:,7:12));
                            std(magnetic_data_training{1,2}(:,7:12));
                            std(magnetic_data_training{1,3}(:,7:12));];

mean_magnetic_data_test = [mean(magnetic_data_test{1,1}(:,7:12));
                            mean(magnetic_data_test{1,2}(:,7:12));
                            mean(magnetic_data_test{1,3}(:,7:12));];

clear std

std_magnetic_data_test = [std(magnetic_data_test{1,1}(:,7:12));
                            std(magnetic_data_test{1,2}(:,7:12));
                            std(magnetic_data_test{1,3}(:,7:12));];


% joint angle
mean_arr_jointAngles_training = [mean(arr_jointAngles_training(:,5:8,1));
    mean(arr_jointAngles_training(:,5:8,2));
    mean(arr_jointAngles_training(:,5:8,3));];

mean_arr_jointAngles_training = mean_arr_jointAngles_training * 180/pi;

mean_arr_jointAngles_test= [mean(arr_jointAngles_test(:,5:8,1));
    mean(arr_jointAngles_test(:,5:8,2));
    mean(arr_jointAngles_test(:,5:8,3));];

mean_arr_jointAngles_test = mean_arr_jointAngles_test * 180/pi;