error_table = zeros(3,6);
% no calibration error
error_table(1,1) = mean(arr_mean_dist_noCalib_training{1,1}(1,4,:));
error_table(1,3) = mean(arr_mean_dist_noCalib_training{1,2}(1,4,:));
error_table(1,5) = mean(arr_mean_dist_noCalib_training{1,3}(1,4,:));

clear std
error_table(1,2) = std(arr_mean_dist_noCalib_training{1,1}(1,4,:));
error_table(1,4) = std(arr_mean_dist_noCalib_training{1,2}(1,4,:));
error_table(1,6) = std(arr_mean_dist_noCalib_training{1,3}(1,4,:));



error_table(2,1)=mean(arr_mean_dist_Calib_training{1,1}(1,4,:));
error_table(2,3)=mean(arr_mean_dist_Calib_training{1,2}(1,4,:));
error_table(2,5)=mean(arr_mean_dist_Calib_training{1,3}(1,4,:));

clear std
error_table(2,2)=std(arr_mean_dist_Calib_training{1,1}(1,4,:));
clear std
error_table(2,4)=std(arr_mean_dist_Calib_training{1,2}(1,4,:));
clear std
error_table(2,6)=std(arr_mean_dist_Calib_training{1,3}(1,4,:));

% error_table(3,1)=mean(arr_mean_dist_Calib_test{1,1}(1,4,:));
% error_table(3,3)=mean(arr_mean_dist_Calib_test{1,2}(1,4,:));
% error_table(3,5)=mean(arr_mean_dist_Calib_test{1,3}(1,4,:));
% 
% clear std
% error_table(3,2)=std(arr_mean_dist_Calib_test{1,1}(1,4,:));
% clear std
% error_table(3,4)=std(arr_mean_dist_Calib_test{1,2}(1,4,:));
% clear std
% error_table(3,6)=std(arr_mean_dist_Calib_test{1,3}(1,4,:));


