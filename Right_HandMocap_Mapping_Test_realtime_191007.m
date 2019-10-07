%%

clear
clc

% data4=csvread('Simulation_Right02_191004.csv');
%load Calibrated DH parameters
DH_json = jsondecode(fileread('DH_parameters.json'));
DHoffset = reshape(DH_json.DH_offset, 23, 3);
%load device angle offset
offsetFileName = 'offdata_right.txt';
fileID = fopen(offsetFileName, 'r');
format = '%f';
offset = fscanf(fileID, format);
fclose(fileID);

off_TH1 = 0;
off_TH2 = offset(1, 1);
off_TH3 = offset(2, 1);
off_TH4 = 0;

off_TH1_MI = 0;
off_TH2_MI = offset(3, 1);
off_TH3_MI = offset(4, 1);
off_TH4_MI = 0;

off_TH1_TH = 0;
off_TH2_TH = offset(5, 1);
off_TH3_TH = offset(6, 1);
off_TH4_TH = 0;

%thumb, index, middle finger number 
T1=1;
T2=0;
I1=2;
I2=3;
M1=4;
M2=5;

% %% Link Length_181114 Fingertip 수정
l1=24.2;
l2=56.03;
l3=12.94;
l4=47.5;
l5=19.5;
% l6=22.96;
l6 = 24.90;
l7=-10.42;
l8=16.61;

l1_TH=24.2;
l2_TH=56.03;
l3_TH=12.94;
l4_TH=57.5;
l5_TH=19.5;
% l6_TH=24.82;
l6_TH = 27.25;
l7_TH=10.42;
l8_TH=16.61;

l1_MI=24.2;
l2_MI=56.03;
l3_MI=12.94;
l4_MI=47.5;
l5_MI=19.5;
% l6_MI=22.93;
l6_MI = 24.19;
l7_MI=-10.42;
l8_MI=16.61;

%% connect serial port 

%close existing memory of port object
if ~isempty(instrfind)
     fclose(instrfind);
      delete(instrfind);
end

%data length, prefix, postfix
length_protocol = 46;
hex_prefix = 64;
hex_postfix = 255;

%open serial port
ser = serial('COM4');
ser.Baudrate = 115200;
fopen(ser);

%assign the size of data
data = zeros(length_protocol, 1);
   

while(true)
    %read first byte and check whether it is same with the prefix byte
    first_byte = fread(ser, 1);    
    %check first byte
    if first_byte == hex_prefix
        remain_byte = fread(ser, length_protocol - 1);

        %check last byte
        if remain_byte(end) == hex_postfix
            data = [first_byte;remain_byte];
            break;
        end
    end
end

%parsing sensor data (6sensors, 7bytes for each sensor)
% 왼손
% sensor 1: 중지 말단
% sensor 2: 중지 손등
% sensor 3: 검지 손등
% sensor 4: 검지 말단
% sensor 5: 엄지 손등
% sensor 6: 엄지 말단 

sensor1 = data(4:10);
sensor2 = data(11:17);
sensor3 = data(18:24);
sensor4 = data(25:31);
sensor5 = data(32:38);
sensor6 = data(39:45);
sensor_data = {sensor1, sensor2, sensor3, sensor4, sensor5, sensor6};

bx = cell(1, 6);
by = cell(1, 6);
bz = cell(1, 6);

[bx{1}, by{1}, bz{1}] = getMagneticValue(sensor1);
[bx{2}, by{2}, bz{2}] = getMagneticValue(sensor2);
[bx{3}, by{3}, bz{3}] = getMagneticValue(sensor3);
[bx{4}, by{4}, bz{4}] = getMagneticValue(sensor4);
[bx{5}, by{5}, bz{5}] = getMagneticValue(sensor5);
[bx{6}, by{6}, bz{6}] = getMagneticValue(sensor6);

% data4=csvread('Simulation_Right02_191004.csv');
M = zeros(1, 18);
for i=1:6
    M(1, 3*(i-1)+1) = bx{i};
    M(1, 3*(i-1)+2) = by{i};
    M(1, 3*(i-1)+3) = bz{i};
end

% M=size(data4);
data4 = M;

Matout=zeros(M(1,1),8);

figure;
axis([-250 250 -150 150 -150 150]);
view([172, -44])
hold on
% axis('equal')

Origin=[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];%% initial values
% Origin_TH=Origin*transl(-86.71,-28.55,22.75)*trotz(24*pi/180)*trotx(-75*pi/180)*troty(54*pi/180)*trotz(45*pi/180);%% initial values
Origin_TH=Origin*transl(-88.75,-29.04,-24.35)*trotz(24*pi/180)*trotx(-75*pi/180)*troty(54*pi/180)*trotz(45*pi/180);%% initial values
% Origin_THParam=[-88.75 -29.04 -24.35 asin(-Origin_TH(2,3)/cos(asin(Origin_TH(1,3)))) asin(Origin_TH(1,3)) asin(-Origin_TH(1,2)/cos(asin(Origin_TH(1,3))))];
Origin_MI=Origin*transl(0,0,19);%% initial values

Link1_1=Origin*transl(-37,0,-15);
Link1_2=Origin*transl(-37,0,15);
plot3([Origin(1,4) Link1_1(1,4)],[Origin(2,4) Link1_1(2,4)],[Origin(3,4) Link1_1(3,4)],'b-');
plot3([Link1_2(1,4) Link1_1(1,4)],[Link1_2(2,4) Link1_1(2,4)],[Link1_2(3,4) Link1_1(3,4)],'b-');
plot3([Origin(1,4) Link1_2(1,4)],[Origin(2,4) Link1_2(2,4)],[Origin(3,4) Link1_2(3,4)],'b-');
Link2_1=Origin_TH*transl(-37,0,-15);
Link2_2=Origin_TH*transl(-37,0,15);
plot3([Origin_TH(1,4) Link2_1(1,4)],[Origin_TH(2,4) Link2_1(2,4)],[Origin_TH(3,4) Link2_1(3,4)],'b-');
plot3([Link2_2(1,4) Link2_1(1,4)],[Link2_2(2,4) Link2_1(2,4)],[Link2_2(3,4) Link2_1(3,4)],'b-');
plot3([Origin_TH(1,4) Link2_2(1,4)],[Origin_TH(2,4) Link2_2(2,4)],[Origin_TH(3,4) Link2_2(3,4)],'b-');
Link3_1=Origin_MI*transl(-37,0,-15);
Link3_2=Origin_MI*transl(-37,0,15);
plot3([Origin_MI(1,4) Link3_1(1,4)],[Origin_MI(2,4) Link3_1(2,4)],[Origin_MI(3,4) Link3_1(3,4)],'b-');
plot3([Link3_2(1,4) Link3_1(1,4)],[Link3_2(2,4) Link3_1(2,4)],[Link3_2(3,4) Link3_1(3,4)],'b-');
plot3([Origin_MI(1,4) Link3_2(1,4)],[Origin_MI(2,4) Link3_2(2,4)],[Origin_MI(3,4) Link3_2(3,4)],'b-');

alpha=0;
beta=0;
gamma=1;

%% Initialization - Middle

iter=1;
mag=sqrt(data4(iter,M1*3+1)^2+data4(iter,M1*3+2)^2+data4(iter,M1*3+3)^2);
a=data4(iter,M1*3+1)/mag;
b=data4(iter,M1*3+2)/mag;

X=atan2(gamma,alpha);
if alpha*alpha+gamma*gamma-a*a>0
    TH1_MI(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
else
    TH1_MI(iter)=atan2(0,a)-X;
end

if TH1_MI(iter)>pi/2
    TH1_MI(iter)=pi/2;
elseif TH1_MI(iter)<-pi/2
    TH1_MI(iter)=-pi/2;
end
    
Y(iter)=sin(TH1_MI(iter))*alpha+cos(TH1_MI(iter))*gamma;
if Y(iter)*Y(iter)+beta*beta-b*b<0
    TH2_MI(iter)=atan2(b,0)-atan2(beta,Y(iter));
else
    TH2_MI(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
end

if TH2_MI(iter)>pi/2
    TH2_MI(iter)=pi/2;
elseif TH2_MI(iter)<-pi/2
    TH2_MI(iter)=-pi/2;
end
    
mag=sqrt(data4(iter,M2*3+1)^2+data4(iter,M2*3+2)^2+data4(iter,M2*3+3)^2);
a=data4(iter,M2*3+1)/mag;
b=data4(iter,M2*3+2)/mag;

X=atan2(alpha,gamma);
if alpha*alpha+gamma*gamma-a*a>0
    TH4_MI(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
else
    TH4_MI(iter)=atan2(a,0)-X;
end

if TH4_MI(iter)>pi/2
    TH4_MI(iter)=pi/2;
elseif TH4_MI(iter)<-pi/2
    TH4_MI(iter)=-pi/2;
end


Y(iter)=-sin(TH4_MI(iter))*alpha+cos(TH4_MI(iter))*gamma;
if Y(iter) == 0
    Y(iter)=0.00001;
end
if Y(iter)*Y(iter)+beta*beta-b*b<0
    TH3_MI(iter)=atan2(0,b)-atan2(Y(iter),beta);
else
    TH3_MI(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
    compare=atan2(abs(cos(TH3_MI(iter))*cos(TH4_MI(iter))),b)-atan2(Y(iter),beta);
end

if TH3_MI(iter)>pi/2
    TH3_MI(iter)=pi/2;
elseif TH3_MI(iter)<-pi/2
    TH3_MI(iter)=-pi/2;
end

TH4_MI(iter)=TH4_MI(iter)+pi/4;

TH1_MI(iter)=TH1_MI(iter)-off_TH1_MI;
TH2_MI(iter)=TH2_MI(iter)-off_TH2_MI;
TH3_MI(iter)=TH3_MI(iter)-off_TH3_MI;
TH4_MI(iter)=TH4_MI(iter)-off_TH4_MI;

% DH_MI=[0 0 0 -pi/2; 0 TH1_MI(iter) l1_MI pi/2; 0 TH2_MI(iter) l2_MI 0; 0 -pi/2 l3_MI 0; 0 TH3_MI(iter) l4_MI 0; 0 TH4_MI(iter) l5_MI 0; 0 -pi/2 l6_MI 0; 0 pi/2 20.46 0];
DH_MI=[DHoffset(1,3) DHoffset(2,3) DHoffset(3,3) DHoffset(4,3); DHoffset(5,3) TH1_MI(iter) DHoffset(6,3) DHoffset(7,3); DHoffset(8,3) TH2_MI(iter) l2_MI 0; 0 -pi/2 l3_MI DHoffset(9,3); DHoffset(10,3) TH3_MI(iter) DHoffset(11,3) DHoffset(12,3); DHoffset(13,3) TH4_MI(iter) l5_MI 0; DHoffset(14,3) DHoffset(15,3) DHoffset(16,3) DHoffset(17,3); 0 pi/2 20.65 0];

R01_MI=transl(0,0,DH_MI(1,1))*trotz(DH_MI(1,2))*transl(DH_MI(1,3),0,0)*trotx(DH_MI(1,4));
R12_MI=transl(0,0,DH_MI(2,1))*trotz(DH_MI(2,2))*transl(DH_MI(2,3),0,0)*trotx(DH_MI(2,4));
R23_MI=transl(0,0,DH_MI(3,1))*trotz(DH_MI(3,2))*transl(DH_MI(3,3),0,0)*trotx(DH_MI(3,4));
R34_MI=transl(0,0,DH_MI(4,1))*trotz(DH_MI(4,2))*transl(DH_MI(4,3),0,0)*trotx(DH_MI(4,4));
R45_MI=transl(0,0,DH_MI(5,1))*trotz(DH_MI(5,2))*transl(DH_MI(5,3),0,0)*trotx(DH_MI(5,4));
R56_MI=transl(0,0,DH_MI(6,1))*trotz(DH_MI(6,2))*transl(DH_MI(6,3),0,0)*trotx(DH_MI(6,4));
R67_MI=transl(0,0,DH_MI(7,1))*trotz(DH_MI(7,2))*transl(DH_MI(7,3),0,0)*trotx(DH_MI(7,4));
R78_MI=transl(0,0,DH_MI(8,1))*trotz(DH_MI(8,2))*transl(DH_MI(8,3),0,0)*trotx(DH_MI(8,4));

R1_MI=Origin_MI*R01_MI*R12_MI;
Joint1_MI=[R1_MI(1,4); R1_MI(2,4); R1_MI(3,4)];
R2_MI=R1_MI*R23_MI;
Joint2_MI=[R2_MI(1,4); R2_MI(2,4); R2_MI(3,4)];
R3_MI=R2_MI*R34_MI;
Joint3_MI=[R3_MI(1,4); R3_MI(2,4); R3_MI(3,4)];
R4_MI=R3_MI*R45_MI;
Joint4_MI=[R4_MI(1,4); R4_MI(2,4); R4_MI(3,4)];
R5_MI=R4_MI*R56_MI;
Joint5_MI=[R5_MI(1,4); R5_MI(2,4); R5_MI(3,4)];
R6_MI=R5_MI*R67_MI;
Joint6_MI=[R6_MI(1,4); R6_MI(2,4); R6_MI(3,4)];
R7_MI=R6_MI*R78_MI;
Joint7_MI=[R7_MI(1,4); R7_MI(2,4); R7_MI(3,4)];

% fourth option
FingerOrigin_MI=eye(4)*transl(Joint7_MI(1)-117.581,Joint7_MI(2),Joint7_MI(3))*troty(pi/2);
Fingeroffset_MI=acos(R7_MI(2,1))-pi/2;
FingerLength_MI = 117.581*0.95;
scale3 = FingerLength_MI/117.581;

L1_MI = 60.007*scale3;
L2_MI = 36.638*scale3;
L3_MI = 20.936*scale3;

%% Initialization - Index
mag=sqrt(data4(iter,I1*3+1)^2+data4(iter,I1*3+2)^2+data4(iter,I1*3+3)^2);
a=data4(iter,I1*3+1)/mag;
b=data4(iter,I1*3+2)/mag;

X=atan2(gamma,alpha);
if alpha*alpha+gamma*gamma-a*a>0
    TH1(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
else
    TH1(iter)=atan2(0,a)-X;
end

if TH1(iter)>pi/2
    TH1(iter)=pi/2;
elseif TH1(iter)<-pi/2
    TH1(iter)=-pi/2;
end

Y(iter)=-sin(TH1(iter))*alpha+cos(TH1(iter))*gamma;
if Y(iter)*Y(iter)+beta*beta-b*b<0
    TH2(iter)=atan2(b,0)-atan2(beta,Y(iter));
else
    TH2(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
end

if TH2(iter)>pi/2
    TH2(iter)=pi/2;
elseif TH2(iter)<-pi/2
    TH2(iter)=-pi/2;
end

mag=sqrt(data4(iter,I2*3+1)^2+data4(iter,I2*3+2)^2+data4(iter,I2*3+3)^2);
a=data4(iter,I2*3+1)/mag;
b=data4(iter,I2*3+2)/mag;

X=atan2(alpha,gamma);
if alpha*alpha+gamma*gamma-a*a>0
    TH4(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
else
    TH4(iter)=atan2(a,0)-X;
end

if TH4(iter)>pi/2
    TH4(iter)=pi/2;
elseif TH4(iter)<-pi/2
    TH4(iter)=-pi/2;
end


Y(iter)=-sin(TH4(iter))*alpha+cos(TH4(iter))*gamma;
if Y(iter) == 0
    Y(iter)=0.00001;
end
if Y(iter)*Y(iter)+beta*beta-b*b<0
    TH3(iter)=atan2(0,b)-atan2(Y(iter),beta);
else
    TH3(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
end

if TH3(iter)>pi/2
    TH3(iter)=pi/2;
elseif TH3(iter)<-pi/2
    TH3(iter)=-pi/2;
end

TH4(iter)=TH4(iter)+pi/4;

TH1(iter)=TH1(iter)-off_TH1;
TH2(iter)=TH2(iter)-off_TH2;
TH3(iter)=TH3(iter)-off_TH3;
TH4(iter)=TH4(iter)-off_TH4;

% DH=[0 0 0 -pi/2; 0 TH1(iter) l1 pi/2; 0 TH2(iter) l2 0; 0 -pi/2 l3 0; 0 TH3(iter) l4 0; 0 TH4(iter) l5 0; 0 -pi/2 l6 0; 0 pi/2 20.38 0];
DH=[DHoffset(1,1) DHoffset(2,1) DHoffset(3,1) DHoffset(4,1); DHoffset(5,1) TH1(iter) DHoffset(6,1) DHoffset(7,1); DHoffset(8,1) TH2(iter) l2 0; 0 -pi/2 l3 DHoffset(9,1); DHoffset(10,1) TH3(iter) DHoffset(11,1) DHoffset(12,1); DHoffset(13,1) TH4(iter) l5 0; DHoffset(14,1) DHoffset(15,1) DHoffset(16,1) DHoffset(17,1); 0 pi/2 20.65 0];
% DH=[DHoffset(1,1) DHoffset(2,1) DHoffset(3,1) DHoffset(4,1); DHoffset(5,1) TH1(iter) DHoffset(6,1) DHoffset(7,1); DHoffset(8,1) TH2(iter) l2 0; 0 -pi/2 l3 DHoffset(9,1); DHoffset(10,1) TH3(iter) DHoffset(11,1) DHoffset(12,1); DHoffset(13,1) TH4(iter) l5 0; 0 -pi/2 DHoffset(14,1) 0; DHoffset(15,1) pi/2 DHoffset(16,1) 0];

R01=transl(0,0,DH(1,1))*trotz(DH(1,2))*transl(DH(1,3),0,0)*trotx(DH(1,4));
R12=transl(0,0,DH(2,1))*trotz(DH(2,2))*transl(DH(2,3),0,0)*trotx(DH(2,4));
R23=transl(0,0,DH(3,1))*trotz(DH(3,2))*transl(DH(3,3),0,0)*trotx(DH(3,4));
R34=transl(0,0,DH(4,1))*trotz(DH(4,2))*transl(DH(4,3),0,0)*trotx(DH(4,4));
R45=transl(0,0,DH(5,1))*trotz(DH(5,2))*transl(DH(5,3),0,0)*trotx(DH(5,4));
R56=transl(0,0,DH(6,1))*trotz(DH(6,2))*transl(DH(6,3),0,0)*trotx(DH(6,4));
R67=transl(0,0,DH(7,1))*trotz(DH(7,2))*transl(DH(7,3),0,0)*trotx(DH(7,4));
R78=transl(0,0,DH(8,1))*trotz(DH(8,2))*transl(DH(8,3),0,0)*trotx(DH(8,4));

R1=Origin*R01*R12;
Joint1=[R1(1,4); R1(2,4); R1(3,4)];
R2=R1*R23;
Joint2=[R2(1,4); R2(2,4); R2(3,4)];
R3=R2*R34;
Joint3=[R3(1,4); R3(2,4); R3(3,4)];
R4=R3*R45;
Joint4=[R4(1,4); R4(2,4); R4(3,4)];
R5=R4*R56;
Joint5=[R5(1,4); R5(2,4); R5(3,4)];
R6=R5*R67;
Joint6=[R6(1,4); R6(2,4); R6(3,4)];
R7=R6*R78;
Joint7=[R7(1,4); R7(2,4); R7(3,4)];


% fourth option

Fingeroffset=acos(R7(2,1))-pi/2;
FingerOrigin=FingerOrigin_MI*transl(31.792*scale3,-4.864*scale3,-0.374*scale3);
FingerLength = norm(Joint7-FingerOrigin(1:3,4))*0.95;

scale2 =  FingerLength / 108.340;

L1 = 50.344 * scale2;
L2 = 32.220 * scale2;
L3 = 25.776 * scale2;



%% Initialization - Thumb
    

mag=sqrt(data4(iter,T1*3+1)^2+data4(iter,T1*3+2)^2+data4(iter,T1*3+3)^2);
a=data4(iter,T1*3+1)/mag;
b=data4(iter,T1*3+2)/mag;

X=atan2(gamma,alpha);
if alpha*alpha+gamma*gamma-a*a>0
    TH1_TH(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
else
    TH1_TH(iter)=atan2(0,a)-X;
end

if TH1_TH(iter)>pi/2
    TH1_TH(iter)=pi/2;
elseif TH1_TH(iter)<-pi/2
    TH1_TH(iter)=-pi/2;
end
    
Y(iter)=sin(TH1_TH(iter))*alpha+cos(TH1_TH(iter))*gamma;
if Y(iter)*Y(iter)+beta*beta-b*b<0
    TH2_TH(iter)=atan2(b,0)-atan2(beta,Y(iter));
else
    TH2_TH(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
end

if TH2_TH(iter)>pi/2
    TH2_TH(iter)=pi/2;
elseif TH2_TH(iter)<-pi/2
    TH2_TH(iter)=-pi/2;
end
    
mag=sqrt(data4(iter,T2*3+1)^2+data4(iter,T2*3+2)^2+data4(iter,T2*3+3)^2);
a=data4(iter,T2*3+1)/mag;
b=data4(iter,T2*3+2)/mag;

X=atan2(alpha,gamma);
if alpha*alpha+gamma*gamma-a*a>0
    TH4_TH(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
else
    TH4_TH(iter)=atan2(a,0)-X;
end

if TH4_TH(iter)>pi/2
    TH4_TH(iter)=pi/2;
elseif TH4_TH(iter)<-pi/2
    TH4_TH(iter)=-pi/2;
end


Y(iter)=-sin(TH4_TH(iter))*alpha+cos(TH4_TH(iter))*gamma;
if Y(iter) == 0
    Y(iter)=0.00001;
end
if Y(iter)*Y(iter)+beta*beta-b*b<0
    TH3_TH(iter)=atan2(0,b)-atan2(Y(iter),beta);
else
    TH3_TH(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
    compare=atan2(abs(cos(TH3_TH(iter))*cos(TH4_TH(iter))),b)-atan2(Y(iter),beta);
end

if TH3_TH(iter)>pi/2
    TH3_TH(iter)=pi/2;
elseif TH3_TH(iter)<-pi/2
    TH3_TH(iter)=-pi/2;
end

TH4_TH(iter)=TH4_TH(iter)+pi/4;

TH1_TH(iter)=TH1_TH(iter)-off_TH1_TH;
TH2_TH(iter)=TH2_TH(iter)-off_TH2_TH;
TH3_TH(iter)=TH3_TH(iter)-off_TH3_TH;
TH4_TH(iter)=TH4_TH(iter)-off_TH4_TH;

% DH_TH=[0 0 0 -pi/2; 0 TH1_TH(iter) l1_TH pi/2; 0 TH2_TH(iter) l2_TH 0; 0 -pi/2 l3_TH 0; 0 TH3_TH(iter) l4_TH 0; 0 TH4_TH(iter) l5_TH 0; 0 -pi/2 l6_TH 0; 0 pi/2 20.46 0];
DH_TH=[DHoffset(1,2) DHoffset(2,2) DHoffset(3,2) DHoffset(4,2); DHoffset(5,2) TH1_TH(iter) DHoffset(6,2) DHoffset(7,2); DHoffset(8,2) TH2_TH(iter) l2_TH 0; 0 -pi/2 l3_TH DHoffset(9,2); DHoffset(10,2) TH3_TH(iter) DHoffset(11,2) DHoffset(12,2); DHoffset(13,2) TH4_TH(iter) l5_TH 0; DHoffset(14,2) DHoffset(15,2) DHoffset(16,2) DHoffset(17,2); 0 pi/2 20.65 0];
% DH_TH=[DHoffset(1,2) DHoffset(2,2) DHoffset(3,2) DHoffset(4,2); DHoffset(5,2) TH1_TH(iter) DHoffset(6,2) DHoffset(7,2); DHoffset(8,2) TH2_TH(iter) l2_TH 0; 0 -pi/2 l3_TH DHoffset(9,2); DHoffset(10,2) TH3_TH(iter) DHoffset(11,2) DHoffset(12,2); DHoffset(13,2) TH4_TH(iter) l5_TH 0; 0 -pi/2 DHoffset(14,2) 0; DHoffset(15,2) pi/2 DHoffset(16,2) 0];

R01_TH=transl(0,0,DH_TH(1,1))*trotz(DH_TH(1,2))*transl(DH_TH(1,3),0,0)*trotx(DH_TH(1,4));
R12_TH=transl(0,0,DH_TH(2,1))*trotz(DH_TH(2,2))*transl(DH_TH(2,3),0,0)*trotx(DH_TH(2,4));
R23_TH=transl(0,0,DH_TH(3,1))*trotz(DH_TH(3,2))*transl(DH_TH(3,3),0,0)*trotx(DH_TH(3,4));
R34_TH=transl(0,0,DH_TH(4,1))*trotz(DH_TH(4,2))*transl(DH_TH(4,3),0,0)*trotx(DH_TH(4,4));
R45_TH=transl(0,0,DH_TH(5,1))*trotz(DH_TH(5,2))*transl(DH_TH(5,3),0,0)*trotx(DH_TH(5,4));
R56_TH=transl(0,0,DH_TH(6,1))*trotz(DH_TH(6,2))*transl(DH_TH(6,3),0,0)*trotx(DH_TH(6,4));
R67_TH=transl(0,0,DH_TH(7,1))*trotz(DH_TH(7,2))*transl(DH_TH(7,3),0,0)*trotx(DH_TH(7,4));
R78_TH=transl(0,0,DH_TH(8,1))*trotz(DH_TH(8,2))*transl(DH_TH(8,3),0,0)*trotx(DH_TH(8,4));

R1_TH=Origin_TH*R01_TH*R12_TH;
Joint1_TH=[R1_TH(1,4); R1_TH(2,4); R1_TH(3,4)];
R2_TH=R1_TH*R23_TH;
Joint2_TH=[R2_TH(1,4); R2_TH(2,4); R2_TH(3,4)];
R3_TH=R2_TH*R34_TH;
Joint3_TH=[R3_TH(1,4); R3_TH(2,4); R3_TH(3,4)];
R4_TH=R3_TH*R45_TH;
Joint4_TH=[R4_TH(1,4); R4_TH(2,4); R4_TH(3,4)];
R5_TH=R4_TH*R56_TH;
Joint5_TH=[R5_TH(1,4); R5_TH(2,4); R5_TH(3,4)];
R6_TH=R5_TH*R67_TH;
Joint6_TH=[R6_TH(1,4); R6_TH(2,4); R6_TH(3,4)];
R7_TH=R6_TH*R78_TH;
Joint7_TH=[R7_TH(1,4); R7_TH(2,4); R7_TH(3,4)];

% fourth option

HandOrigin=FingerOrigin(1:3,4)+[-105.484 1.282 37.7]'*scale3;

% FingerOriginLoc_TH = HandOrigin + [35.578 -26.208 -35.589]'*scale3;
FingerOriginLoc_TH = HandOrigin + [10.578 -26.208 -30.589]'*scale3;
FingerOrigin_TH=Origin_TH*trotz(-pi/4)*troty(pi/2);
FingerOrigin_TH(1:3,4)=FingerOriginLoc_TH;
FingerLength_TH = norm(Joint7_TH-FingerOrigin_TH(1:3,4))*0.80;


scale1 =  FingerLength_TH / 121.235;

L1_TH = 46.353 * scale1;
L2_TH = 40.321 * scale1;
L3_TH = 34.561 * scale1;

%% Mechanism & Finger Drawing
while(true)
    
    %read first byte and check whether it is same with the prefix byte
    first_byte = fread(ser, 1);    
    %check first byte
    if first_byte == hex_prefix
        remain_byte = fread(ser, length_protocol - 1);

        %check last byte
        if remain_byte(end) == hex_postfix
            data = [first_byte;remain_byte];
        end
    else
        continue;
    end
 

    %parsing sensor data (6sensors, 7bytes for each sensor)
    % 왼손
    % sensor 1: 중지 말단
    % sensor 2: 중지 손등
    % sensor 3: 검지 손등
    % sensor 4: 검지 말단
    % sensor 5: 엄지 손등
    % sensor 6: 엄지 말단 

    sensor1 = data(4:10);
    sensor2 = data(11:17);
    sensor3 = data(18:24);
    sensor4 = data(25:31);
    sensor5 = data(32:38);
    sensor6 = data(39:45);
    sensor_data = {sensor1, sensor2, sensor3, sensor4, sensor5, sensor6};

    bx = cell(1, 6);
    by = cell(1, 6);
    bz = cell(1, 6);

    [bx{1}, by{1}, bz{1}] = getMagneticValue(sensor1);
    [bx{2}, by{2}, bz{2}] = getMagneticValue(sensor2);
    [bx{3}, by{3}, bz{3}] = getMagneticValue(sensor3);
    [bx{4}, by{4}, bz{4}] = getMagneticValue(sensor4);
    [bx{5}, by{5}, bz{5}] = getMagneticValue(sensor5);
    [bx{6}, by{6}, bz{6}] = getMagneticValue(sensor6);

    % data4=csvread('Simulation_Right02_191004.csv');
    M = zeros(1, 18);
    for i=1:6
        M(1, 3*(i-1)+1) = bx{i};
        M(1, 3*(i-1)+2) = by{i};
        M(1, 3*(i-1)+3) = bz{i};
    end

    % M=size(data4);
    data4 = M;
    iter = 1;
%% Thumb
mag=sqrt(data4(iter,T1*3+1)^2+data4(iter,T1*3+2)^2+data4(iter,T1*3+3)^2);
a=data4(iter,T1*3+1)/mag;
b=data4(iter,T1*3+2)/mag;

X=atan2(gamma,alpha);
if alpha*alpha+gamma*gamma-a*a>0
    TH1_TH(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
else
    TH1_TH(iter)=atan2(0,a)-X;
end

if TH1_TH(iter)>pi/2
    TH1_TH(iter)=pi/2;
elseif TH1_TH(iter)<-pi/2
    TH1_TH(iter)=-pi/2;
end
    
Y(iter)=sin(TH1_TH(iter))*alpha+cos(TH1_TH(iter))*gamma;
if Y(iter)*Y(iter)+beta*beta-b*b<0
    TH2_TH(iter)=atan2(b,0)-atan2(beta,Y(iter));
else
    TH2_TH(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
end

if TH2_TH(iter)>pi/2
    TH2_TH(iter)=pi/2;
elseif TH2_TH(iter)<-pi/2
    TH2_TH(iter)=-pi/2;
end
    
mag=sqrt(data4(iter,T2*3+1)^2+data4(iter,T2*3+2)^2+data4(iter,T2*3+3)^2);
a=data4(iter,T2*3+1)/mag;
b=data4(iter,T2*3+2)/mag;

X=atan2(alpha,gamma);
if alpha*alpha+gamma*gamma-a*a>0
    TH4_TH(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
else
    TH4_TH(iter)=atan2(a,0)-X;
end

if TH4_TH(iter)>pi/2
    TH4_TH(iter)=pi/2;
elseif TH4_TH(iter)<-pi/2
    TH4_TH(iter)=-pi/2;
end


Y(iter)=-sin(TH4_TH(iter))*alpha+cos(TH4_TH(iter))*gamma;
if Y(iter) == 0
    Y(iter)=0.00001;
end
if Y(iter)*Y(iter)+beta*beta-b*b<0
    TH3_TH(iter)=atan2(0,b)-atan2(Y(iter),beta);
else
    TH3_TH(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
end

if TH3_TH(iter)>pi/2
    TH3_TH(iter)=pi/2;
elseif TH3_TH(iter)<-pi/2
    TH3_TH(iter)=-pi/2;
end

TH4_TH(iter)=TH4_TH(iter)+pi/4;

TH1_TH(iter)=TH1_TH(iter)-off_TH1_TH;
TH2_TH(iter)=TH2_TH(iter)-off_TH2_TH;
TH3_TH(iter)=TH3_TH(iter)-off_TH3_TH;
TH4_TH(iter)=TH4_TH(iter)-off_TH4_TH;

% DH_TH=[0 0 0 -pi/2; 0 TH1_TH(iter) l1_TH pi/2; 0 TH2_TH(iter) l2_TH 0; 0 -pi/2 l3_TH 0; 0 TH3_TH(iter) l4_TH 0; 0 TH4_TH(iter) l5_TH 0; 0 -pi/2 l6_TH 0; 0 pi/2 20.46 0];
DH_TH=[DHoffset(1,2) DHoffset(2,2) DHoffset(3,2) DHoffset(4,2); DHoffset(5,2) TH1_TH(iter) DHoffset(6,2) DHoffset(7,2); DHoffset(8,2) TH2_TH(iter) l2_TH 0; 0 -pi/2 l3_TH DHoffset(9,2); DHoffset(10,2) TH3_TH(iter) DHoffset(11,2) DHoffset(12,2); DHoffset(13,2) TH4_TH(iter) l5_TH 0; DHoffset(14,2) DHoffset(15,2) DHoffset(16,2) DHoffset(17,2); 0 pi/2 20.65 0];

R01_TH=transl(0,0,DH_TH(1,1))*trotz(DH_TH(1,2))*transl(DH_TH(1,3),0,0)*trotx(DH_TH(1,4));
R12_TH=transl(0,0,DH_TH(2,1))*trotz(DH_TH(2,2))*transl(DH_TH(2,3),0,0)*trotx(DH_TH(2,4));
R23_TH=transl(0,0,DH_TH(3,1))*trotz(DH_TH(3,2))*transl(DH_TH(3,3),0,0)*trotx(DH_TH(3,4));
R34_TH=transl(0,0,DH_TH(4,1))*trotz(DH_TH(4,2))*transl(DH_TH(4,3),0,0)*trotx(DH_TH(4,4));
R45_TH=transl(0,0,DH_TH(5,1))*trotz(DH_TH(5,2))*transl(DH_TH(5,3),0,0)*trotx(DH_TH(5,4));
R56_TH=transl(0,0,DH_TH(6,1))*trotz(DH_TH(6,2))*transl(DH_TH(6,3),0,0)*trotx(DH_TH(6,4));
R67_TH=transl(0,0,DH_TH(7,1))*trotz(DH_TH(7,2))*transl(DH_TH(7,3),0,0)*trotx(DH_TH(7,4));
R78_TH=transl(0,0,DH_TH(8,1))*trotz(DH_TH(8,2))*transl(DH_TH(8,3),0,0)*trotx(DH_TH(8,4));

R1_TH=Origin_TH*R01_TH*R12_TH;
Joint1_TH=[R1_TH(1,4); R1_TH(2,4); R1_TH(3,4)];
R2_TH=R1_TH*R23_TH;
Joint2_TH=[R2_TH(1,4); R2_TH(2,4); R2_TH(3,4)];
R3_TH=R2_TH*R34_TH;
Joint3_TH=[R3_TH(1,4); R3_TH(2,4); R3_TH(3,4)];
R4_TH=R3_TH*R45_TH;
Joint4_TH=[R4_TH(1,4); R4_TH(2,4); R4_TH(3,4)];
R5_TH=R4_TH*R56_TH;
Joint5_TH=[R5_TH(1,4); R5_TH(2,4); R5_TH(3,4)];
R6_TH=R5_TH*R67_TH;
Joint6_TH=[R6_TH(1,4); R6_TH(2,4); R6_TH(3,4)];
R7_TH=R6_TH*R78_TH;
Joint7_TH=[R7_TH(1,4); R7_TH(2,4); R7_TH(3,4)];

% fourth option
vec1=[R7_TH(1,4)-FingerOrigin_TH(1,4) R7_TH(2,4)-FingerOrigin_TH(2,4) R7_TH(3,4)-FingerOrigin_TH(3,4)];
vec2=[R7_TH(1,1);R7_TH(2,1);R7_TH(3,1)];
vec1=[vec1*FingerOrigin_TH(1:3,1) vec1*FingerOrigin_TH(1:3,2) vec1*FingerOrigin_TH(1:3,3)];
vec2=[vec2'*FingerOrigin_TH(1:3,1);vec2'*FingerOrigin_TH(1:3,2);vec2'*FingerOrigin_TH(1:3,3)];
norm1=sqrt(vec1(1)*vec1(1)+vec1(3)*vec1(3));
norm2=sqrt(vec2(1)*vec2(1)+vec2(3)*vec2(3));
ang = acos([vec1(1) 0 vec1(3)]*[vec2(1) 0 vec2(3)]'/norm1/norm2);
det=cross([vec1(1) 0 vec1(3)],[vec2(1) 0 vec2(3)]);

if ang < pi/2
    if det(2)>0
        newaxis=roty(-ang)*vec2;
    else
        newaxis=roty(ang)*vec2;
    end
else
    if det(2)>0
        newaxis=roty(pi-ang)*vec2;
    else
        newaxis=roty(ang-pi)*vec2;
    end
end

newaxis=[newaxis'*FingerOrigin_TH(1,1:3)' newaxis'*FingerOrigin_TH(2,1:3)' newaxis'*FingerOrigin_TH(3,1:3)']';

P0_TH=FingerOrigin_TH(1:3,4);
P3_TH=Joint7_TH;
P2_TH=Joint7_TH-newaxis*L3_TH;
L_TH=norm(P0_TH-P2_TH);
P3_af_TH=[(P3_TH(1)-FingerOrigin_TH(1,4)) P3_TH(2)-FingerOrigin_TH(2,4) P3_TH(3)-FingerOrigin_TH(3,4)];
P2_af_TH=[(P2_TH(1)-FingerOrigin_TH(1,4)) P2_TH(2)-FingerOrigin_TH(2,4) P2_TH(3)-FingerOrigin_TH(3,4)];
P3_af_TH=[P3_af_TH*FingerOrigin_TH(1:3,1) P3_af_TH*FingerOrigin_TH(1:3,2) P3_af_TH*FingerOrigin_TH(1:3,3)];
P2_af_TH=[P2_af_TH*FingerOrigin_TH(1:3,1) P2_af_TH*FingerOrigin_TH(1:3,2) P2_af_TH*FingerOrigin_TH(1:3,3)];

TH1_FTH(iter)=atan2(P2_af_TH(1),P2_af_TH(3));
P3_af_TH=(roty(-TH1_FTH(iter))*P3_af_TH')';
P2_af_TH=(roty(-TH1_FTH(iter))*P2_af_TH')';

if P3_af_TH(2)-P2_af_TH(2) > 0
    the_tot=-acos((P3_af_TH(3)-P2_af_TH(3))/L3_TH);
else
    the_tot=acos((P3_af_TH(3)-P2_af_TH(3))/L3_TH);
end

if L_TH<L1_TH+L2_TH
    theta_TH=acos((L2_TH^2+L_TH^2-L1_TH^2)/(2*L2_TH*L_TH));
    
    x=[P3_af_TH(1)-P2_af_TH(1) P3_af_TH(2)-P2_af_TH(2) P3_af_TH(3)-P2_af_TH(3)]*P2_af_TH'/L_TH/L3_TH;
    if x>1
        x=1;
    end
    theta_1=acos(x);
    
    Det_vec=cross(P2_af_TH,[P3_af_TH(1)-P2_af_TH(1) P3_af_TH(2)-P2_af_TH(2) P3_af_TH(3)-P2_af_TH(3)]);
    
    if Det_vec(1)>0
        if theta_TH>theta_1
            TH=theta_TH-theta_1;
            P1_af_TH=P2_af_TH-(rotx(TH)*[P3_af_TH(1)-P2_af_TH(1) P3_af_TH(2)-P2_af_TH(2) P3_af_TH(3)-P2_af_TH(3)]')'*L2_TH/L3_TH;
            TH4_FTH(iter)=-TH;
        else
            TH=theta_1-theta_TH;
            P1_af_TH=P2_af_TH-(rotx(-TH)*[P3_af_TH(1)-P2_af_TH(1) P3_af_TH(2)-P2_af_TH(2) P3_af_TH(3)-P2_af_TH(3)]')'*L2_TH/L3_TH;
            TH4_FTH(iter)=TH;
        end

        TH3_FTH(iter)=(pi-acos((L2_TH^2+L1_TH^2-L_TH^2)/(2*L2_TH*L1_TH)));
    else
        if theta_TH>theta_1
            TH=theta_TH-theta_1;
            P1_af_TH=P2_af_TH-(rotx(-TH)*[P3_af_TH(1)-P2_af_TH(1) P3_af_TH(2)-P2_af_TH(2) P3_af_TH(3)-P2_af_TH(3)]')'*L2_TH/L3_TH;
            TH4_FTH(iter)=TH;
        else
            TH=theta_1-theta_TH;
            P1_af_TH=P2_af_TH-(rotx(TH)*[P3_af_TH(1)-P2_af_TH(1) P3_af_TH(2)-P2_af_TH(2) P3_af_TH(3)-P2_af_TH(3)]')'*L2_TH/L3_TH;
            TH4_FTH(iter)=-TH;
        end

        TH3_FTH(iter)=-(pi-acos((L2_TH^2+L1_TH^2-L_TH^2)/(2*L2_TH*L1_TH)));
    end
    
    TH2_FTH(iter)=the_tot-TH3_FTH(iter)-TH4_FTH(iter);
    
    P1_af_TH=P1_af_TH*roty(-TH1_FTH(iter));
    
    Finger_coor1=FingerOrigin_TH;
    Finger_coor2=Finger_coor1*troty(TH1_FTH(iter))*trotx(TH2_FTH(iter))*transl(0,0,L1_TH);
    Finger_coor3=Finger_coor2*trotx(TH3_FTH(iter))*transl(0,0,L2_TH);
else
    
    P1_af_TH=P2_af_TH+(-P2_af_TH)*L2_TH/L_TH;
    TH3_FTH(iter)=0;
    theta_2_TH=acos(P2_af_TH(3)/L_TH);
    
    if P1_af_TH(2)>0
        TH2_FTH(iter)=-theta_2_TH;
    else
        TH2_FTH(iter)=theta_2_TH;
    end
    
    TH4_FTH(iter)=the_tot-TH2_FTH(iter);
    
    P1_af_TH=P1_af_TH*roty(-TH1_FTH(iter));
    
    Finger_coor1=FingerOrigin_TH;
    Finger_coor2=Finger_coor1*troty(TH1_FTH(iter))*trotx(TH2_FTH(iter))*transl(0,0,L_TH-L2_TH);
    Finger_coor3=Finger_coor2*trotx(TH3_FTH(iter))*transl(0,0,L2_TH);
end

new_P1=[P1_af_TH*FingerOrigin_TH(1,1:3)' P1_af_TH*FingerOrigin_TH(2,1:3)' P1_af_TH*FingerOrigin_TH(3,1:3)'];

% p4=plot3([P0_TH(1) new_P1(1)+FingerOrigin_TH(1,4)],[P0_TH(2) new_P1(2)+FingerOrigin_TH(2,4)],[P0_TH(3) new_P1(3)+FingerOrigin_TH(3,4)],'k.-');
% p5=plot3([P2_TH(1) new_P1(1)+FingerOrigin_TH(1,4)],[P2_TH(2) new_P1(2)+FingerOrigin_TH(2,4)],[P2_TH(3) new_P1(3)+FingerOrigin_TH(3,4)],'k.-');
% p6=plot3([P2_TH(1) P3_TH(1)],[P2_TH(2) P3_TH(2)],[P2_TH(3) P3_TH(3)],'k.-');

Finger_coor4=Finger_coor3*trotx(TH4_FTH(iter))*transl(0,0,L3_TH);

% p7=plot3([Finger_coor1(1,4) Finger_coor2(1,4)],[Finger_coor1(2,4) Finger_coor2(2,4)],[Finger_coor1(3,4) Finger_coor2(3,4)],'r.-');
% p8=plot3([Finger_coor3(1,4) Finger_coor2(1,4)],[Finger_coor3(2,4) Finger_coor2(2,4)],[Finger_coor3(3,4) Finger_coor2(3,4)],'r.-');
% p9=plot3([Finger_coor3(1,4) Finger_coor4(1,4)],[Finger_coor3(2,4) Finger_coor4(2,4)],[Finger_coor3(3,4) Finger_coor4(3,4)],'r.-');

pp8=plot3([Origin_TH(1,4) Joint1_TH(1)],[Origin_TH(2,4) Joint1_TH(2)],[Origin_TH(3,4) Joint1_TH(3)],'g.-');
pp9=plot3([Joint1_TH(1) Joint2_TH(1)],[Joint1_TH(2) Joint2_TH(2)],[Joint1_TH(3) Joint2_TH(3)],'g.-');
pp10=plot3([Joint2_TH(1) Joint3_TH(1)],[Joint2_TH(2) Joint3_TH(2)],[Joint2_TH(3) Joint3_TH(3)],'g.-');
pp11=plot3([Joint3_TH(1) Joint4_TH(1)],[Joint3_TH(2) Joint4_TH(2)],[Joint3_TH(3) Joint4_TH(3)],'g.-');
pp12=plot3([Joint4_TH(1) Joint5_TH(1)],[Joint4_TH(2) Joint5_TH(2)],[Joint4_TH(3) Joint5_TH(3)],'g.-');
pp13=plot3([Joint5_TH(1) Joint6_TH(1)],[Joint5_TH(2) Joint6_TH(2)],[Joint5_TH(3) Joint6_TH(3)],'g.-');
pp14=plot3([Joint7_TH(1) Joint6_TH(1)],[Joint7_TH(2) Joint6_TH(2)],[Joint7_TH(3) Joint6_TH(3)],'g.-');

Matout(iter,1)=TH1_FTH(iter)*180/pi;
Matout(iter,2)=TH2_FTH(iter)*180/pi;
Matout(iter,3)=-(Finger_coor1(3,4)-HandOrigin(3));
Matout(iter,4)=(Finger_coor1(2,4)-HandOrigin(2));
Matout(iter,5)=(Finger_coor1(1,4)-HandOrigin(1));
Matout(iter,6)=TH3_FTH(iter)*180/pi;
Matout(iter,7)=-(Finger_coor2(3,4)-HandOrigin(3));
Matout(iter,8)=(Finger_coor2(2,4)-HandOrigin(2));
Matout(iter,9)=(Finger_coor2(1,4)-HandOrigin(1));
Matout(iter,10)=TH4_FTH(iter)*180/pi;
Matout(iter,11)=-(Finger_coor3(3,4)-HandOrigin(3));
Matout(iter,12)=(Finger_coor3(2,4)-HandOrigin(2));
Matout(iter,13)=(Finger_coor3(1,4)-HandOrigin(1));
Matout(iter,14)=-(Finger_coor4(3,4)-HandOrigin(3));
Matout(iter,15)=(Finger_coor4(2,4)-HandOrigin(2));
Matout(iter,16)=(Finger_coor4(1,4)-HandOrigin(1));

% Matout(iter,1)=TH1_FTH(iter)*180/pi;
% Matout(iter,2)=TH2_FTH(iter)*180/pi;
% Matout(iter,3)=TH3_FTH(iter)*180/pi;
% Matout(iter,4)=TH4_FTH(iter)*180/pi;

%% index

mag=sqrt(data4(iter,I1*3+1)^2+data4(iter,I1*3+2)^2+data4(iter,I1*3+3)^2);
a=data4(iter,I1*3+1)/mag;
b=data4(iter,I1*3+2)/mag;

X=atan2(gamma,alpha);
if alpha*alpha+gamma*gamma-a*a>0
    TH1(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
else
    TH1(iter)=atan2(0,a)-X;
end

if TH1(iter)>pi/2
    TH1(iter)=pi/2;
elseif TH1(iter)<-pi/2
    TH1(iter)=-pi/2;
end

Y(iter)=-sin(TH1(iter))*alpha+cos(TH1(iter))*gamma;
if Y(iter)*Y(iter)+beta*beta-b*b<0
    TH2(iter)=atan2(b,0)-atan2(beta,Y(iter));
else
    TH2(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
end

if TH2(iter)>pi/2
    TH2(iter)=pi/2;
elseif TH2(iter)<-pi/2
    TH2(iter)=-pi/2;
end

mag=sqrt(data4(iter,I2*3+1)^2+data4(iter,I2*3+2)^2+data4(iter,I2*3+3)^2);
a=data4(iter,I2*3+1)/mag;
b=data4(iter,I2*3+2)/mag;

X=atan2(alpha,gamma);
if alpha*alpha+gamma*gamma-a*a>0
    TH4(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
else
    TH4(iter)=atan2(a,0)-X;
end

if TH4(iter)>pi/2
    TH4(iter)=pi/2;
elseif TH4(iter)<-pi/2
    TH4(iter)=-pi/2;
end


Y(iter)=-sin(TH4(iter))*alpha+cos(TH4(iter))*gamma;
if Y(iter) == 0
    Y(iter)=0.00001;
end
if Y(iter)*Y(iter)+beta*beta-b*b<0
    TH3(iter)=atan2(0,b)-atan2(Y(iter),beta);
else
    TH3(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
end

if TH3(iter)>pi/2
    TH3(iter)=pi/2;
elseif TH3(iter)<-pi/2
    TH3(iter)=-pi/2;
end

TH4(iter)=TH4(iter)+pi/4;

TH1(iter)=TH1(iter)-off_TH1;
TH2(iter)=TH2(iter)-off_TH2;
TH3(iter)=TH3(iter)-off_TH3;
TH4(iter)=TH4(iter)-off_TH4;

% DH=[0 0 0 -pi/2; 0 TH1(iter) l1 pi/2; 0 TH2(iter) l2 0; 0 -pi/2 l3 0; 0 TH3(iter) l4 0; 0 TH4(iter) l5 0; 0 -pi/2 l6 0; 0 pi/2 20.38 0];
DH=[DHoffset(1,1) DHoffset(2,1) DHoffset(3,1) DHoffset(4,1); DHoffset(5,1) TH1(iter) DHoffset(6,1) DHoffset(7,1); DHoffset(8,1) TH2(iter) l2 0; 0 -pi/2 l3 DHoffset(9,1); DHoffset(10,1) TH3(iter) DHoffset(11,1) DHoffset(12,1); DHoffset(13,1) TH4(iter) l5 0; DHoffset(14,1) DHoffset(15,1) DHoffset(16,1) DHoffset(17,1); 0 pi/2 20.65 0];
% DH=[DHoffset(1,1) DHoffset(2,1) DHoffset(3,1) DHoffset(4,1); DHoffset(5,1) TH1(iter) DHoffset(6,1) DHoffset(7,1); DHoffset(8,1) TH2(iter) l2 0; 0 -pi/2 l3 DHoffset(9,1); DHoffset(10,1) TH3(iter) DHoffset(11,1) DHoffset(12,1); DHoffset(13,1) TH4(iter) l5 0; 0 -pi/2 DHoffset(14,1) 0; DHoffset(15,1) pi/2 DHoffset(16,1) 0];

R01=transl(0,0,DH(1,1))*trotz(DH(1,2))*transl(DH(1,3),0,0)*trotx(DH(1,4));
R12=transl(0,0,DH(2,1))*trotz(DH(2,2))*transl(DH(2,3),0,0)*trotx(DH(2,4));
R23=transl(0,0,DH(3,1))*trotz(DH(3,2))*transl(DH(3,3),0,0)*trotx(DH(3,4));
R34=transl(0,0,DH(4,1))*trotz(DH(4,2))*transl(DH(4,3),0,0)*trotx(DH(4,4));
R45=transl(0,0,DH(5,1))*trotz(DH(5,2))*transl(DH(5,3),0,0)*trotx(DH(5,4));
R56=transl(0,0,DH(6,1))*trotz(DH(6,2))*transl(DH(6,3),0,0)*trotx(DH(6,4));
R67=transl(0,0,DH(7,1))*trotz(DH(7,2))*transl(DH(7,3),0,0)*trotx(DH(7,4));
R78=transl(0,0,DH(8,1))*trotz(DH(8,2))*transl(DH(8,3),0,0)*trotx(DH(8,4));

R1=Origin*R01*R12;
Joint1=[R1(1,4); R1(2,4); R1(3,4)];
R2=R1*R23;
Joint2=[R2(1,4); R2(2,4); R2(3,4)];
R3=R2*R34;
Joint3=[R3(1,4); R3(2,4); R3(3,4)];
R4=R3*R45;
Joint4=[R4(1,4); R4(2,4); R4(3,4)];
R5=R4*R56;
Joint5=[R5(1,4); R5(2,4); R5(3,4)];
R6=R5*R67;
Joint6=[R6(1,4); R6(2,4); R6(3,4)];
R7=R6*R78;
Joint7=[R7(1,4); R7(2,4); R7(3,4)];

R7=R7*trotz(Fingeroffset);
% fourth option
vec1=[R7(1,4)-FingerOrigin(1,4) R7(2,4)-FingerOrigin(2,4) R7(3,4)-FingerOrigin(3,4)];
vec2=[R7(1,1);R7(2,1);R7(3,1)];
vec1=[vec1*FingerOrigin(1:3,1) vec1*FingerOrigin(1:3,2) vec1*FingerOrigin(1:3,3)];
vec2=[vec2'*FingerOrigin(1:3,1);vec2'*FingerOrigin(1:3,2);vec2'*FingerOrigin(1:3,3)];
norm1=sqrt(vec1(1)*vec1(1)+vec1(3)*vec1(3));
norm2=sqrt(vec2(1)*vec2(1)+vec2(3)*vec2(3));
ang = acos([vec1(1) 0 vec1(3)]*[vec2(1) 0 vec2(3)]'/norm1/norm2);
det=cross([vec1(1) 0 vec1(3)],[vec2(1) 0 vec2(3)]);

if ang < pi/2
    if det(2)>0
        newaxis=roty(-ang)*vec2;
    else
        newaxis=roty(ang)*vec2;
    end
else
    if det(2)>0
        newaxis=roty(pi-ang)*vec2;
    else
        newaxis=roty(ang-pi)*vec2;
    end
end

newaxis=[newaxis'*FingerOrigin(1,1:3)' newaxis'*FingerOrigin(2,1:3)' newaxis'*FingerOrigin(3,1:3)']';

P0=FingerOrigin(1:3,4);
P3=Joint7;
P2=Joint7-newaxis*L3;
L=norm(P0-P2);
P3_af=[(P3(1)-FingerOrigin(1,4)) P3(2)-FingerOrigin(2,4) P3(3)-FingerOrigin(3,4)];
P2_af=[(P2(1)-FingerOrigin(1,4)) P2(2)-FingerOrigin(2,4) P2(3)-FingerOrigin(3,4)];
P3_af=[P3_af*FingerOrigin(1:3,1) P3_af*FingerOrigin(1:3,2) P3_af*FingerOrigin(1:3,3)];
P2_af=[P2_af*FingerOrigin(1:3,1) P2_af*FingerOrigin(1:3,2) P2_af*FingerOrigin(1:3,3)];

TH1_F(iter)=atan2(P2_af(1),P2_af(3));
P3_af=(roty(-TH1_F(iter))*P3_af')';
P2_af=(roty(-TH1_F(iter))*P2_af')';

if P3_af(2)-P2_af(2) > 0
    the_tot=-acos((P3_af(3)-P2_af(3))/L3);
else
    the_tot=acos((P3_af(3)-P2_af(3))/L3);
end

if L<L1+L2
    theta=acos((L2^2+L^2-L1^2)/(2*L2*L));
    x=[P3_af(1)-P2_af(1) P3_af(2)-P2_af(2) P3_af(3)-P2_af(3)]*P2_af'/L/L3;
    if x>1
        x=1;
    end
    theta_1=acos(x);
    
    Det_vec=cross(P2_af,[P3_af(1)-P2_af(1) P3_af(2)-P2_af(2) P3_af(3)-P2_af(3)]);
    
    if Det_vec(1)>0
        if theta>theta_1
            TH=theta-theta_1;
            P1_af=P2_af-(rotx(TH)*[P3_af(1)-P2_af(1) P3_af(2)-P2_af(2) P3_af(3)-P2_af(3)]')'*L2/L3;
            TH4_F(iter)=-TH;
        else
            TH=theta_1-theta;
            P1_af=P2_af-(rotx(-TH)*[P3_af(1)-P2_af(1) P3_af(2)-P2_af(2) P3_af(3)-P2_af(3)]')'*L2/L3;
            TH4_F(iter)=TH;
        end

        TH3_F(iter)=(pi-acos((L2^2+L1^2-L^2)/(2*L2*L1)));
    else
        if theta>theta_1
            TH=theta-theta_1;
            P1_af=P2_af-(rotx(-TH)*[P3_af(1)-P2_af(1) P3_af(2)-P2_af(2) P3_af(3)-P2_af(3)]')'*L2/L3;
            TH4_F(iter)=TH;
        else
            TH=theta_1-theta;
            P1_af=P2_af-(rotx(TH)*[P3_af(1)-P2_af(1) P3_af(2)-P2_af(2) P3_af(3)-P2_af(3)]')'*L2/L3;
            TH4_F(iter)=-TH;
        end

        TH3_F(iter)=-(pi-acos((L2^2+L1^2-L^2)/(2*L2*L1)));
    end
    
    TH2_F(iter)=the_tot-TH3_F(iter)-TH4_F(iter);
    
    P1_af=P1_af*roty(-TH1_F(iter));
    
    Finger_coor1=FingerOrigin;
    Finger_coor2=Finger_coor1*troty(TH1_F(iter))*trotx(TH2_F(iter))*transl(0,0,L1);
    Finger_coor3=Finger_coor2*trotx(TH3_F(iter))*transl(0,0,L2);
else
    P1_af=P2_af+(-P2_af)*L2/L;
    TH3_F(iter)=0;
    theta_2=acos([0 0 1]*P2_af'/L);
    
    if P1_af(2)>0
        TH2_F(iter)=-theta_2;
    else
        TH2_F(iter)=theta_2;
    end
    
    TH4_F(iter)=the_tot-TH2_F(iter);
    
    P1_af=P1_af*roty(-TH1_F(iter));
    
    Finger_coor1=FingerOrigin;
    Finger_coor2=Finger_coor1*troty(TH1_F(iter))*trotx(TH2_F(iter))*transl(0,0,L-L2);
    Finger_coor3=Finger_coor2*trotx(TH3_F(iter))*transl(0,0,L2);
end

% p1=plot3([P0(1) (P1_af(3)+FingerOrigin(3))],[P0(2) P1_af(2)+FingerOrigin(2)],[P0(3) -(P1_af(1)+FingerOrigin(1))],'k.-');
% p2=plot3([P2(1) (P1_af(3)+FingerOrigin(3))],[P2(2) P1_af(2)+FingerOrigin(2)],[P2(3) -(P1_af(1)+FingerOrigin(1))],'k.-');
% p3=plot3([P2(1) P3(1)],[P2(2) P3(2)],[P2(3) P3(3)],'k.-');

Finger_coor4=Finger_coor3*trotx(TH4_F(iter))*transl(0,0,L3);

% p10=plot3([Finger_coor1(1,4) Finger_coor2(1,4)],[Finger_coor1(2,4) Finger_coor2(2,4)],[Finger_coor1(3,4) Finger_coor2(3,4)],'r.-');
% p11=plot3([Finger_coor3(1,4) Finger_coor2(1,4)],[Finger_coor3(2,4) Finger_coor2(2,4)],[Finger_coor3(3,4) Finger_coor2(3,4)],'r.-');
% p12=plot3([Finger_coor3(1,4) Finger_coor4(1,4)],[Finger_coor3(2,4) Finger_coor4(2,4)],[Finger_coor3(3,4) Finger_coor4(3,4)],'r.-');

pp1=plot3([Origin(1,4) Joint1(1)],[Origin(2,4) Joint1(2)],[Origin(3,4) Joint1(3)],'k.-');
pp2=plot3([Joint1(1) Joint2(1)],[Joint1(2) Joint2(2)],[Joint1(3) Joint2(3)],'k.-');
pp3=plot3([Joint2(1) Joint3(1)],[Joint2(2) Joint3(2)],[Joint2(3) Joint3(3)],'k.-');
pp4=plot3([Joint3(1) Joint4(1)],[Joint3(2) Joint4(2)],[Joint3(3) Joint4(3)],'k.-');
pp5=plot3([Joint4(1) Joint5(1)],[Joint4(2) Joint5(2)],[Joint4(3) Joint5(3)],'k.-');
pp6=plot3([Joint5(1) Joint6(1)],[Joint5(2) Joint6(2)],[Joint5(3) Joint6(3)],'k.-');
pp7=plot3([Joint7(1) Joint6(1)],[Joint7(2) Joint6(2)],[Joint7(3) Joint6(3)],'k.-');


%% Middle

mag=sqrt(data4(iter,M1*3+1)^2+data4(iter,M1*3+2)^2+data4(iter,M1*3+3)^2);
a=data4(iter,M1*3+1)/mag;
b=data4(iter,M1*3+2)/mag;

X=atan2(gamma,alpha);
if alpha*alpha+gamma*gamma-a*a>0
    TH1_MI(iter)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
else
    TH1_MI(iter)=atan2(0,a)-X;
end

if TH1_MI(iter)>pi/2
    TH1_MI(iter)=pi/2;
elseif TH1_MI(iter)<-pi/2
    TH1_MI(iter)=-pi/2;
end
    
Y(iter)=sin(TH1_MI(iter))*alpha+cos(TH1_MI(iter))*gamma;
if Y(iter)*Y(iter)+beta*beta-b*b<0
    TH2_MI(iter)=atan2(b,0)-atan2(beta,Y(iter));
else
    TH2_MI(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
end

if TH2_MI(iter)>pi/2
    TH2_MI(iter)=pi/2;
elseif TH2_MI(iter)<-pi/2
    TH2_MI(iter)=-pi/2;
end
    
mag=sqrt(data4(iter,M2*3+1)^2+data4(iter,M2*3+2)^2+data4(iter,M2*3+3)^2);
a=data4(iter,M2*3+1)/mag;
b=data4(iter,M2*3+2)/mag;

X=atan2(alpha,gamma);
if alpha*alpha+gamma*gamma-a*a>0
    TH4_MI(iter)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
else
    TH4_MI(iter)=atan2(a,0)-X;
end

if TH4_MI(iter)>pi/2
    TH4_MI(iter)=pi/2;
elseif TH4_MI(iter)<-pi/2
    TH4_MI(iter)=-pi/2;
end


Y(iter)=-sin(TH4_MI(iter))*alpha+cos(TH4_MI(iter))*gamma;
if Y(iter) == 0
    Y(iter)=0.00001;
end
if Y(iter)*Y(iter)+beta*beta-b*b<0
    TH3_MI(iter)=atan2(0,b)-atan2(Y(iter),beta);
else
    TH3_MI(iter)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
    compare=atan2(abs(cos(TH3_MI(iter))*cos(TH4_MI(iter))),b)-atan2(Y(iter),beta);
end

if TH3_MI(iter)>pi/2
    TH3_MI(iter)=pi/2;
elseif TH3_MI(iter)<-pi/2
    TH3_MI(iter)=-pi/2;
end

TH4_MI(iter)=TH4_MI(iter)+pi/4;

TH1_MI(iter)=TH1_MI(iter)-off_TH1_MI;
TH2_MI(iter)=TH2_MI(iter)-off_TH2_MI;
TH3_MI(iter)=TH3_MI(iter)-off_TH3_MI;
TH4_MI(iter)=TH4_MI(iter)-off_TH4_MI;

% DH_MI=[0 0 0 -pi/2; 0 TH1_MI(iter) l1_MI pi/2; 0 TH2_MI(iter) l2_MI 0; 0 -pi/2 l3_MI 0; 0 TH3_MI(iter) l4_MI 0; 0 TH4_MI(iter) l5_MI 0; 0 -pi/2 l6_MI 0; 0 pi/2 20.46 0];
DH_MI=[DHoffset(1,3) DHoffset(2,3) DHoffset(3,3) DHoffset(4,3); DHoffset(5,3) TH1_MI(iter) DHoffset(6,3) DHoffset(7,3); DHoffset(8,3) TH2_MI(iter) l2_MI 0; 0 -pi/2 l3_MI DHoffset(9,3); DHoffset(10,3) TH3_MI(iter) DHoffset(11,3) DHoffset(12,3); DHoffset(13,3) TH4_MI(iter) l5_MI 0; DHoffset(14,3) DHoffset(15,3) DHoffset(16,3) DHoffset(17,3); 0 pi/2 20.65 0];

R01_MI=transl(0,0,DH_MI(1,1))*trotz(DH_MI(1,2))*transl(DH_MI(1,3),0,0)*trotx(DH_MI(1,4));
R12_MI=transl(0,0,DH_MI(2,1))*trotz(DH_MI(2,2))*transl(DH_MI(2,3),0,0)*trotx(DH_MI(2,4));
R23_MI=transl(0,0,DH_MI(3,1))*trotz(DH_MI(3,2))*transl(DH_MI(3,3),0,0)*trotx(DH_MI(3,4));
R34_MI=transl(0,0,DH_MI(4,1))*trotz(DH_MI(4,2))*transl(DH_MI(4,3),0,0)*trotx(DH_MI(4,4));
R45_MI=transl(0,0,DH_MI(5,1))*trotz(DH_MI(5,2))*transl(DH_MI(5,3),0,0)*trotx(DH_MI(5,4));
R56_MI=transl(0,0,DH_MI(6,1))*trotz(DH_MI(6,2))*transl(DH_MI(6,3),0,0)*trotx(DH_MI(6,4));
R67_MI=transl(0,0,DH_MI(7,1))*trotz(DH_MI(7,2))*transl(DH_MI(7,3),0,0)*trotx(DH_MI(7,4));
R78_MI=transl(0,0,DH_MI(8,1))*trotz(DH_MI(8,2))*transl(DH_MI(8,3),0,0)*trotx(DH_MI(8,4));

R1_MI=Origin_MI*R01_MI*R12_MI;
Joint1_MI=[R1_MI(1,4); R1_MI(2,4); R1_MI(3,4)];
R2_MI=R1_MI*R23_MI;
Joint2_MI=[R2_MI(1,4); R2_MI(2,4); R2_MI(3,4)];
R3_MI=R2_MI*R34_MI;
Joint3_MI=[R3_MI(1,4); R3_MI(2,4); R3_MI(3,4)];
R4_MI=R3_MI*R45_MI;
Joint4_MI=[R4_MI(1,4); R4_MI(2,4); R4_MI(3,4)];
R5_MI=R4_MI*R56_MI;
Joint5_MI=[R5_MI(1,4); R5_MI(2,4); R5_MI(3,4)];
R6_MI=R5_MI*R67_MI;
Joint6_MI=[R6_MI(1,4); R6_MI(2,4); R6_MI(3,4)];
R7_MI=R6_MI*R78_MI;
Joint7_MI=[R7_MI(1,4); R7_MI(2,4); R7_MI(3,4)];
R7_MI=R7_MI*trotz(Fingeroffset_MI);

FingerOrigin(3,4)=FingerOrigin(3,4)+Joint7_MI(3)-FingerOrigin_MI(3,4);
FingerOrigin_TH(3,4)=FingerOrigin_TH(3,4)+Joint7_MI(3)-FingerOrigin_MI(3,4);
FingerOrigin_MI(3,4)=Joint7_MI(3);

% fourth option
vec1=[R7_MI(1,4)-FingerOrigin_MI(1,4) R7_MI(2,4)-FingerOrigin_MI(2,4) R7_MI(3,4)-FingerOrigin_MI(3,4)];
vec2=[R7_MI(1,1);R7_MI(2,1);R7_MI(3,1)];
vec1=[vec1*FingerOrigin_MI(1:3,1) vec1*FingerOrigin_MI(1:3,2) vec1*FingerOrigin_MI(1:3,3)];
vec2=[vec2'*FingerOrigin_MI(1:3,1);vec2'*FingerOrigin_MI(1:3,2);vec2'*FingerOrigin_MI(1:3,3)];
norm1=sqrt(vec1(1)*vec1(1)+vec1(3)*vec1(3));
norm2=sqrt(vec2(1)*vec2(1)+vec2(3)*vec2(3));
ang = acos([vec1(1) 0 vec1(3)]*[vec2(1) 0 vec2(3)]'/norm1/norm2);
det=cross([vec1(1) 0 vec1(3)],[vec2(1) 0 vec2(3)]);

if ang < pi/2
    if det(2)>0
        newaxis=roty(-ang)*vec2;
    else
        newaxis=roty(ang)*vec2;
    end
else
    if det(2)>0
        newaxis=roty(pi-ang)*vec2;
    else
        newaxis=roty(ang-pi)*vec2;
    end
end

newaxis=[newaxis'*FingerOrigin_MI(1,1:3)' newaxis'*FingerOrigin_MI(2,1:3)' newaxis'*FingerOrigin_MI(3,1:3)']';

P0_MI=FingerOrigin_MI(1:3,4);
P3_MI=Joint7_MI;
P2_MI=Joint7_MI-newaxis*L3_MI;
L_MI=norm(P0_MI-P2_MI);
P3_af_MI=[(P3_MI(1)-FingerOrigin_MI(1,4)) P3_MI(2)-FingerOrigin_MI(2,4) P3_MI(3)-FingerOrigin_MI(3,4)];
P2_af_MI=[(P2_MI(1)-FingerOrigin_MI(1,4)) P2_MI(2)-FingerOrigin_MI(2,4) P2_MI(3)-FingerOrigin_MI(3,4)];
P3_af_MI=[P3_af_MI*FingerOrigin_MI(1:3,1) P3_af_MI*FingerOrigin_MI(1:3,2) P3_af_MI*FingerOrigin_MI(1:3,3)];
P2_af_MI=[P2_af_MI*FingerOrigin_MI(1:3,1) P2_af_MI*FingerOrigin_MI(1:3,2) P2_af_MI*FingerOrigin_MI(1:3,3)];

TH1_FMI(iter)=0;

if P3_af_MI(2)-P2_af_MI(2) > 0
    the_tot=-acos((P3_af_MI(3)-P2_af_MI(3))/L3_MI);
else
    the_tot=acos((P3_af_MI(3)-P2_af_MI(3))/L3_MI);
end

if L_MI<L1_MI+L2_MI
    theta=acos((L2_MI^2+L_MI^2-L1_MI^2)/(2*L2_MI*L_MI));
    x=[P3_af_MI(1)-P2_af_MI(1) P3_af_MI(2)-P2_af_MI(2) P3_af_MI(3)-P2_af_MI(3)]*P2_af_MI'/L_MI/L3_MI;
    if x>1
        x=1;
    end
    theta_1=acos(x);
    
    Det_vec=cross(P2_af_MI,[P3_af_MI(1)-P2_af_MI(1) P3_af_MI(2)-P2_af_MI(2) P3_af_MI(3)-P2_af_MI(3)]);
    
    if Det_vec(1)>0
        if theta>theta_1
            TH=theta-theta_1;
            P1_af_MI=P2_af_MI-(rotx(TH)*[P3_af_MI(1)-P2_af_MI(1) P3_af_MI(2)-P2_af_MI(2) P3_af_MI(3)-P2_af_MI(3)]')'*L2_MI/L3_MI;
            TH4_FMI(iter)=-TH;
        else
            TH=theta_1-theta;
            P1_af_MI=P2_af_MI-(rotx(-TH)*[P3_af_MI(1)-P2_af_MI(1) P3_af_MI(2)-P2_af_MI(2) P3_af_MI(3)-P2_af_MI(3)]')'*L2_MI/L3_MI;
            TH4_FMI(iter)=TH;
        end

        TH3_FMI(iter)=(pi-acos((L2_MI^2+L1_MI^2-L_MI^2)/(2*L2_MI*L1_MI)));
    else
        if theta>theta_1
            TH=theta-theta_1;
            P1_af_MI=P2_af_MI-(rotx(-TH)*[P3_af_MI(1)-P2_af_MI(1) P3_af_MI(2)-P2_af_MI(2) P3_af_MI(3)-P2_af_MI(3)]')'*L2_MI/L3_MI;
            TH4_FMI(iter)=TH;
        else
            TH=theta_1-theta;
            P1_af_MI=P2_af_MI-(rotx(TH)*[P3_af_MI(1)-P2_af_MI(1) P3_af_MI(2)-P2_af_MI(2) P3_af_MI(3)-P2_af_MI(3)]')'*L2_MI/L3_MI;
            TH4_FMI(iter)=-TH;
        end

        TH3_FMI(iter)=-(pi-acos((L2_MI^2+L1_MI^2-L_MI^2)/(2*L2_MI*L1_MI)));
    end
    
    TH2_FMI(iter)=the_tot-TH3_FMI(iter)-TH4_FMI(iter);
    
    P1_af_MI=P1_af_MI*roty(-TH1_FMI(iter));
    
    Finger_coor1=FingerOrigin_MI;
    Finger_coor2=Finger_coor1*troty(TH1_FMI(iter))*trotx(TH2_FMI(iter))*transl(0,0,L1_MI);
    Finger_coor3=Finger_coor2*trotx(TH3_FMI(iter))*transl(0,0,L2_MI);
else
    P1_af_MI=P2_af_MI+(-P2_af_MI)*L2_MI/L_MI;
    TH3_FMI(iter)=0;
    theta_2=acos([0 0 1]*P2_af_MI'/L_MI);
    
    if P1_af_MI(2)>0
        TH2_FMI(iter)=-theta_2;
    else
        TH2_FMI(iter)=theta_2;
    end
    
    TH4_FMI(iter)=the_tot-TH2_FMI(iter);
    
    P1_af_MI=P1_af_MI*roty(-TH1_FMI(iter));
    
    Finger_coor1=FingerOrigin_MI;
    Finger_coor2=Finger_coor1*troty(TH1_FMI(iter))*trotx(TH2_FMI(iter))*transl(0,0,L_MI-L2_MI);
    Finger_coor3=Finger_coor2*trotx(TH3_FMI(iter))*transl(0,0,L2_MI);
end

new_P1=[P1_af_MI*FingerOrigin_MI(1,1:3)' P1_af_MI*FingerOrigin_MI(2,1:3)' P1_af_MI*FingerOrigin_MI(3,1:3)'];

% p13=plot3([P0_MI(1) new_P1(1)+FingerOrigin_MI(1,4)],[P0_MI(2) new_P1(2)+FingerOrigin_MI(2,4)],[P0_MI(3) new_P1(3)+FingerOrigin_MI(3,4)],'k.-');
% p14=plot3([P2_MI(1) new_P1(1)+FingerOrigin_MI(1,4)],[P2_MI(2) new_P1(2)+FingerOrigin_MI(2,4)],[P2_MI(3) new_P1(3)+FingerOrigin_MI(3,4)],'k.-');
% p15=plot3([P2_MI(1) P3_MI(1)],[P2_MI(2) P3_MI(2)],[P2_MI(3) P3_MI(3)],'k.-');

% p13=plot3([P0_MI(1) (P1_af_MI(3)+FingerOrigin_MI(3))],[P0_MI(2) P1_af_MI(2)+FingerOrigin_MI(2)],[P0_MI(3) -(P1_af_MI(1)+FingerOrigin_MI(1))],'k.-');
% p14=plot3([P2_MI(1) (P1_af_MI(3)+FingerOrigin_MI(3))],[P2_MI(2) P1_af_MI(2)+FingerOrigin_MI(2)],[P2_MI(3) -(P1_af_MI(1)+FingerOrigin_MI(1))],'k.-');
% p15=plot3([P2_MI(1) P3_MI(1)],[P2_MI(2) P3_MI(2)],[P2_MI(3) P3_MI(3)],'k.-');

Finger_coor4=Finger_coor3*trotx(TH4_FMI(iter))*transl(0,0,L3_MI);

% p16=plot3([Finger_coor1(1,4) Finger_coor2(1,4)],[Finger_coor1(2,4) Finger_coor2(2,4)],[Finger_coor1(3,4) Finger_coor2(3,4)],'r.-');
% p17=plot3([Finger_coor3(1,4) Finger_coor2(1,4)],[Finger_coor3(2,4) Finger_coor2(2,4)],[Finger_coor3(3,4) Finger_coor2(3,4)],'r.-');
% p18=plot3([Finger_coor3(1,4) Finger_coor4(1,4)],[Finger_coor3(2,4) Finger_coor4(2,4)],[Finger_coor3(3,4) Finger_coor4(3,4)],'r.-');

pp15=plot3([Origin_MI(1,4) Joint1_MI(1)],[Origin_MI(2,4) Joint1_MI(2)],[Origin_MI(3,4) Joint1_MI(3)],'k.-');
pp16=plot3([Joint1_MI(1) Joint2_MI(1)],[Joint1_MI(2) Joint2_MI(2)],[Joint1_MI(3) Joint2_MI(3)],'k.-');
pp17=plot3([Joint2_MI(1) Joint3_MI(1)],[Joint2_MI(2) Joint3_MI(2)],[Joint2_MI(3) Joint3_MI(3)],'k.-');
pp18=plot3([Joint3_MI(1) Joint4_MI(1)],[Joint3_MI(2) Joint4_MI(2)],[Joint3_MI(3) Joint4_MI(3)],'k.-');
pp19=plot3([Joint4_MI(1) Joint5_MI(1)],[Joint4_MI(2) Joint5_MI(2)],[Joint4_MI(3) Joint5_MI(3)],'k.-');
pp20=plot3([Joint5_MI(1) Joint6_MI(1)],[Joint5_MI(2) Joint6_MI(2)],[Joint5_MI(3) Joint6_MI(3)],'k.-');
pp21=plot3([Joint7_MI(1) Joint6_MI(1)],[Joint7_MI(2) Joint6_MI(2)],[Joint7_MI(3) Joint6_MI(3)],'k.-');

Movie(iter)=getframe;
delete(pp1);
delete(pp2);
delete(pp3);
delete(pp4);
delete(pp5);
delete(pp6);
delete(pp7);
delete(pp8);
delete(pp9);
delete(pp10);
delete(pp11);
delete(pp12);
delete(pp13);
delete(pp14);
delete(pp15);
delete(pp16);
delete(pp17);
delete(pp18);
delete(pp19);
delete(pp20);
delete(pp21);
% delete(p1);
% delete(p2);
% delete(p3);
% delete(p4);
% delete(p5);
% delete(p6);
% delete(p7);
% delete(p8);
% delete(p9);
% delete(p10);
% delete(p11);
% delete(p12);
% delete(p13);
% delete(p14);
% delete(p15);
% delete(p16);
% delete(p17);
% delete(p18);

Matout(iter,17)=TH1_F(iter)*180/pi;
Matout(iter,18)=TH2_F(iter)*180/pi;
Matout(iter,19)=-(Finger_coor1(3,4)-HandOrigin(3));
Matout(iter,20)=(Finger_coor1(2,4)-HandOrigin(2));
Matout(iter,21)=(Finger_coor1(1,4)-HandOrigin(1));
Matout(iter,22)=TH3_F(iter)*180/pi;
Matout(iter,23)=-(Finger_coor2(3,4)-HandOrigin(3));
Matout(iter,24)=(Finger_coor2(2,4)-HandOrigin(2));
Matout(iter,25)=(Finger_coor2(1,4)-HandOrigin(1));
Matout(iter,26)=TH4_F(iter)*180/pi;
Matout(iter,27)=-(Finger_coor3(3,4)-HandOrigin(3));
Matout(iter,28)=(Finger_coor3(2,4)-HandOrigin(2));
Matout(iter,29)=(Finger_coor3(1,4)-HandOrigin(1));
Matout(iter,30)=-(Finger_coor4(3,4)-HandOrigin(3));
Matout(iter,31)=(Finger_coor4(2,4)-HandOrigin(2));
Matout(iter,32)=(Finger_coor4(1,4)-HandOrigin(1));

% Matout(iter,5)=TH1_F(iter)*180/pi;
% Matout(iter,6)=TH2_F(iter)*180/pi;
% Matout(iter,7)=TH3_F(iter)*180/pi;
% Matout(iter,8)=TH4_F(iter)*180/pi;
end
% pp1=plot3([Origin(1,4) Joint1(1)],[Origin(2,4) Joint1(2)],[Origin(3,4) Joint1(3)],'k.-');
% pp2=plot3([Joint1(1) Joint2(1)],[Joint1(2) Joint2(2)],[Joint1(3) Joint2(3)],'k.-');
% pp3=plot3([Joint2(1) Joint3(1)],[Joint2(2) Joint3(2)],[Joint2(3) Joint3(3)],'k.-');
% pp4=plot3([Joint3(1) Joint4(1)],[Joint3(2) Joint4(2)],[Joint3(3) Joint4(3)],'k.-');
% pp5=plot3([Joint5(1) Joint4(1)],[Joint5(2) Joint4(2)],[Joint5(3) Joint4(3)],'k.-');
% pp6=plot3([Joint5(1) Joint6(1)],[Joint5(2) Joint6(2)],[Joint5(3) Joint6(3)],'k.-');
% pp7=plot3([Joint7(1) Joint6(1)],[Joint7(2) Joint6(2)],[Joint7(3) Joint6(3)],'k.-');
% pp8=plot3([Origin_TH(1,4) Joint1_TH(1)],[Origin_TH(2,4) Joint1_TH(2)],[Origin_TH(3,4) Joint1_TH(3)],'g.-');
% pp9=plot3([Joint1_TH(1) Joint2_TH(1)],[Joint1_TH(2) Joint2_TH(2)],[Joint1_TH(3) Joint2_TH(3)],'g.-');
% pp10=plot3([Joint2_TH(1) Joint3_TH(1)],[Joint2_TH(2) Joint3_TH(2)],[Joint2_TH(3) Joint3_TH(3)],'g.-');
% pp11=plot3([Joint3_TH(1) Joint4_TH(1)],[Joint3_TH(2) Joint4_TH(2)],[Joint3_TH(3) Joint4_TH(3)],'g.-');
% pp12=plot3([Joint5_TH(1) Joint4_TH(1)],[Joint5_TH(2) Joint4_TH(2)],[Joint5_TH(3) Joint4_TH(3)],'g.-');
% pp13=plot3([Joint5_TH(1) Joint6_TH(1)],[Joint5_TH(2) Joint6_TH(2)],[Joint5_TH(3) Joint6_TH(3)],'g.-');
% pp14=plot3([Joint7_TH(1) Joint6_TH(1)],[Joint7_TH(2) Joint6_TH(2)],[Joint7_TH(3) Joint6_TH(3)],'g.-');
% pp15=plot3([Origin_MI(1,4) Joint1_MI(1)],[Origin_MI(2,4) Joint1_MI(2)],[Origin_MI(3,4) Joint1_MI(3)],'k.-');
% pp16=plot3([Joint1_MI(1) Joint2_MI(1)],[Joint1_MI(2) Joint2_MI(2)],[Joint1_MI(3) Joint2_MI(3)],'k.-');
% pp17=plot3([Joint2_MI(1) Joint3_MI(1)],[Joint2_MI(2) Joint3_MI(2)],[Joint2_MI(3) Joint3_MI(3)],'k.-');
% pp18=plot3([Joint3_MI(1) Joint4_MI(1)],[Joint3_MI(2) Joint4_MI(2)],[Joint3_MI(3) Joint4_MI(3)],'k.-');
% pp19=plot3([Joint5_MI(1) Joint4_MI(1)],[Joint5_MI(2) Joint4_MI(2)],[Joint5_MI(3) Joint4_MI(3)],'k.-');
% pp20=plot3([Joint5_MI(1) Joint6_MI(1)],[Joint5_MI(2) Joint6_MI(2)],[Joint5_MI(3) Joint6_MI(3)],'k.-');
% pp21=plot3([Joint7_MI(1) Joint6_MI(1)],[Joint7_MI(2) Joint6_MI(2)],[Joint7_MI(3) Joint6_MI(3)],'k.-');

% p1=plot3([P0(1) P1_af(3)+FingerOrigin(3)],[P0(2) P1_af(2)+FingerOrigin(2)],[P0(3) -(P1_af(1)+FingerOrigin(1))],'k.-');
% p2=plot3([P2(1) P1_af(3)+FingerOrigin(3)],[P2(2) P1_af(2)+FingerOrigin(2)],[P2(3) -(P1_af(1)+FingerOrigin(1))],'k.-');
% p3=plot3([P2(1) P3(1)],[P2(2) P3(2)],[P2(3) P3(3)],'r.-');
% 
% p4=plot3([P0_TH(1) new_P1(1)+FingerOrigin_TH(1,4)],[P0_TH(2) new_P1(2)+FingerOrigin_TH(2,4)],[P0_TH(3) new_P1(3)+FingerOrigin_TH(3,4)],'k.-');
% p5=plot3([P2_TH(1) new_P1(1)+FingerOrigin_TH(1,4)],[P2_TH(2) new_P1(2)+FingerOrigin_TH(2,4)],[P2_TH(3) new_P1(3)+FingerOrigin_TH(3,4)],'k.-');
% p6=plot3([P2_TH(1) P3_TH(1)],[P2_TH(2) P3_TH(2)],[P2_TH(3) P3_TH(3)],'r.-');

% p13=plot3([P0_MI(1) (P1_af_MI(3)+FingerOrigin(3))],[P0_MI(2) P1_af_MI(2)+FingerOrigin(2)],[P0_MI(3) -(P1_af_MI(1)+FingerOrigin(1))],'k.-');
% p14=plot3([P2_MI(1) (P1_af_MI(3)+FingerOrigin(3))],[P2_MI(2) P1_af_MI(2)+FingerOrigin(2)],[P2_MI(3) -(P1_af_MI(1)+FingerOrigin(1))],'k.-');
% p15=plot3([P2_MI(1) P3_MI(1)],[P2_MI(2) P3_MI(2)],[P2_MI(3) P3_MI(3)],'k.-');

csvwrite('Fingerinfo.csv',Matout)