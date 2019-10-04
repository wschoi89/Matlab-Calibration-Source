clc, clear, close ('all')
%%
% l1=24.2;
% l2=56.03;
% l3=12.94;
% l4=47.5;
% l5=19.5;
% l6=19.94;
% l7=-7.3;
% l8=14.95;
% 
% l1_TH=24.2;
% l2_TH=56.03;
% l3_TH=12.94;
% l4_TH=57.5;
% l5_TH=19.5;
% l6_TH=22.49;
% l7_TH=8.65;
% l8_TH=15.4;
% 
% l1_MI=24.2;
% l2_MI=56.03;
% l3_MI=12.94;
% l4_MI=47.5;
% l5_MI=19.5;
% l6_MI=19.94;
% l7_MI=-7.3;
% l8_MI=14.95;

%% 수정 후 Finger Information (Fingertip 교체 후)
% l1=24.2;
% l2=56.03;
% l3=12.94;
% l4=47.5;
% l5=18.5;
% l6=23.5;
% l7=-10.37;
% l8=16.5;
% 
% l1_TH=24.2;
% l2_TH=56.03;
% l3_TH=12.94;
% l4_TH=57.5;
% l5_TH=18.5;
% l6_TH=26.5;
% l7_TH=10.37;
% l8_TH=16.5;
% 
% l1_MI=24.2;
% l2_MI=56.03;
% l3_MI=12.94;
% l4_MI=47.5;
% l5_MI=18.5;
% l6_MI=25;
% l7_MI=-10.37;
% l8_MI=16.5;

% l1=24.2;
% l2=56.03;
% l3=12.94;
% l4=47.5;
% l5=18.5;
% l6=23.5;
% l7=-10.37;
% l8=16.5;
% 
% l1_TH=24.2;
% l2_TH=56.03;
% l3_TH=12.94;
% l4_TH=57.5;
% l5_TH=18.5;
% l6_TH=26.5;
% l7_TH=10.37;
% l8_TH=16.5;
% 
% l1_MI=24.2;
% l2_MI=56.03;
% l3_MI=12.94;
% l4_MI=47.5;
% l5_MI=18.5;
% l6_MI=25;
% l7_MI=-10.37;
% l8_MI=16.5;

% %%Fingertip 수정 (181204)
l1=24.2;
l2=56.03;
l3=12.94;
l4=47.5;
l5=19.5;
l6=22.96;
l7=-10.42;
l8=16.61;

l1_TH=24.2;
l2_TH=56.03;
l3_TH=12.94;
l4_TH=57.5;
l5_TH=19.5;
l6_TH=24.82;
l7_TH=10.42;
l8_TH=16.61;

l1_MI=24.2;
l2_MI=56.03;
l3_MI=12.94;
l4_MI=47.5;
l5_MI=19.5;
l6_MI=22.93;
l7_MI=-10.42;
l8_MI=16.61;

%%190116 수정
% l1=24.2;
% l2=56.03;
% l3=12.94;
% l4=47.5;
% l5=19.5;
% % l6=22.96;
% l6 = 24.90;
% l7=-10.42;
% l8=16.61;
% 
% l1_TH=24.2;
% l2_TH=56.03;
% l3_TH=12.94;
% l4_TH=57.5;
% l5_TH=19.5;
% % l6_TH=24.82;
% l6_TH = 27.25;
% l7_TH=10.42;
% l8_TH=16.61;
% 
% l1_MI=24.2;
% l2_MI=56.03;
% l3_MI=12.94;
% l4_MI=47.5;
% l5_MI=19.5;
% % l6_MI=22.93;
% l6_MI = 24.19;
% l7_MI=-10.42;
% l8_MI=16.61;




%DHoffset = csvread('Right06_DHoffset_new3.csv');
% DHoffset =  [ -0.00044433248478294719953483501324841, -0.00090416484333471347641349759781847, -0.00035924486335677145188142418871936;
%       0.1086397341503200861600811810686,   -0.090432809724506683151764699336219,    0.089405193708867794167335066000799;
%    0.0025575618779132503081855664676887,  -0.0041183859394860156984380540106415,   0.0017266580328384496608012793470111;
%      -1.6084827522459464433643877498229,     -1.5628574920846842732056068933084,     -1.5762743230149466961212273611926;
%   -0.0052050395750655815945315125907627,   0.0048314155904580839535924735138327,  -0.0025595594337044060744180797672906;
%       24.202477475480110291622863006073,         24.195792677214295807963360255,      24.201756053549306239975199782464;
%       1.4820290740748608418336235787203,       1.568213687239785589730674254498,      1.5537328827181677693920230931573;
%   0.00044001322956238672136133074610268, -0.00042605580804268290968107488594581, -0.00012973659896546513937482690564695;
%     0.022122501614639162826672093262391,    0.042766157153452363284321508885583,    0.030307156441792846632020261550398;
%    0.0004708522216188131716506778525052, -0.00037012579618939497719162319428486, -0.00015785955957603714864717450792332;
%        47.50473638333699735080010135422,      57.495435449219225022366522521956,      47.502390621120234230835400429993;
%     0.013518687491883619180160272112777,    0.041679701986236044004133923403974,    0.028057540393204754493464915060836;
%   0.00050681708188658204628190891087698,  -0.0003177535685484622945801193218854, -0.00017970131349255669198008453239624;
%   0.00050681708188658204628190891087698,  -0.0003177535685484622945801193218854, -0.00017970131349255669198008453239624;
%      -1.4291769475758112097014367713916,     -1.7323773359645018862623909332885,      -1.501611815111880633534927414391;
%       24.894544429559229097247757492044,       27.24921247626329715389214401344,      24.187000951151578615324424099353;
%     0.028758336592699600966593455390391,      0.0635464488450796721973686536657,   0.0053292559766198789585439303618535;
%                                       0,     -88.755819444658689972606062688318,   0.0019300826876096491891644378151688;
%                                       0,     -29.037577285908701433695749232045,  -0.0024281775010313515288238884798054;
%                                       0,     -24.349905492705249642714414749411,      18.999644943886099046396400415084;
%                                       0,      -1.432044981103521715143249669483,  -0.0043390839894772903359987742860628;
%                                       0,      0.5345944680794468410090206449604,   -0.017579565904194894904125370803415;
%                                       0,     0.81749950415392052754426688023695,    0.089405193708867794167335066000799];
% 
% Origin=[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];%*transl(DHoffset(29,1),DHoffset(30,1),DHoffset(31,1))*trotx(DHoffset(32,1))*troty(DHoffset(33,1))*trotz(DHoffset(34,1));
% Origin_TH=Origin*transl(DHoffset(18,2),DHoffset(19,2),DHoffset(20,2))*trotx(DHoffset(21,2))*troty(DHoffset(22,2))*trotz(DHoffset(23,2));
% Origin_MI=Origin*transl(DHoffset(18,3),DHoffset(19,3),DHoffset(20,3))*trotx(DHoffset(21,3))*troty(DHoffset(22,3))*trotz(DHoffset(23,3));
% Origin_TH=Origin*transl(-86.71,-28.55,-22.75)*trotz(24*pi/180)*trotx(-75*pi/180)*troty(54*pi/180)*trotz(pi/4);
% Origin_MI=Origin*transl(0,0,20.1);%*trotz(5*pi/180);
% Origin_TH=Origin*transl(-90.98,-25.14,-23.51)*trotx(-pi/2)*trotz(pi/3)*trotx(pi/6);

%% Calibration - Index
% Bx가 0인 3D magnetic sensor data (3x18)
data=csvread('Optimizing_Right02_191004.csv');

% 
alpha=0;
beta=0;
gamma=1;

%thumb, index, middle finger number 
T1=1;
T2=0;
I1=2;
I2=3;
M1=4;
M2=5;
    
iter=2;

% magnitude of index proximal 3D sensor
mag=sqrt(data(iter,I1*3+1)^2+data(iter,I1*3+2)^2+data(iter,I1*3+3)^2);

% normalized Bx, By of index proximal(IP) 3D magnetic sensors 
a=data(iter,I1*3+1)/mag; % normalized Bx
b=data(iter,I1*3+2)/mag; % normalized By


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

mag=sqrt(data(iter,I2*3+1)^2+data(iter,I2*3+2)^2+data(iter,I2*3+3)^2);
a=data(iter,I2*3+1)/mag;
b=data(iter,I2*3+2)/mag;

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

off_TH1=0;
off_TH2=TH2(iter);
off_TH3=TH3(iter);
off_TH4=0;

%% Calibration - Thumb
iter=1;

mag=sqrt(data(iter,T1*3+1)^2+data(iter,T1*3+2)^2+data(iter,T1*3+3)^2);
a=data(iter,T1*3+1)/mag;
b=data(iter,T1*3+2)/mag;

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
    
mag=sqrt(data(iter,T2*3+1)^2+data(iter,T2*3+2)^2+data(iter,T2*3+3)^2);
a=data(iter,T2*3+1)/mag;
b=data(iter,T2*3+2)/mag;

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

off_TH1_TH=0;
off_TH2_TH=TH2_TH(iter);
off_TH3_TH=TH3_TH(iter);
off_TH4_TH=0;

%% Calibration - Middle
iter=3;

mag=sqrt(data(iter,M1*3+1)^2+data(iter,M1*3+2)^2+data(iter,M1*3+3)^2);
a=data(iter,M1*3+1)/mag;
b=data(iter,M1*3+2)/mag;

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
    
mag=sqrt(data(iter,M2*3+1)^2+data(iter,M2*3+2)^2+data(iter,M2*3+3)^2);
a=data(iter,M2*3+1)/mag;
b=data(iter,M2*3+2)/mag;

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

off_TH1_MI=0;
off_TH2_MI=TH2_MI(iter);
off_TH3_MI=TH3_MI(iter);
off_TH4_MI=0;

fileID = fopen('offdata_right.txt', 'w');
fprintf(fileID, '%0.8f\r\n', off_TH2);
fprintf(fileID, '%0.8f\r\n', off_TH3);
fprintf(fileID, '%0.8f\r\n', off_TH2_MI);
fprintf(fileID, '%0.8f\r\n', off_TH3_MI);
fprintf(fileID, '%0.8f\r\n', off_TH2_TH);
fprintf(fileID, '%0.8f\r\n', off_TH3_TH);
fclose(fileID);

disp('offset calculation finished')
% off_TH1=0;
% off_TH2=0;
% off_TH3=0;
% off_TH4=0;
% 
% off_TH1_TH=0;
% off_TH2_TH=0;
% off_TH3_TH=0;
% off_TH4_TH=0;
% 
% off_TH1_MI=0;
% off_TH2_MI=0;
% off_TH3_MI=0;
% off_TH4_MI=0;