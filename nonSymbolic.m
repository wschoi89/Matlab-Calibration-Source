options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 50000, 'MaxIterations', 50000, 'initDamping', 10000, 'PlotFcn','optimplotx', 'StepTolerance', 1e-10);
% options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 50000, 'MaxIterations', 50000, 'initDamping', 100000, 'PlotFcn','optimplotx',  'FiniteDifferenceType', 'central');
% options = optimoptions(@lsqnonlin,'Algorithm', 'trust-region-reflective','Display', 'iter', 'MaxFunctionEvaluations', 20000, 'MaxIterations', 20000, 'FiniteDifferenceType', 'central','PlotFcn','optimplotx', 'DiffMaxChange', 0.1);

% lb = [-1.0,-1.0,-1.0,-1.0, -10, -1.0, -10, -1.0, -10, -10, -1.0, -10, -1.0, -10, -1.0, -10, -10, -1.0];
% ub = [ 1.0, 1.0, 1.0, 1.0,  10,  1.0,  10,  1.0,  10,  10,  1.0,  10,  1.0,  10,  1.0,  10,  10,  1.0];
% lsqnonlin(@pos_endEffector, [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],lb,ub,options, data)
lsqnonlin(@pos_endEffector, [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[],[],options, data)

% lsqnonlin(@pos_endEffector, ans,[],[],options, data)

% 'StepTolerance', 1e-8, 'FunctionTolerance', 1.0e-8, 
ans'
save('parameter_output.mat', 'ans');