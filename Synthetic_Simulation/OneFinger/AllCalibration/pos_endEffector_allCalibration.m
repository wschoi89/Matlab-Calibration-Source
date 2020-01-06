function output = pos_endEffector_onlyDH_lengthCalibration(parameter_input, data)
% INPUT
% first parameter  : sensor offset�� initial value
% second parameter : simulation data �� 

off_TH1=parameter_input(1);off_TH2=parameter_input(2);off_TH3=parameter_input(3);off_TH4=parameter_input(4);
A1 = parameter_input(5); B1 = parameter_input(15); C1 = parameter_input(6); D1 = parameter_input(16);
A2 = parameter_input(7);                           C2 = parameter_input(8); D2 = parameter_input(17);
A3 = parameter_input(9);                           C3 = parameter_input(10); D3 = parameter_input(18);
A5 = parameter_input(11);                           C5 = parameter_input(12); D5 = parameter_input(19);
A6 = parameter_input(13);                           C6 = parameter_input(14);D6 = parameter_input(20);

pos_reference = data(:, 12:14);
        
    for i=1:size(data, 1)
        
        B2 = data(i,1);B3 = data(i,2);B5 = data(i,3);B6 = data(i,4);
                
        diff_x=A5*(cos(D3)*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + cos(B3 + off_TH2)*sin(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) + sin(B3 + off_TH2)*sin(D3)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))) - 37.0*sin(D6)*(cos(D5)*(cos(D3)*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + cos(B3 + off_TH2)*sin(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) + sin(B3 + off_TH2)*sin(D3)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))) + sin(B5 + off_TH3)*sin(D5)*(cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*sin(D3)*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))) + cos(B5 + off_TH3)*sin(D5)*(sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1)))) + C1*cos(B1) + A3*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + A6*(cos(D5)*(cos(D3)*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + cos(B3 + off_TH2)*sin(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) + sin(B3 + off_TH2)*sin(D3)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))) + sin(B5 + off_TH3)*sin(D5)*(cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*sin(D3)*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))) + cos(B5 + off_TH3)*sin(D5)*(sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1)))) - 12.94*sin(D3)*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + cos(B3 + off_TH2)*(C3 + 56.03)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1)) - 1.0*sin(B6 + off_TH4)*(C6 + 17.25)*(sin(B5 + off_TH3)*cos(D5)*(cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*sin(D3)*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))) - 1.0*sin(D5)*(cos(D3)*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + cos(B3 + off_TH2)*sin(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) + sin(B3 + off_TH2)*sin(D3)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))) + cos(B5 + off_TH3)*cos(D5)*(sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1)))) - 1.0*cos(B6 + off_TH4)*(sin(B5 + off_TH3)*(sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))) - 1.0*cos(B5 + off_TH3)*(cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*sin(D3)*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))))*(C6 + 17.25) - 1.0*sin(B5 + off_TH3)*(C5 + 57.5)*(sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))) + 12.94*cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) + cos(B2 + off_TH1)*cos(B1)*(C2 + 24.21) + cos(B5 + off_TH3)*(C5 + 57.5)*(cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*sin(D3)*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))) + 12.94*sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1)) + 37.0*cos(B6 + off_TH4)*cos(D6)*(sin(B5 + off_TH3)*cos(D5)*(cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*sin(D3)*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))) - 1.0*sin(D5)*(cos(D3)*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + cos(B3 + off_TH2)*sin(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) + sin(B3 + off_TH2)*sin(D3)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))) + cos(B5 + off_TH3)*cos(D5)*(sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1)))) + A2*sin(D1 - 1.5708)*sin(B1) - 1.0*sin(B3 + off_TH2)*(C3 + 56.03)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 37.0*sin(B6 + off_TH4)*cos(D6)*(sin(B5 + off_TH3)*(sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1))) - 1.0*cos(B5 + off_TH3)*(cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) - 1.0*sin(D1 - 1.5708)*sin(D2 + 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(B1)) - 1.0*sin(D3)*(sin(D2 + 1.5708)*sin(B2 + off_TH1)*cos(B1) + cos(D2 + 1.5708)*sin(D1 - 1.5708)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*sin(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*cos(B1) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1)))) - 1.0*cos(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B1)*(C2 + 24.21);
        diff_y=12.94*sin(D3)*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) + A6*(cos(D5)*(sin(B3 + off_TH2)*sin(D3)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) - 1.0*cos(D3)*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) + cos(B3 + off_TH2)*sin(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))) - cos(B5 + off_TH3)*sin(D5)*(1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) - sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))) + sin(B5 + off_TH3)*sin(D5)*(sin(D3)*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) + cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1)))) + A5*(sin(B3 + off_TH2)*sin(D3)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) - 1.0*cos(D3)*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) + cos(B3 + off_TH2)*sin(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))) + C1*sin(B1) - 1.0*A3*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) - 37.0*sin(D6)*(cos(D5)*(sin(B3 + off_TH2)*sin(D3)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) - 1.0*cos(D3)*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) + cos(B3 + off_TH2)*sin(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))) - cos(B5 + off_TH3)*sin(D5)*(1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) - sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))) + sin(B5 + off_TH3)*sin(D5)*(sin(D3)*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) + cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1)))) + 1.0*sin(B5 + off_TH3)*(C5 + 57.5)*(1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) - sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))) + cos(B5 + off_TH3)*(C5 + 57.5)*(sin(D3)*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) + cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))) - 37.0*cos(B6 + off_TH4)*cos(D6)*(1.0*sin(D5)*(sin(B3 + off_TH2)*sin(D3)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) - 1.0*cos(D3)*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) + cos(B3 + off_TH2)*sin(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))) + cos(B5 + off_TH3)*cos(D5)*(1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) - sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))) - sin(B5 + off_TH3)*cos(D5)*(sin(D3)*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) + cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1)))) + 37.0*sin(B6 + off_TH4)*cos(D6)*(sin(B5 + off_TH3)*(1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) - sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))) + 1.0*cos(B5 + off_TH3)*(sin(D3)*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) + cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1)))) + 12.94*sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) + 12.94*cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1)) + 1.0*cos(B6 + off_TH4)*(sin(B5 + off_TH3)*(1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) - sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))) + 1.0*cos(B5 + off_TH3)*(sin(D3)*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) + cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))))*(C6 + 17.25) + 1.0*sin(B6 + off_TH4)*(C6 + 17.25)*(1.0*sin(D5)*(sin(B3 + off_TH2)*sin(D3)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) - 1.0*cos(D3)*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) + cos(B3 + off_TH2)*sin(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))) + cos(B5 + off_TH3)*cos(D5)*(1.0*cos(B3 + off_TH2)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) - sin(B3 + off_TH2)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1))) - sin(B5 + off_TH3)*cos(D5)*(sin(D3)*(cos(D2 + 1.5708)*sin(D1 - 1.5708)*cos(B1) - 1.0*sin(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*cos(B2 + off_TH1)*sin(D2 + 1.5708)*cos(B1)) + sin(B3 + off_TH2)*cos(D3)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) + cos(B3 + off_TH2)*cos(D3)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1)))) + cos(B2 + off_TH1)*sin(B1)*(C2 + 24.21) - 1.0*A2*sin(D1 - 1.5708)*cos(B1) + cos(B3 + off_TH2)*(C3 + 56.03)*(cos(B2 + off_TH1)*sin(B1) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)) - 1.0*sin(B3 + off_TH2)*(C3 + 56.03)*(cos(D2 + 1.5708)*sin(B2 + off_TH1)*sin(B1) + sin(D1 - 1.5708)*sin(D2 + 1.5708)*cos(B1) - 1.0*cos(D1 - 1.5708)*cos(D2 + 1.5708)*cos(B2 + off_TH1)*cos(B1)) + cos(D1 - 1.5708)*sin(B2 + off_TH1)*cos(B1)*(C2 + 24.21);
        diff_z=A1 + A2*cos(D1 - 1.5708) + A3*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) - 1.0*A6*(cos(B5 + off_TH3)*sin(D5)*(sin(B3 + off_TH2)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) + cos(B3 + off_TH2)*sin(D1 - 1.5708)*sin(B2 + off_TH1)) - 1.0*cos(D5)*(cos(D3)*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) - 1.0*cos(B3 + off_TH2)*sin(D3)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) + sin(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B3 + off_TH2)*sin(D3)) + sin(B5 + off_TH3)*sin(D5)*(sin(D3)*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) + cos(B3 + off_TH2)*cos(D3)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) - 1.0*sin(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B3 + off_TH2)*cos(D3))) + A5*(cos(D3)*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) - 1.0*cos(B3 + off_TH2)*sin(D3)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) + sin(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B3 + off_TH2)*sin(D3)) - 12.94*sin(D3)*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) + 37.0*sin(D6)*(cos(B5 + off_TH3)*sin(D5)*(sin(B3 + off_TH2)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) + cos(B3 + off_TH2)*sin(D1 - 1.5708)*sin(B2 + off_TH1)) - 1.0*cos(D5)*(cos(D3)*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) - 1.0*cos(B3 + off_TH2)*sin(D3)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) + sin(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B3 + off_TH2)*sin(D3)) + sin(B5 + off_TH3)*sin(D5)*(sin(D3)*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) + cos(B3 + off_TH2)*cos(D3)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) - 1.0*sin(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B3 + off_TH2)*cos(D3))) + 37.0*sin(B6 + off_TH4)*cos(D6)*(1.0*sin(B5 + off_TH3)*(sin(B3 + off_TH2)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) + cos(B3 + off_TH2)*sin(D1 - 1.5708)*sin(B2 + off_TH1)) - cos(B5 + off_TH3)*(sin(D3)*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) + cos(B3 + off_TH2)*cos(D3)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) - 1.0*sin(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B3 + off_TH2)*cos(D3))) + 1.0*cos(B6 + off_TH4)*(1.0*sin(B5 + off_TH3)*(sin(B3 + off_TH2)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) + cos(B3 + off_TH2)*sin(D1 - 1.5708)*sin(B2 + off_TH1)) - cos(B5 + off_TH3)*(sin(D3)*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) + cos(B3 + off_TH2)*cos(D3)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) - 1.0*sin(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B3 + off_TH2)*cos(D3)))*(C6 + 17.25) + sin(B6 + off_TH4)*(C6 + 17.25)*(sin(D5)*(cos(D3)*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) - 1.0*cos(B3 + off_TH2)*sin(D3)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) + sin(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B3 + off_TH2)*sin(D3)) + sin(B5 + off_TH3)*cos(D5)*(sin(D3)*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) + cos(B3 + off_TH2)*cos(D3)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) - 1.0*sin(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B3 + off_TH2)*cos(D3)) + cos(B5 + off_TH3)*cos(D5)*(sin(B3 + off_TH2)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) + cos(B3 + off_TH2)*sin(D1 - 1.5708)*sin(B2 + off_TH1))) + sin(B3 + off_TH2)*(C3 + 56.03)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) + sin(D1 - 1.5708)*sin(B2 + off_TH1)*(C2 + 24.21) + sin(B5 + off_TH3)*(C5 + 57.5)*(sin(B3 + off_TH2)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) + cos(B3 + off_TH2)*sin(D1 - 1.5708)*sin(B2 + off_TH1)) - 1.0*cos(B5 + off_TH3)*(C5 + 57.5)*(sin(D3)*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) + cos(B3 + off_TH2)*cos(D3)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) - 1.0*sin(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B3 + off_TH2)*cos(D3)) - 12.94*cos(B3 + off_TH2)*cos(D3)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) - 37.0*cos(B6 + off_TH4)*cos(D6)*(sin(D5)*(cos(D3)*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) - 1.0*cos(B3 + off_TH2)*sin(D3)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) + sin(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B3 + off_TH2)*sin(D3)) + sin(B5 + off_TH3)*cos(D5)*(sin(D3)*(cos(D1 - 1.5708)*cos(D2 + 1.5708) - 1.0*cos(B2 + off_TH1)*sin(D1 - 1.5708)*sin(D2 + 1.5708)) + cos(B3 + off_TH2)*cos(D3)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) - 1.0*sin(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B3 + off_TH2)*cos(D3)) + cos(B5 + off_TH3)*cos(D5)*(sin(B3 + off_TH2)*(cos(D1 - 1.5708)*sin(D2 + 1.5708) + cos(D2 + 1.5708)*cos(B2 + off_TH1)*sin(D1 - 1.5708)) + cos(B3 + off_TH2)*sin(D1 - 1.5708)*sin(B2 + off_TH1))) + 12.94*sin(D1 - 1.5708)*sin(B2 + off_TH1)*sin(B3 + off_TH2)*cos(D3) + cos(B3 + off_TH2)*sin(D1 - 1.5708)*sin(B2 + off_TH1)*(C3 + 56.03);
        
        
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
