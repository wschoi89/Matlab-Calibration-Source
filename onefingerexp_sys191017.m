clc, clear, close ('all')

data4=csvread('data_11111111_190508.csv');
M=size(data4);
alpha=0;
beta=0;
gamma=1;

iteration=5;
% 
% l1=24.2;
% l2=56.03;
% l3=12.94;
% l4=57.5;
% l5=19.5;
% l6=41;


l1=24.2;
l2=56.03;
l3=12.94;
l4=57.5;
l5=17.25;
l6=35.308;

% l1=24.2;
% l2=56.03;
% l3=12.94;
% l4=57.5;
% l5=17.25;
% l6=31.158;
% 
% GroundTruth = [74.8306 -34 -64.0664 0 1 0;
% 	74.8306 -34 64.0664 0 1 0;
% 	94.3944 -34 -34.7872 0 1 0;
% 	94.3944 -34 34.7872 0 1 0;
% 	101.2643 -34 0.25 0 1 0;
% 	121.8798 -34 -46.1720 0 1 0;
% 	121.8798 -34 46.1720 0 1 0;
% 	131.0143 -34 0.25 0 1 0]';
% 

%% Latest Version 
% GroundTruth = [101.2643 -34 -0.25 0 1 0;
% 	101.2643 -34 -0.25 0 1 0;
% 	101.2643 -34 -0.25 0 1 0;
% 	101.2643 -34 -0.25 0 1 0;
% 	101.2643 -34 -0.25 0 1 0;
% 	101.2643 -34 -0.25 0 1 0;
% 	101.2643 -34 -0.25 0 1 0;
% 	101.2643 -34 -0.25 0 1 0]';

GroundTruth = [131.2643 -34 -0.25 0 1 0;
               131.2643 -34 -0.25 0 1 0;
               131.2643 -34 -0.25 0 1 0;
               131.2643 -34 -0.25 0 1 0;
               131.2643 -34 -0.25 0 1 0;
               131.2643 -34 -0.25 0 1 0;
               131.2643 -34 -0.25 0 1 0;
               131.2643 -34 -0.25 0 1 0]';

off_TH1=0;
off_TH2=0;
off_TH3=0;
off_TH4=0;

lambda=1000;

syms A0 B0 C0 D0 A1 B1 C1 D1 A2 B2 C2 D2 A3 B3 C3 D3 A4 B4 C4 D4 A5 B5 C5 D5 A6 B6 C6 D6 A7 B7 C7 D7 A8 B8 C8 D8


Origin=[1 0 0 0;
        0 1 0 0;
        0 0 1 0;
        0 0 0 1];%% initial values

% q_double=[0 0 0 -pi/2 0  l1 pi/2 0 0 0 l4 0 0 0 -pi/2 l6 0 0 0 0 0]; %% initial values

q_double=[0 0 0 -pi/2 0  l1 pi/2 0 0 0 l4 0 0 0 -pi/2 l6 0 off_TH1 off_TH2 off_TH3 off_TH4]; %% initial values

DHinit=q_double;

qRef=[A1 B1 C1 D1 A2 C2 D2 A3 D4 A5 C5 D5 A6 A7 B7 C7 D7 0 0 0 0]';

% DHRef = [A1 B1 C1 D1; A2 B2+A0 C2 D2; A3 B3+B0 C3 D3; A4 B4 C4 D4; A5 B5+C0 C5 D5; A6 B6+D0 C6 D6; A7 B7 C7 D7; A8 B8 C8 D8];
DHRef = [A1 B1 C1 D1;
         A2 B2 C2 D2;
         A3 B3 C3 D3;
         A4 B4 C4 D4;
         A5 B5 C5 D5;
         A6 B6 C6 D6;
         A7 B7 C7 D7;
         A8 B8 C8 D8];

R01=transl(0,0,DHRef(1,1))*[cos(DHRef(1,2)) -sin(DHRef(1,2)) 0 0; sin(DHRef(1,2)) cos(DHRef(1,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(1,3),0,0)*[1 0 0 0; 0 cos(DHRef(1,4)) -sin(DHRef(1,4)) 0; 0 sin(DHRef(1,4)) cos(DHRef(1,4)) 0; 0 0 0 1];
R12=transl(0,0,DHRef(2,1))*[cos(DHRef(2,2)) -sin(DHRef(2,2)) 0 0; sin(DHRef(2,2)) cos(DHRef(2,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(2,3),0,0)*[1 0 0 0; 0 cos(DHRef(2,4)) -sin(DHRef(2,4)) 0; 0 sin(DHRef(2,4)) cos(DHRef(2,4)) 0; 0 0 0 1];
R23=transl(0,0,DHRef(3,1))*[cos(DHRef(3,2)) -sin(DHRef(3,2)) 0 0; sin(DHRef(3,2)) cos(DHRef(3,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(3,3),0,0)*[1 0 0 0; 0 cos(DHRef(3,4)) -sin(DHRef(3,4)) 0; 0 sin(DHRef(3,4)) cos(DHRef(3,4)) 0; 0 0 0 1];
R34=transl(0,0,DHRef(4,1))*[cos(DHRef(4,2)) -sin(DHRef(4,2)) 0 0; sin(DHRef(4,2)) cos(DHRef(4,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(4,3),0,0)*[1 0 0 0; 0 cos(DHRef(4,4)) -sin(DHRef(4,4)) 0; 0 sin(DHRef(4,4)) cos(DHRef(4,4)) 0; 0 0 0 1];
R45=transl(0,0,DHRef(5,1))*[cos(DHRef(5,2)) -sin(DHRef(5,2)) 0 0; sin(DHRef(5,2)) cos(DHRef(5,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(5,3),0,0)*[1 0 0 0; 0 cos(DHRef(5,4)) -sin(DHRef(5,4)) 0; 0 sin(DHRef(5,4)) cos(DHRef(5,4)) 0; 0 0 0 1];
R56=transl(0,0,DHRef(6,1))*[cos(DHRef(6,2)) -sin(DHRef(6,2)) 0 0; sin(DHRef(6,2)) cos(DHRef(6,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(6,3),0,0)*[1 0 0 0; 0 cos(DHRef(6,4)) -sin(DHRef(6,4)) 0; 0 sin(DHRef(6,4)) cos(DHRef(6,4)) 0; 0 0 0 1];
R67=transl(0,0,DHRef(7,1))*[cos(DHRef(7,2)) -sin(DHRef(7,2)) 0 0; sin(DHRef(7,2)) cos(DHRef(7,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(7,3),0,0)*[1 0 0 0; 0 cos(DHRef(7,4)) -sin(DHRef(7,4)) 0; 0 sin(DHRef(7,4)) cos(DHRef(7,4)) 0; 0 0 0 1];
R78=transl(0,0,DHRef(8,1))*[cos(DHRef(8,2)) -sin(DHRef(8,2)) 0 0; sin(DHRef(8,2)) cos(DHRef(8,2)) 0 0; 0 0 1 0; 0 0 0 1]*transl(DHRef(8,3),0,0)*[1 0 0 0; 0 cos(DHRef(8,4)) -sin(DHRef(8,4)) 0; 0 sin(DHRef(8,4)) cos(DHRef(8,4)) 0; 0 0 0 1];

OriginRef=eye(4);

R7=OriginRef*R01*R12*R23*R34*R45*R56*R67*R78;
Joint7Ref=[R7(1,4); R7(2,4); R7(3,4); R7(1,2); R7(2,2); R7(3,2)];

% ccode(Joint7Ref,'file','Joint7Ref3.txt');
% 'Joint7Ref written'

JacobianMatRef = [diff(Joint7Ref(1),A1) diff(Joint7Ref(1),B1) diff(Joint7Ref(1),C1) diff(Joint7Ref(1),D1) diff(Joint7Ref(1),A2) diff(Joint7Ref(1),C2) diff(Joint7Ref(1),D2) diff(Joint7Ref(1),A3) diff(Joint7Ref(1),D4) diff(Joint7Ref(1),A5) diff(Joint7Ref(1),C5) diff(Joint7Ref(1),D5) diff(Joint7Ref(1),A6) diff(Joint7Ref(1),A7) diff(Joint7Ref(1),B7) diff(Joint7Ref(1),C7) diff(Joint7Ref(1),D7) diff(Joint7Ref(1),off_TH1) diff(Joint7Ref(1),off_TH2) diff(Joint7Ref(1),off_TH3) diff(Joint7Ref(1),off_TH4); 
                  diff(Joint7Ref(2),A1) diff(Joint7Ref(2),B1) diff(Joint7Ref(2),C1) diff(Joint7Ref(2),D1) diff(Joint7Ref(2),A2) diff(Joint7Ref(2),C2) diff(Joint7Ref(2),D2) diff(Joint7Ref(2),A3) diff(Joint7Ref(2),D4) diff(Joint7Ref(2),A5) diff(Joint7Ref(2),C5) diff(Joint7Ref(2),D5) diff(Joint7Ref(2),A6) diff(Joint7Ref(2),A7) diff(Joint7Ref(2),B7) diff(Joint7Ref(2),C7) diff(Joint7Ref(2),D7) diff(Joint7Ref(2),off_TH1) diff(Joint7Ref(2),off_TH2) diff(Joint7Ref(2),off_TH3) diff(Joint7Ref(2),off_TH4); 
                  diff(Joint7Ref(3),A1) diff(Joint7Ref(3),B1) diff(Joint7Ref(3),C1) diff(Joint7Ref(3),D1) diff(Joint7Ref(3),A2) diff(Joint7Ref(3),C2) diff(Joint7Ref(3),D2) diff(Joint7Ref(3),A3) diff(Joint7Ref(3),D4) diff(Joint7Ref(3),A5) diff(Joint7Ref(3),C5) diff(Joint7Ref(3),D5) diff(Joint7Ref(3),A6) diff(Joint7Ref(3),A7) diff(Joint7Ref(3),B7) diff(Joint7Ref(3),C7) diff(Joint7Ref(3),D7) diff(Joint7Ref(3),off_TH1) diff(Joint7Ref(3),off_TH2) diff(Joint7Ref(3),off_TH3) diff(Joint7Ref(3),off_TH4);
                  diff(Joint7Ref(4),A1) diff(Joint7Ref(4),B1) diff(Joint7Ref(4),C1) diff(Joint7Ref(4),D1) diff(Joint7Ref(4),A2) diff(Joint7Ref(4),C2) diff(Joint7Ref(4),D2) diff(Joint7Ref(4),A3) diff(Joint7Ref(4),D4) diff(Joint7Ref(4),A5) diff(Joint7Ref(4),C5) diff(Joint7Ref(4),D5) diff(Joint7Ref(4),A6) diff(Joint7Ref(4),A7) diff(Joint7Ref(4),B7) diff(Joint7Ref(4),C7) diff(Joint7Ref(4),D7) diff(Joint7Ref(4),off_TH1) diff(Joint7Ref(4),off_TH2) diff(Joint7Ref(4),off_TH3) diff(Joint7Ref(4),off_TH4);
                  diff(Joint7Ref(5),A1) diff(Joint7Ref(5),B1) diff(Joint7Ref(5),C1) diff(Joint7Ref(5),D1) diff(Joint7Ref(5),A2) diff(Joint7Ref(5),C2) diff(Joint7Ref(5),D2) diff(Joint7Ref(5),A3) diff(Joint7Ref(5),D4) diff(Joint7Ref(5),A5) diff(Joint7Ref(5),C5) diff(Joint7Ref(5),D5) diff(Joint7Ref(5),A6) diff(Joint7Ref(5),A7) diff(Joint7Ref(5),B7) diff(Joint7Ref(5),C7) diff(Joint7Ref(5),D7) diff(Joint7Ref(5),off_TH1) diff(Joint7Ref(5),off_TH2) diff(Joint7Ref(5),off_TH3) diff(Joint7Ref(5),off_TH4);
                  diff(Joint7Ref(6),A1) diff(Joint7Ref(6),B1) diff(Joint7Ref(6),C1) diff(Joint7Ref(6),D1) diff(Joint7Ref(6),A2) diff(Joint7Ref(6),C2) diff(Joint7Ref(6),D2) diff(Joint7Ref(6),A3) diff(Joint7Ref(6),D4) diff(Joint7Ref(6),A5) diff(Joint7Ref(6),C5) diff(Joint7Ref(6),D5) diff(Joint7Ref(6),A6) diff(Joint7Ref(6),A7) diff(Joint7Ref(6),B7) diff(Joint7Ref(6),C7) diff(Joint7Ref(6),D7) diff(Joint7Ref(6),off_TH1) diff(Joint7Ref(6),off_TH2) diff(Joint7Ref(6),off_TH3) diff(Joint7Ref(6),off_TH4)];

% ccode(JacobianMatRef,'file','JacobianMatRef3.txt');
% 'JacobianMatRef written'

for iter=1000:1000:M(1,1)
    disp(strcat('iteration : ', num2str(iter)));
	mag=sqrt(data4(iter/1000,1)^2+data4(iter/1000,2)^2+data4(iter/1000,3)^2);
	a=data4(iter/1000,1)/mag;
	b=data4(iter/1000,2)/mag;

	X=atan2(gamma,alpha);
	if alpha*alpha+gamma*gamma-a*a>0
		TH1(iter/1000)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
	else
		TH1(iter/1000)=atan2(0,a)-X;
	end

	if TH1(iter/1000)>pi/2
		TH1(iter/1000)=pi/2;
	elseif TH1(iter/1000)<-pi/2
		TH1(iter/1000)=-pi/2;
	end

	Y(iter/1000)=-sin(TH1(iter/1000))*alpha+cos(TH1(iter/1000))*gamma;
	if Y(iter/1000)*Y(iter/1000)+beta*beta-b*b<0
		TH2(iter/1000)=atan2(b,0)-atan2(beta,Y(iter/1000));
	else
		TH2(iter/1000)=atan2(b,sqrt(Y(iter/1000)*Y(iter/1000)+beta*beta-b*b))-atan2(beta,Y(iter/1000));
	end

	if TH2(iter/1000)>pi/2
		TH2(iter/1000)=pi/2;
	elseif TH2(iter/1000)<-pi/2
		TH2(iter/1000)=-pi/2;
	end

	mag=sqrt(data4(iter/1000,4)^2+data4(iter/1000,5)^2+data4(iter/1000,6)^2);
	a=data4(iter/1000,4)/mag;
	b=data4(iter/1000,5)/mag;

	X=atan2(alpha,gamma);
	if alpha*alpha+gamma*gamma-a*a>0
		TH4(iter/1000)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
	else
		TH4(iter/1000)=atan2(a,0)-X;
	end

	if TH4(iter/1000)>pi/2
		TH4(iter/1000)=pi/2;
	elseif TH4(iter/1000)<-pi/2
		TH4(iter/1000)=-pi/2;
	end


	Y(iter/1000)=-sin(TH4(iter/1000))*alpha+cos(TH4(iter/1000))*gamma;
	if Y(iter/1000) == 0
		Y(iter/1000)=0.00001;
	end
	if Y(iter/1000)*Y(iter/1000)+beta*beta-b*b<0
		TH3(iter/1000)=atan2(0,b)-atan2(Y(iter/1000),beta);
	else
		TH3(iter/1000)=atan2(sqrt(Y(iter/1000)*Y(iter/1000)+beta*beta-b*b),b)-atan2(Y(iter/1000),beta);
	end

	if TH3(iter/1000)>pi/2
		TH3(iter/1000)=pi/2;
	elseif TH3(iter/1000)<-pi/2
		TH3(iter/1000)=-pi/2;
	end

	TH4(iter/1000)=TH4(iter/1000)+pi/4;

    TH1(iter/1000) = TH1(iter/1000)+off_TH1;
    TH2(iter/1000) = TH2(iter/1000)+off_TH2;
    TH3(iter/1000) = TH3(iter/1000)+off_TH3;
    TH4(iter/1000) = TH4(iter/1000)+off_TH4;
% 	A0=q_double(18); B0=q_double(19); C0=q_double(20); D0=q_double(21);
%     A1=q_double(1); B1=q_double(2); C1=q_double(3); D1=q_double(4);
%     A2=q_double(5); B2=TH1(iter/1000)+q_double(18); C2=q_double(6); D2=q_double(7);
%     A3=q_double(8); B3=TH2(iter/1000)+q_double(19); C3=l2; D3=0;
%     A4=0; B4=-pi/2; C4=l3; D4=q_double(9);
%     A5=q_double(10); B5=TH3(iter/1000)+q_double(20); C5=q_double(11); D5=q_double(12);
%     A6=q_double(13); B6=TH4(iter/1000)+q_double(21); C6=l5; D6=0;
%     A7=q_double(14); B7=q_double(15); C7=q_double(16); D7=q_double(17);
%     A8=0; B8=pi/2; C8=0; D8=0; 

%     A0=q_double(18); B0=q_double(19); C0=q_double(20); D0=q_double(21);
    A1=q_double(1); B1=q_double(2); C1=q_double(3); D1=q_double(4);
    A2=q_double(5); B2=TH1(iter/1000); C2=q_double(6); D2=q_double(7);
    A3=q_double(8); B3=TH2(iter/1000); C3=l2; D3=0;
    A4=0; B4=-pi/2; C4=l3; D4=q_double(9);
    A5=q_double(10); B5=TH3(iter/1000); C5=q_double(11); D5=q_double(12);
    A6=q_double(13); B6=TH4(iter/1000); C6=l5; D6=0;
    A7=q_double(14); B7=q_double(15); C7=q_double(16); D7=q_double(17);
    A8=0; B8=pi/2; C8=0; D8=0; 


    Joint7= subs(Joint7Ref);
    Joint7 = vpa(Joint7);
    
    
    for i=1:iteration
        error=GroundTruth(:,iter/1000)-Joint7;
        disp(strcat('error : ', num2str(double(error(1)))));
        JacobianMat=subs(JacobianMatRef);
        JacobianMat=vpa(JacobianMat);

        dq_=(JacobianMat*JacobianMat'+lambda*eye(6))\error;
        dq=JacobianMat'*dq_;
        q_double=subs(qRef);
        q_double=vpa(q_double+dq);

% 		A0=q_double(18); B0=q_double(19); C0=q_double(20); D0=q_double(21);
		A1=q_double(1); B1=q_double(2); C1=q_double(3); D1=q_double(4);
		A2=q_double(5); B2=TH1(iter/1000); C2=q_double(6); D2=q_double(7);
		A3=q_double(8); B3=TH2(iter/1000); C3=l2; D3=0;
		A4=0; B4=-pi/2; C4=l3; D4=q_double(9);
		A5=q_double(10); B5=TH3(iter/1000); C5=q_double(11); D5=q_double(12);
		A6=q_double(13); B6=TH4(iter/1000); C6=l5; D6=0;
		A7=q_double(14); B7=q_double(15); C7=q_double(16); D7=q_double(17);
		A8=0; B8=pi/2; C8=0; D8=0;
    
        Joint7=subs(Joint7Ref);
        Joint7=vpa(Joint7);
    end
end

DHoff=[subs(q_double)];

for iter=1000:1000:M(1,1)
    
    mag=sqrt(data4(iter/1000,1)^2+data4(iter/1000,2)^2+data4(iter/1000,3)^2);
	a=data4(iter/1000,1)/mag;
	b=data4(iter/1000,2)/mag;

	X=atan2(gamma,alpha);
	if alpha*alpha+gamma*gamma-a*a>0
		TH1(iter/1000)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
	else
		TH1(iter/1000)=atan2(0,a)-X;
	end

	if TH1(iter/1000)>pi/2
		TH1(iter/1000)=pi/2;
	elseif TH1(iter/1000)<-pi/2
		TH1(iter/1000)=-pi/2;
	end

	Y(iter/1000)=-sin(TH1(iter/1000))*alpha+cos(TH1(iter/1000))*gamma;
	if Y(iter/1000)*Y(iter/1000)+beta*beta-b*b<0
		TH2(iter/1000)=atan2(b,0)-atan2(beta,Y(iter/1000));
	else
		TH2(iter/1000)=atan2(b,sqrt(Y(iter/1000)*Y(iter/1000)+beta*beta-b*b))-atan2(beta,Y(iter/1000));
	end

	if TH2(iter/1000)>pi/2
		TH2(iter/1000)=pi/2;
	elseif TH2(iter/1000)<-pi/2
		TH2(iter/1000)=-pi/2;
	end

	mag=sqrt(data4(iter/1000,4)^2+data4(iter/1000,5)^2+data4(iter/1000,6)^2);
	a=data4(iter/1000,4)/mag;
	b=data4(iter/1000,5)/mag;

	X=atan2(alpha,gamma);
	if alpha*alpha+gamma*gamma-a*a>0
		TH4(iter/1000)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
	else
		TH4(iter/1000)=atan2(a,0)-X;
	end

	if TH4(iter/1000)>pi/2
		TH4(iter/1000)=pi/2;
	elseif TH4(iter/1000)<-pi/2
		TH4(iter/1000)=-pi/2;
	end


	Y(iter/1000)=-sin(TH4(iter/1000))*alpha+cos(TH4(iter/1000))*gamma;
	if Y(iter/1000) == 0
		Y(iter/1000)=0.00001;
	end
	if Y(iter/1000)*Y(iter/1000)+beta*beta-b*b<0
		TH3(iter/1000)=atan2(0,b)-atan2(Y(iter/1000),beta);
	else
		TH3(iter/1000)=atan2(sqrt(Y(iter/1000)*Y(iter/1000)+beta*beta-b*b),b)-atan2(Y(iter/1000),beta);
	end

	if TH3(iter/1000)>pi/2
		TH3(iter/1000)=pi/2;
	elseif TH3(iter/1000)<-pi/2
		TH3(iter/1000)=-pi/2;
	end

	TH4(iter/1000)=TH4(iter/1000)+pi/4;

    
    TH1(iter/1000) = TH1(iter/1000)+off_TH1;
    TH2(iter/1000) = TH2(iter/1000)+off_TH2;
    TH3(iter/1000) = TH3(iter/1000)+off_TH3;
    TH4(iter/1000) = TH4(iter/1000)+off_TH4;
    
% 	A0=q_double(18); B0=q_double(19); C0=q_double(20); D0=q_double(21);
    A1=q_double(1);  B1=q_double(2);    C1=q_double(3);  D1=q_double(4);
    A2=q_double(5);  B2=TH1(iter/1000); C2=q_double(6);  D2=q_double(7);
    A3=q_double(8);  B3=TH2(iter/1000); C3=l2;           D3=0;
    A4=0;            B4=-pi/2;          C4=l3;           D4=q_double(9);
    A5=q_double(10); B5=TH3(iter/1000); C5=q_double(11); D5=q_double(12);
    A6=q_double(13); B6=TH4(iter/1000); C6=l5;           D6=0;
    A7=q_double(14); B7=q_double(15);   C7=q_double(16); D7=q_double(17);
    A8=0;            B8=pi/2;           C8=0;            D8=0; 
    
    Joint7= subs(Joint7Ref);
    Joint7 = vpa(Joint7);
    
    Results(:,iter/1000)=GroundTruth(:,iter/1000)-Joint7;
end

DHoff=[subs(q_double)];

DHinit'-double(DHoff)
