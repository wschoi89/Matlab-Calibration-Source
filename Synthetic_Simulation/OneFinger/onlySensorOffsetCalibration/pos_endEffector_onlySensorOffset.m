function output = pos_endEffector_onlySensorOffset(parameter_input, data)
% INPUT
% first parameter  : sensor offsetÀÇ initial value
% second parameter : simulation data °ª 

   
off_TH1 = parameter_input(1);off_TH2 = parameter_input(2);off_TH3 = parameter_input(3); off_TH4 = parameter_input(4);

pos_reference = data(:, 12:14);
        
    for i=1:size(data, 1)
        
        B2 = data(i,1);B3 = data(i,2);B5 = data(i,3);B6 = data(i,4);
      
        diff_x=24.21*cos(B2 + off_TH1) - 37.0*cos(B6 + off_TH4)*(cos(B2 + off_TH1)*cos(B3 + off_TH2)*cos(B5 + off_TH3) - 1.0*cos(B2 + off_TH1)*sin(B3 + off_TH2)*sin(B5 + off_TH3)) + 17.25*sin(B6 + off_TH4)*(cos(B2 + off_TH1)*cos(B3 + off_TH2)*cos(B5 + off_TH3) - 1.0*cos(B2 + off_TH1)*sin(B3 + off_TH2)*sin(B5 + off_TH3)) + 56.03*cos(B2 + off_TH1)*cos(B3 + off_TH2) + 12.94*cos(B2 + off_TH1)*sin(B3 + off_TH2) + 17.25*cos(B6 + off_TH4)*(cos(B2 + off_TH1)*cos(B3 + off_TH2)*sin(B5 + off_TH3) + cos(B2 + off_TH1)*cos(B5 + off_TH3)*sin(B3 + off_TH2)) + 37.0*sin(B6 + off_TH4)*(cos(B2 + off_TH1)*cos(B3 + off_TH2)*sin(B5 + off_TH3) + cos(B2 + off_TH1)*cos(B5 + off_TH3)*sin(B3 + off_TH2)) + 57.5*cos(B2 + off_TH1)*cos(B3 + off_TH2)*sin(B5 + off_TH3) + 57.5*cos(B2 + off_TH1)*cos(B5 + off_TH3)*sin(B3 + off_TH2);
        diff_y=56.03*sin(B3 + off_TH2) - 12.94*cos(B3 + off_TH2) - 17.25*cos(B6 + off_TH4)*(cos(B3 + off_TH2)*cos(B5 + off_TH3) - 1.0*sin(B3 + off_TH2)*sin(B5 + off_TH3)) - 37.0*sin(B6 + off_TH4)*(cos(B3 + off_TH2)*cos(B5 + off_TH3) - 1.0*sin(B3 + off_TH2)*sin(B5 + off_TH3)) - 57.5*cos(B3 + off_TH2)*cos(B5 + off_TH3) + 57.5*sin(B3 + off_TH2)*sin(B5 + off_TH3) - 37.0*cos(B6 + off_TH4)*(cos(B3 + off_TH2)*sin(B5 + off_TH3) + cos(B5 + off_TH3)*sin(B3 + off_TH2)) + 17.25*sin(B6 + off_TH4)*(cos(B3 + off_TH2)*sin(B5 + off_TH3) + cos(B5 + off_TH3)*sin(B3 + off_TH2));
        diff_z=37.0*cos(B6 + off_TH4)*(cos(B3 + off_TH2)*cos(B5 + off_TH3)*sin(B2 + off_TH1) - 1.0*sin(B2 + off_TH1)*sin(B3 + off_TH2)*sin(B5 + off_TH3)) - 24.21*sin(B2 + off_TH1) - 17.25*sin(B6 + off_TH4)*(cos(B3 + off_TH2)*cos(B5 + off_TH3)*sin(B2 + off_TH1) - 1.0*sin(B2 + off_TH1)*sin(B3 + off_TH2)*sin(B5 + off_TH3)) - 56.03*cos(B3 + off_TH2)*sin(B2 + off_TH1) - 12.94*sin(B2 + off_TH1)*sin(B3 + off_TH2) - 17.25*cos(B6 + off_TH4)*(cos(B3 + off_TH2)*sin(B2 + off_TH1)*sin(B5 + off_TH3) + cos(B5 + off_TH3)*sin(B2 + off_TH1)*sin(B3 + off_TH2)) - 37.0*sin(B6 + off_TH4)*(cos(B3 + off_TH2)*sin(B2 + off_TH1)*sin(B5 + off_TH3) + cos(B5 + off_TH3)*sin(B2 + off_TH1)*sin(B3 + off_TH2)) - 57.5*cos(B3 + off_TH2)*sin(B2 + off_TH1)*sin(B5 + off_TH3) - 57.5*cos(B5 + off_TH3)*sin(B2 + off_TH1)*sin(B3 + off_TH2);
        
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
