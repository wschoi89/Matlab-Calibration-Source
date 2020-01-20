% options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 50000, 'MaxIterations', 50000, 'initDamping', 100, 'PlotFcn','optimplotx', 'StepTolerance', 1e-10);
% options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 50000, 'MaxIterations', 50000, 'initDamping', 100000, 'PlotFcn','optimplotx',  'FiniteDifferenceType', 'central');
% options = optimoptions(@lsqnonlin,'Algorithm', 'trust-region-reflective','Display', 'iter', 'MaxFunctionEvaluations', 20000, 'MaxIterations', 20000, 'FiniteDifferenceType', 'central','PlotFcn','optimplotx', 'DiffMaxChange', 0.1);

disp('optimization start')
options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 100000, 'MaxIterations', 100000, 'initDamping', 10,'StepTolerance', 1e-10);

% load data
load training_test_data.mat

finger = 'thumb';
% finger = 'index';
% finger = 'middle';

% thumb
if strcmp(finger, 'thumb')
    training_thumb = pos_endEffector_noCalib{1,1};
    test_thumb = pos_calibZig{1,1};
    [row,col,page] = size(training_thumb);
    data_training=zeros(1800,3);
    data_test = zeros(1800,3); % cad data
    data_jointAngle = zeros(1800,4);
    data_jointAngle_thumb = data_jointAngle(:,1:4);    
    
    for p=1:page
        data_training(row*(p-1)+1:row*p,:) = training_thumb(:,:,p);
        data_jointAngle_thumb(row*(p-1)+1:row*p,:) = arr_jointAngles(:,1:4,p);
        for r=1:row
            data_test(100*(p-1)+r,:) = test_thumb(p,1:3);

        end
    end
    
    data = [data_jointAngle_thumb data_test];

elseif strcmp(finger, 'index')
    test_index = pos_calibZig{1,2};
    training_index = pos_endEffector_noCalib{1,2};
    [row,col,page] = size(training_index);
    data_training=zeros(1600,3);
    data_test = zeros(1600,3);
    data_jointAngle_indexMiddle = zeros(1600, 8);
    data_jointAngle_index = data_jointAngle_indexMiddle(:,1:4);

    for p=1:page
        data_training(row*(p-1)+1:row*p,:) = training_index(:,:,p);
        data_jointAngle_index(row*(p-1)+1:row*p,:) = arr_jointAngles(:,5:8,p);
        for r=1:row
            data_test(100*(p-1)+r,:) = test_index(p,1:3);

        end
    end

    data = [data_jointAngle_index data_test];

elseif strcmp(finger, 'middle')
    test_middle = pos_calibZig{1,3};
    training_middle = pos_endEffector_noCalib{1,3};
    [row,col,page] = size(training_middle);
    data_training=zeros(1600,3);
    data_test = zeros(1600,3);
    data_jointAngle_indexMiddle = zeros(1600, 8);
    data_jointAngle_middle = data_jointAngle_indexMiddle(:,5:8);

    for p=1:page
        data_training(row*(p-1)+1:row*p,:) = training_middle(:,:,p);
        data_jointAngle_middle(row*(p-1)+1:row*p,:) = arr_jointAngles(:,9:12,p);
        for r=1:row
            data_test(100*(p-1)+r,:) = test_middle(p,1:3);

        end
    end

    data = [data_jointAngle_middle data_test];
end





% pre-allocation for optimized parameters
num_optParam = 20;
num_iteration=1;
list_optParam = zeros(num_iteration, num_optParam);


for page=1:num_iteration
        
%     data_batch = trainingData(:,:,page);
        
    optimized_parameter=lsqnonlin (@pos_endEffector_allCalibration,zeros(1,num_optParam),[],[],options, data, finger);
    list_optParam(page, :) = optimized_parameter;
    
   
end

if strcmp(finger, 'thumb')
    save(strcat('optimized_parameter_thumb', '.mat'), 'list_optParam');
elseif strcmp(finger, 'index')
    save(strcat('optimized_parameter_index', '.mat'), 'list_optParam');
elseif strcmp(finger, 'middle')
    save(strcat('optimized_parameter_middle', '.mat'), 'list_optParam');
end



