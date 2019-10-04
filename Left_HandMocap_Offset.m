clc, clear, close ('all')
%% 수정 전 Finger Information
% l1=24.2;
% l2=56.03;
% l3=12.94;
% l4=57.5;
% l5=19.5;
% l6=17.04;
% l7=-7.3;
% l8=18.8;
% 
% l1_TH=24.2;
% l2_TH=56.03;
% l3_TH=12.94;
% l4_TH=57.5;
% l5_TH=19.5;
% l6_TH=19.63;
% l7_TH=8.65;
% l8_TH=18.15;
% 
% l1_MI=24.2;
% l2_MI=56.03;
% l3_MI=12.94;
% l4_MI=57.5;
% l5_MI=19.5;
% l6_MI=17.04;
% l7_MI=-7.3;
% l8_MI=18.8;

%% 수정 후 Finger Information
% l1=24.2;
% l2=66.03;
% l3=12.94;
% l4=37.7;
% l5=18.81;
% l6=17.04;
% l7=-7.3;
% l8=18.8;
% 
% l1_TH=24.2;
% l2_TH=86.03;
% l3_TH=12.94;
% l4_TH=47.7;
% l5_TH=18.81;
% l6_TH=19.63;
% l7_TH=8.65;
% l8_TH=18.15;
% 
% l1_MI=24.2;
% l2_MI=66.03;
% l3_MI=12.94;
% l4_MI=37.7;
% l5_MI=18.81;
% l6_MI=17.04;
% l7_MI=-7.3; 
% l8_MI=18.8;
% 
% %% 수정 후 Finger Information
% l1=24.2;
% l2=54.63;
% l3=12.94;
% l4=57.5;
% l5=19.75;
% l6=17.04;
% l7=7.3;
% l8=19.05;
% 
% l1_TH=24.2;
% l2_TH=54.63;
% l3_TH=12.94;
% l4_TH=57.5;
% l5_TH=19.75;
% l6_TH=19.63;
% l7_TH=-8.65;
% l8_TH=18.40;
% 
% l1_MI=24.2;
% l2_MI=54.63;
% l3_MI=12.94;
% l4_MI=57.5;
% l5_MI=19.75;
% l6_MI=17.04;
% l7_MI=7.3; 
% l8_MI=19.05;

%% LEFT FINGER_Siggraph 2018
% l1=24.2;
% l2=56.03;
% l3=12.94;
% l4=47.5;
% l5=18.5;
% l6=23.5;
% l7=10.37;
% l8=16.5;
% 
% l1_TH=24.2;
% l2_TH=56.03;
% l3_TH=12.94;
% l4_TH=57.5;
% l5_TH=18.5;
% l6_TH=26.5;
% l7_TH=-10.37;
% l8_TH=16.5;
% 
% l1_MI=24.2;
% l2_MI=56.03;
% l3_MI=12.94;
% l4_MI=47.5;
% l5_MI=18.5;
% l6_MI=25;
% l7_MI=10.37;
% l8_MI=16.5;

%% LEFT FINGER_Revised_190114

l1=24.2;
l2=56.03;
l3=12.94;
l4=47.5;
l5=19.5;
l6=22.96;
l7=10.42;
l8=16.61;

l1_TH=24.2;
l2_TH=56.03;
l3_TH=12.94;
l4_TH=57.5;
l5_TH=19.5;
l6_TH=24.82;
l7_TH=-10.42;
l8_TH=16.61;

l1_MI=24.2;
l2_MI=56.03;
l3_MI=12.94;
l4_MI=47.5;
l5_MI=19.5;
l6_MI=22.93;
l7_MI=10.42;
l8_MI=16.61;

data=csvread('Optimizing_Left01_190529.csv');

T1=4;
T2=5;
I1=2;
I2=3;
M1=1;
M2=0;

%DHoffset = csvread('06_DHoffset_new1.csv');

DHoffset = [  0.0012074825676583728521674094448227,   0.00052198362071073768353423056793913,  -0.0011130189558259645658534387229779;
  -0.048309601429470525496490473961487,     0.027438568529556801550261528788044,      0.1416499485492137819617324027455;
  -0.021422650432508553729380002298341,   -0.0012975155744851763695086605117814,   0.0039011170991027507186783110141437;
    -1.3036468979621023999276147737418,      -1.4687987326093689292583436021114,     -1.4849854928684995117040516266161;
   0.028722161830125799506141551216128,    0.0076295221286645467912119428446615,  -0.0042577695028191022429098295635683;
     24.178214337437784486787517959004,       24.198752337094763157933588141457,      24.203991727406997320190034057848;
     1.8118407844788050009895874782998,       1.6752583213877271171869494383101,      1.6379806109649091090365540497445;
 -0.0039355009738564783478112430005818, -0.000037545590103683771658575239770638, -0.00031974890632322502583608403493971;
    0.18578093653326754020313070749067,     -0.08777570634404407802029289875061,   -0.023473545740185864485030974829149;
 -0.0012521251475238082017975843738502,  -0.00028721414186987915407136645910674, -0.00030424860740135161771898612861265;
     47.470321921837436939046451407136,       57.492443950803324890774966227626,      47.502873638158395829122547283698;
    0.19082243580387290409687776442002,    -0.014322748336079967726793018407528,   -0.043694100582336722330285360154935;
  0.0015351136223070845410795031198205,   -0.0002952862972670708013373713597788, -0.00023300417055591119119535517418556;
  0.0015351136223070845410795031198205,   -0.0002952862972670708013373713597788, -0.00023300417055591119119535517418556;
    -2.3662676724202694382480958425279,      -1.7783899989941779137342292598574,     -1.4740216513311911023162217977329;
     22.992036560003528639387708920971,       24.821087856825926651068839996354,      22.924157914588629534727440868844;
    0.16123194527612377739462618212563,    -0.089150850529897582223716252312941,  -0.0036709622392361199927183888957278;
                                     0,      -88.756323255248037067405534845854,   0.0042629327087185135654676602488083;
                                     0,      -29.036722600490397290004293891766,  -0.0037080433711787746286487799951941;
                                     0,       24.352794090689240584097906979933,     -19.001334039635090947288402929394;
                                     0,       1.4160682669090239822282168898334,    0.085160204907880809207866671736831;
                                    0,        -0.43849211032278987098967384613,    0.048082349426853707568562475409799;
                                     0,      0.93537088240798401224629310836122,      0.1416499485492137819617324027455];

 




Origin=[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];%*transl(DHoffset(29,1),DHoffset(30,1),DHoffset(31,1))*trotx(DHoffset(32,1))*troty(DHoffset(33,1))*trotz(DHoffset(34,1));
Origin_TH=Origin*transl(DHoffset(18,2),DHoffset(19,2),DHoffset(20,2))*trotx(DHoffset(21,2))*troty(DHoffset(22,2))*trotz(DHoffset(23,2));
Origin_MI=Origin*transl(DHoffset(18,3),DHoffset(19,3),DHoffset(20,3))*trotx(DHoffset(21,3))*troty(DHoffset(22,3))*trotz(DHoffset(23,3));
% Origin_TH=Origin*transl(-88.75,-29.04,24.35)*trotz(24*pi/180)*trotx(75*pi/180)*troty(-54*pi/180)*trotz(pi/4);
% Origin_MI=Origin*transl(0,0,-19);%*trotz(5*pi/180);

% Calibration - Index
alpha=0;
beta=0;
gamma=1;
    
iter=2;

mag=sqrt(data(iter,I1*3+1)^2+data(iter,I1*3+2)^2+data(iter,I1*3+3)^2);
a=data(iter,I1*3+1)/mag;
b=data(iter,I1*3+2)/mag;

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
Y_ar(iter) = sin(TH1(iter))*alpha+cos(TH1(iter))*gamma;

if Y(iter)*Y(iter)+beta*beta-b*b<0
    TH2(iter)=atan2(b,0)-atan2(beta,Y(iter));
else
    TH2(iter)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
    TH2_ar(iter)=atan2(b,sqrt(Y_ar(iter)*Y_ar(iter)+beta*beta-b*b))-atan2(Y_ar(iter), beta);
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

% Calibration - Thumb
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

% Calibration - Middle
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

fileID = fopen('offdata_left.txt', 'w');
fprintf(fileID, '%0.8f\r\n', off_TH2);
fprintf(fileID, '%0.8f\r\n', off_TH3);
fprintf(fileID, '%0.8f\r\n', off_TH2_MI);
fprintf(fileID, '%0.8f\r\n', off_TH3_MI);
fprintf(fileID, '%0.8f\r\n', off_TH2_TH);
fprintf(fileID, '%0.8f\r\n', off_TH3_TH);
fclose(fileID);

% 
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