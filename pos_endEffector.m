function output = pos_endEffector(parameter_input, data)
% INPUT
% first parameter : sensor offset의 initial value 
% second parameter : simulation data 값 

%pos_frame5 으로 test중 
% output = (56.03*cos(x(1)*pi/180)+24.21-(79.388))^2 + ((-56.03*sin(x(1)*pi/180))-(-9.729))^2;
    
    % initialize output as zero.
    parameter_input= parameter_input*pi/180;
    output = 0;
    off_TH1 = 10; off_TH1 = off_TH1*pi/180;
    off_TH2 = 10; off_TH2 = off_TH2*pi/180;
    off_TH3 = 10; off_TH3 = off_TH3*pi/180;
    off_TH4 = 10; off_TH4 = off_TH4*pi/180;
    
    %data(i, 1), data(i, 2) 10도 
    for i=1:size(data, 1)
        diff_x = 56.03*cos(data(i,1) + off_TH1) + 37.0*sin(data(i,4) + off_TH4)*(cos(data(i,1) + off_TH1)*cos(data(i,2) + off_TH2)*cos(data(i,3) + off_TH3) - 1.0*cos(data(i,1) + off_TH1)*sin(data(i,2) + off_TH2)*sin(data(i,3) + off_TH3)) + 12.94*cos(data(i,1) + off_TH1)*cos(data(i,2) + off_TH2) + 57.5*cos(data(i,1) + off_TH1)*sin(data(i,2) + off_TH2) + 37.0*cos(data(i,4) + off_TH4)*(cos(data(i,1) + off_TH1)*cos(data(i,2) + off_TH2)*sin(data(i,3) + off_TH3) + cos(data(i,1) + off_TH1)*cos(data(i,3) + off_TH3)*sin(data(i,2) + off_TH2)) + 17.25*cos(data(i,1) + off_TH1)*cos(data(i,2) + off_TH2)*sin(data(i,3) + off_TH3) + 17.25*cos(data(i,1) + off_TH1)*cos(data(i,3) + off_TH3)*sin(data(i,2) + off_TH2) + 24.21;
        ref_x  = 56.03*cos(data(i,1) + parameter_input(1)) + 37.0*sin(data(i,4) + parameter_input(4))*(cos(data(i,1) + parameter_input(1))*cos(data(i,2) + parameter_input(2))*cos(data(i,3) + parameter_input(3)) - 1.0*cos(data(i,1) + parameter_input(1))*sin(data(i,2) + parameter_input(2))*sin(data(i,3) + parameter_input(3))) + 12.94*cos(data(i,1) + parameter_input(1))*cos(data(i,2) + parameter_input(2)) + 57.5*cos(data(i,1) + parameter_input(1))*sin(data(i,2) + parameter_input(2)) + 37.0*cos(data(i,4) + parameter_input(4))*(cos(data(i,1) + parameter_input(1))*cos(data(i,2) + parameter_input(2))*sin(data(i,3) + parameter_input(3)) + cos(data(i,1) + parameter_input(1))*cos(data(i,3) + parameter_input(3))*sin(data(i,2) + parameter_input(2))) + 17.25*cos(data(i,1) + parameter_input(1))*cos(data(i,2) + parameter_input(2))*sin(data(i,3) + parameter_input(3)) + 17.25*cos(data(i,1) + parameter_input(1))*cos(data(i,3) + parameter_input(3))*sin(data(i,2) + parameter_input(2)) + 24.21;

        diff_y = 12.94*sin(data(i,2) + off_TH2) - 57.5*cos(data(i,2) + off_TH2) - 37.0*cos(data(i,4) + off_TH4)*(cos(data(i,2) + off_TH2)*cos(data(i,3) + off_TH3) - 1.0*sin(data(i,2) + off_TH2)*sin(data(i,3) + off_TH3)) - 17.25*cos(data(i,2) + off_TH2)*cos(data(i,3) + off_TH3) + 17.25*sin(data(i,2) + off_TH2)*sin(data(i,3) + off_TH3) + 37.0*sin(data(i,4) + off_TH4)*(cos(data(i,2) + off_TH2)*sin(data(i,3) + off_TH3) + cos(data(i,3) + off_TH3)*sin(data(i,2) + off_TH2));
        ref_y  = 12.94*sin(data(i,2) + parameter_input(2)) - 57.5*cos(data(i,2) + parameter_input(2)) - 37.0*cos(data(i,4) + parameter_input(4))*(cos(data(i,2) + parameter_input(2))*cos(data(i,3) + parameter_input(3)) - 1.0*sin(data(i,2) + parameter_input(2))*sin(data(i,3) + parameter_input(3))) - 17.25*cos(data(i,2) + parameter_input(2))*cos(data(i,3) + parameter_input(3)) + 17.25*sin(data(i,2) + parameter_input(2))*sin(data(i,3) + parameter_input(3)) + 37.0*sin(data(i,4) + parameter_input(4))*(cos(data(i,2) + parameter_input(2))*sin(data(i,3) + parameter_input(3)) + cos(data(i,3) + parameter_input(3))*sin(data(i,2) + parameter_input(2)));

        diff_z = -56.03*sin(data(i,1) + off_TH1) - 37.0*sin(data(i,4) + off_TH4)*(cos(data(i,2) + off_TH2)*cos(data(i,3) + off_TH3)*sin(data(i,1) + off_TH1) - 1.0*sin(data(i,1) + off_TH1)*sin(data(i,2) + off_TH2)*sin(data(i,3) + off_TH3)) - 12.94*cos(data(i,2) + off_TH2)*sin(data(i,1) + off_TH1) - 57.5*sin(data(i,1) + off_TH1)*sin(data(i,2) + off_TH2) - 37.0*cos(data(i,4) + off_TH4)*(cos(data(i,2) + off_TH2)*sin(data(i,1) + off_TH1)*sin(data(i,3) + off_TH3) + cos(data(i,3) + off_TH3)*sin(data(i,1) + off_TH1)*sin(data(i,2) + off_TH2)) - 17.25*cos(data(i,2) + off_TH2)*sin(data(i,1) + off_TH1)*sin(data(i,3) + off_TH3) - 17.25*cos(data(i,3) + off_TH3)*sin(data(i,1) + off_TH1)*sin(data(i,2) + off_TH2);
        ref_z  = -56.03*sin(data(i,1) + parameter_input(1)) - 37.0*sin(data(i,4) + parameter_input(4))*(cos(data(i,2) + parameter_input(2))*cos(data(i,3) + parameter_input(3))*sin(data(i,1) + parameter_input(1)) - 1.0*sin(data(i,1) + parameter_input(1))*sin(data(i,2) + parameter_input(2))*sin(data(i,3) + parameter_input(3))) - 12.94*cos(data(i,2) + parameter_input(2))*sin(data(i,1) + parameter_input(1)) - 57.5*sin(data(i,1) + parameter_input(1))*sin(data(i,2) + parameter_input(2)) - 37.0*cos(data(i,4) + parameter_input(4))*(cos(data(i,2) + parameter_input(2))*sin(data(i,1) + parameter_input(1))*sin(data(i,3) + parameter_input(3)) + cos(data(i,3) + parameter_input(3))*sin(data(i,1) + parameter_input(1))*sin(data(i,2) + parameter_input(2))) - 17.25*cos(data(i,2) + parameter_input(2))*sin(data(i,1) + parameter_input(1))*sin(data(i,3) + parameter_input(3)) - 17.25*cos(data(i,3) + parameter_input(3))*sin(data(i,1) + parameter_input(1))*sin(data(i,2) + parameter_input(2));
        output = output + (diff_x-ref_x )^2+(diff_y-ref_y)^2+(diff_z-ref_z)^2;
        
    end
    
%     disp(strcat(["output: ", output]))

   

end

