function output = pos_endEffector_onlyDH_lengthCalibration(parameter_input, data)
% INPUT
% first parameter  : sensor offsetÀÇ initial value
% second parameter : simulation data °ª 

   
A1 = parameter_input(1); C1 = parameter_input(2);
A2 = parameter_input(3); C2 = parameter_input(4);
A3 = parameter_input(5); C3 = parameter_input(6);
A5 = parameter_input(7); C5 = parameter_input(8);
A6 = parameter_input(9); C6 = parameter_input(10);

pos_reference = data(:, 12:14);
        
    for i=1:size(data, 1)
        
        B2 = data(i,1);B3 = data(i,2);B5 = data(i,3);B6 = data(i,4);
                
        diff_x = C1 + cos(B2)*(C2 + 24.21) + 37.0*sin(B6)*(cos(B2)*cos(B3)*sin(B5) + cos(B2)*cos(B5)*sin(B3)) + A3*sin(B2) + A5*sin(B2) + A6*sin(B2) - 37.0*cos(B6)*(cos(B2)*cos(B3)*cos(B5) - 1.0*cos(B2)*sin(B3)*sin(B5)) + 12.94*cos(B2)*sin(B3) + cos(B6)*(cos(B2)*cos(B3)*sin(B5) + cos(B2)*cos(B5)*sin(B3))*(C6 + 17.25) + sin(B6)*(cos(B2)*cos(B3)*cos(B5) - 1.0*cos(B2)*sin(B3)*sin(B5))*(C6 + 17.25) + cos(B2)*cos(B3)*(C3 + 56.03) + cos(B2)*cos(B3)*sin(B5)*(C5 + 57.5) + cos(B2)*cos(B5)*sin(B3)*(C5 + 57.5);
        diff_y = A2 - 12.94*cos(B3) + sin(B3)*(C3 + 56.03) - 37.0*sin(B6)*(cos(B3)*cos(B5) - 1.0*sin(B3)*sin(B5)) - 37.0*cos(B6)*(cos(B3)*sin(B5) + cos(B5)*sin(B3)) - 1.0*cos(B6)*(cos(B3)*cos(B5) - 1.0*sin(B3)*sin(B5))*(C6 + 17.25) - 1.0*cos(B3)*cos(B5)*(C5 + 57.5) + sin(B6)*(cos(B3)*sin(B5) + cos(B5)*sin(B3))*(C6 + 17.25) + sin(B3)*sin(B5)*(C5 + 57.5);
        diff_z = A1 - 1.0*sin(B2)*(C2 + 24.21) + A3*cos(B2) + A5*cos(B2) + A6*cos(B2) - 37.0*sin(B6)*(cos(B3)*sin(B2)*sin(B5) + cos(B5)*sin(B2)*sin(B3)) + 37.0*cos(B6)*(cos(B3)*cos(B5)*sin(B2) - 1.0*sin(B2)*sin(B3)*sin(B5)) - 12.94*sin(B2)*sin(B3) - 1.0*cos(B6)*(cos(B3)*sin(B2)*sin(B5) + cos(B5)*sin(B2)*sin(B3))*(C6 + 17.25) - 1.0*sin(B6)*(cos(B3)*cos(B5)*sin(B2) - 1.0*sin(B2)*sin(B3)*sin(B5))*(C6 + 17.25) - 1.0*cos(B3)*sin(B2)*(C3 + 56.03) - 1.0*cos(B3)*sin(B2)*sin(B5)*(C5 + 57.5) - 1.0*cos(B5)*sin(B2)*sin(B3)*(C5 + 57.5);
        
        ref_x = pos_reference(i,1);
        ref_y = pos_reference(i,2);
        ref_z = pos_reference(i,3);
        
        output(i,1) = sqrt((diff_x-ref_x)^2+(diff_y-ref_y)^2+(diff_z-ref_z)^2);
        
    end
    
%     disp(strcat(["output: ", output]))

   

end

% 'trust-region-reflective'
% options = optimoptions(@lsqnonlin,'Algorithm', 'levenberg-marquardt','Display', 'iter', 'MaxFunctionEvaluations', 1000000, 'MaxIterations', 100000);
% options = optimoptions(@lsqnonlin,'Algorithm', 'trust-region-reflective','Display', 'iter', 'MaxFunctionEvaluations', 1000000, 'MaxIterations', 100000);
% lsqnonlin(@pos_endEffector, [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],[],[],options, data)
