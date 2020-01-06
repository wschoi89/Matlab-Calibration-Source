% options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 50000, 'MaxIterations', 50000, 'initDamping', 100, 'PlotFcn','optimplotx', 'StepTolerance', 1e-10);
% options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 50000, 'MaxIterations', 50000, 'initDamping', 100000, 'PlotFcn','optimplotx',  'FiniteDifferenceType', 'central');
% options = optimoptions(@lsqnonlin,'Algorithm', 'trust-region-reflective','Display', 'iter', 'MaxFunctionEvaluations', 20000, 'MaxIterations', 20000, 'FiniteDifferenceType', 'central','PlotFcn','optimplotx', 'DiffMaxChange', 0.1);

disp('optimization start')
options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 50000, 'MaxIterations', 50000, 'initDamping', 10,'StepTolerance', 1e-10);

% pre-allocation for optimized parameters
num_optParam = 16;
list_optParam = zeros(num_iteration, num_optParam);

for page=1:num_iteration
        
    data_batch = trainingData(:,:,page);
       
    optimized_parameter=lsqnonlin(@pos_endEffector_onlyDH_allCalibration,zeros(1,num_optParam),[],[],options, data_batch);
    list_optParam(page, :) = optimized_parameter;
    
   
end

save(strcat('optimized_parameter_', num2str(num_trainingData), '.mat'), 'list_optParam');
disp(strcat('optimized parameters were saved in optimized_parameter_', num2str(num_trainingData),'.mat file'));


