syms theta1 theta2 theta3 theta4 bx by bz a b c;
% b = [bx; by; bz];
sensor = [a; b; c];
rollpitch = rotx(theta3) * roty(theta4) * sensor
% pitchroll = roty(-theta1) * rotx(-theta2) * sensor