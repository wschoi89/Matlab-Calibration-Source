% options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 50000, 'MaxIterations', 50000, 'initDamping', 100, 'PlotFcn','optimplotx', 'StepTolerance', 1e-10);
% options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 50000, 'MaxIterations', 50000, 'initDamping', 100000, 'PlotFcn','optimplotx',  'FiniteDifferenceType', 'central');
% options = optimoptions(@lsqnonlin,'Algorithm', 'trust-region-reflective','Display', 'iter', 'MaxFunctionEvaluations', 20000, 'MaxIterations', 20000, 'FiniteDifferenceType', 'central','PlotFcn','optimplotx', 'DiffMaxChange', 0.1);


options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 500000, 'MaxIterations', 500000, 'initDamping', 10,'StepTolerance', 1e-10);

% plot_error
% lb = [-1.0,-1.0,-1.0,-1.0, -10, -1.0, -10, -1.0, -10, -10, -1.0, -10, -1.0, -10, -1.0, -10, -10, -1.0];
% ub = [ 1.0, 1.0, 1.0, 1.0,  10,  1.0,  10,  1.0,  10,  10,  1.0,  10,  1.0,  10,  1.0,  10,  10,  1.0];
% lsqnonlin(@pos_endEffector, [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],lb,ub,options, data)

% shuffle data and divide into training(70) and test data(30)

[n, c] = size(data);
% data = data(randperm(r),:);
% num_training_data = ceil(r*0.7);
% num_test_data = r;

% output=lsqnonlin(@pos_endEffector, [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[],[],options, data);
% 
% % compare output for all paramters(20)
output = output';
compare_results = [concat_DHoffset' output concat_DHoffset'-output]

output = output';
save('parameter_output.mat', 'output');

% compare output for DH angles(6)
% concat_DHoffset_angle = concat_DHoffset(15:20);
% output_DHoffset_angle = [output(6), output(8), output(11), output(14), output(17), output(20)];
% difference_DHoffset_angle = concat_DHoffset_angle - output_DHoffset_angle;
% compare_results = [concat_DHoffset_angle' output_DHoffset_angle' difference_DHoffset_angle']

