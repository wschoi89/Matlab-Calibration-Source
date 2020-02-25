clc, clear, close ('all')

%% Calibration - Index
% Bx°¡ 0ÀÎ 3D magnetic sensor data (3x18)
data=csvread('Optimizing_Right02_200221.csv');

data_thumb = data(1:10, 1:18);
data_index = data(11:20, 1:18);
data_middle = data(21:30, 1:18);

data = [mean(data_thumb);mean(data_index);mean(data_middle);];
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

fprintf('off_TH2    : %0.8f\n', off_TH2);
fprintf('off_TH3    : %0.8f\n', off_TH3);
fprintf('off_TH2_MI : %0.8f\n', off_TH2_MI);
fprintf('off_TH3_MI : %0.8f\n', off_TH3_MI);
fprintf('off_TH2_TH : %0.8f\n', off_TH2_TH);
fprintf('off_TH3_TH : %0.8f\n', off_TH3_TH);

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