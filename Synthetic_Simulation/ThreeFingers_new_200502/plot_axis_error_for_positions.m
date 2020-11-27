% plot axis error depending on positison
% no calibration error
figure;
%thumb
error=zeros(num_zigPos_training(1),3);
for i=1:num_zigPos_training(1)
   error(i,:)=arr_mean_dist_noCalib_training{1,1}(1,1:3,i); 
end
b=bar(error,'histc');
b(1).FaceColor='r';
b(2).FaceColor='g';
b(3).FaceColor='b';
title('Axis error without calibration (thumb)')
legend x y z



% training error
%thumb
figure;
error=zeros(num_zigPos_training(1),3);
for i=1:num_zigPos_training(1)
   error(i,:)=arr_mean_dist_Calib_training{1,1}(1,1:3,i); 
end
b=bar(error,'histc');
b(1).FaceColor='r';
b(2).FaceColor='g';
b(3).FaceColor='b';
title('each axis training error (thumb)')
legend x y z

%index
figure;
error=zeros(num_zigPos_training(2),3);
for i=1:num_zigPos_training(2)
   error(i,:)=arr_mean_dist_Calib_training{1,2}(1,1:3,i); 
end
b=bar(error,'histc');
b(1).FaceColor='r';
b(2).FaceColor='g';
b(3).FaceColor='b';
title('each axis training error (index)')
legend x y z

%index
figure;
error=zeros(num_zigPos_training(3),3);
for i=1:num_zigPos_training(3)
   error(i,:)=arr_mean_dist_Calib_training{1,3}(1,1:3,i); 
end
b=bar(error,'histc');
b(1).FaceColor='r';
b(2).FaceColor='g';
b(3).FaceColor='b';
title('each axis training error (middle)')
legend x y z




% test error
%thumb
figure;
error=zeros(num_zigPos_test(1),3);
for i=1:num_zigPos_test(1)
   error(i,:)=arr_mean_dist_Calib_test{1,1}(1,1:3,i); 
end
b=bar(error,'histc');
b(1).FaceColor='r';
b(2).FaceColor='g';
b(3).FaceColor='b';
title('each axis test error (thumb)')
legend x y z

%index
figure;
error=zeros(num_zigPos_test(2),3);
for i=1:num_zigPos_test(2)
   error(i,:)=arr_mean_dist_Calib_test{1,2}(1,1:3,i); 
end
b=bar(error,'histc');
b(1).FaceColor='r';
b(2).FaceColor='g';
b(3).FaceColor='b';
title('each axis test error (index)')
legend x y z

%middle
figure;
error=zeros(num_zigPos_test(3),3);
for i=1:num_zigPos_test(3)
   error(i,:)=arr_mean_dist_Calib_test{1,3}(1,1:3,i); 
end
b=bar(error,'histc');
b(1).FaceColor='r';
b(2).FaceColor='g';
b(3).FaceColor='b';
title('each axis test error (middle)')
legend x y z