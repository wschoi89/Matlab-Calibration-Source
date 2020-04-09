function jointAngle = getJointAngle(magnetic_data)
% 3D magnetic sensor에서 얻은 data를 이용해 joint angle 계산하는 함수

    % 이상적인 조립 상황에서의 normalized magnet sensor data값
    alpha=0;
    beta=0;
    gamma=1;
    
    num_fingers = 3;
    num_joints_per_finger = 4;
    
    %thumb, index, middle finger number 
    T1=1;
    T2=0;
    I1=2;
    I2=3;
    M1=4;
    M2=5;
    
    length = size(magnetic_data, 1);
    jointAngle = zeros(length, num_joints_per_finger*num_fingers);
    
    
    for iter=1:length
       %%  Thumb 
        mag=sqrt(magnetic_data(iter,T1*3+1)^2+magnetic_data(iter,T1*3+2)^2+magnetic_data(iter,T1*3+3)^2);
        a=magnetic_data(iter,T1*3+1)/mag;
        b=magnetic_data(iter,T1*3+2)/mag;

        X=atan2(gamma,alpha);
        if alpha*alpha+gamma*gamma-a*a>0
            jointAngle(iter,1)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
        else
            jointAngle(iter,1)=atan2(0,a)-X;
        end

        if jointAngle(iter,1)>pi/2
            jointAngle(iter,1)=pi/2;
        elseif jointAngle(iter,1)<-pi/2
            jointAngle(iter,1)=-pi/2;
        end
        
        % Y is X_1 in IEEE VR
        Y(iter)=sin(jointAngle(iter,1))*alpha+cos(jointAngle(iter,1))*gamma;
        if Y(iter)*Y(iter)+beta*beta-b*b<0
            jointAngle(iter,2)=atan2(b,0)-atan2(beta,Y(iter));
        else
            jointAngle(iter,2)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
        end

        if jointAngle(iter,2)>pi/2
            jointAngle(iter,2)=pi/2;
        elseif jointAngle(iter,2)<-pi/2
            jointAngle(iter,2)=-pi/2;
        end

        mag=sqrt(magnetic_data(iter,T2*3+1)^2+magnetic_data(iter,T2*3+2)^2+magnetic_data(iter,T2*3+3)^2);
        a=magnetic_data(iter,T2*3+1)/mag;
        b=magnetic_data(iter,T2*3+2)/mag;

        X=atan2(alpha,gamma);
        if alpha*alpha+gamma*gamma-a*a>0
            jointAngle(iter,4)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
        else
            jointAngle(iter,4)=atan2(a,0)-X;
        end

        if jointAngle(iter,4)>pi/2
            jointAngle(iter,4)=pi/2;
        elseif jointAngle(iter,4)<-pi/2
            jointAngle(iter,4)=-pi/2;
        end

        % thumb distal
        Y(iter)=-sin(jointAngle(iter,4))*alpha+cos(jointAngle(iter,4))*gamma;
        if Y(iter) == 0
            Y(iter)=0.00001;
        end
        if Y(iter)*Y(iter)+beta*beta-b*b<0
            jointAngle(iter,3)=atan2(0,b)-atan2(Y(iter),beta);
        else
            jointAngle(iter,3)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
        end

        if jointAngle(iter,3)>pi/2
            jointAngle(iter,3)=pi/2;
        elseif jointAngle(iter,3)<-pi/2
            jointAngle(iter,3)=-pi/2;
        end
    
        jointAngle(iter,4)=jointAngle(iter,4)+pi/4;
        
       %% index finger
        % index finger proximal
        mag=sqrt(magnetic_data(iter,I1*3+1)^2+magnetic_data(iter,I1*3+2)^2+magnetic_data(iter,I1*3+3)^2);
        a=magnetic_data(iter,I1*3+1)/mag;
        b=magnetic_data(iter,I1*3+2)/mag;

        X=atan2(gamma,alpha);
        if alpha*alpha+gamma*gamma-a*a>0
            jointAngle(iter,5)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
        else
            jointAngle(iter,5)=atan2(0,a)-X;
        end

        if jointAngle(iter,5)>pi/2
            jointAngle(iter,5)=pi/2;
        elseif jointAngle(iter,5)<-pi/2
            jointAngle(iter,5)=-pi/2;
        end
        
        Y(iter)=-sin(jointAngle(iter,5))*alpha+cos(jointAngle(iter,5))*gamma;
        if Y(iter)*Y(iter)+beta*beta-b*b<0
            jointAngle(iter,6)=atan2(b,0)-atan2(beta,Y(iter));
        else
            jointAngle(iter,6)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
        end

        if jointAngle(iter,6)>pi/2
            jointAngle(iter,6)=pi/2;
        elseif jointAngle(iter,6)<-pi/2
            jointAngle(iter,6)=-pi/2;
        end

        % index finger distal 
        mag=sqrt(magnetic_data(iter,I2*3+1)^2+magnetic_data(iter,I2*3+2)^2+magnetic_data(iter,I2*3+3)^2);
        a=magnetic_data(iter,I2*3+1)/mag;
        b=magnetic_data(iter,I2*3+2)/mag;

        X=atan2(alpha,gamma);
        if alpha*alpha+gamma*gamma-a*a>0
           jointAngle(iter,8)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
        else
            jointAngle(iter,8)=atan2(a,0)-X;
        end

        if jointAngle(iter,8)>pi/2
            jointAngle(iter,8)=pi/2;
        elseif jointAngle(iter,8)<-pi/2
            jointAngle(iter,8)=-pi/2;
        end


        Y(iter)=-sin(jointAngle(iter,8))*alpha+cos(jointAngle(iter,8))*gamma;
        if Y(iter) == 0
            Y(iter)=0.00001;
        end
        if Y(iter)*Y(iter)+beta*beta-b*b<0
            jointAngle(iter,7)=atan2(0,b)-atan2(Y(iter),beta);
        else
            jointAngle(iter,7)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
        end

        if jointAngle(iter,7)>pi/2
            jointAngle(iter,7)=pi/2;
        elseif jointAngle(iter,7)<-pi/2
            jointAngle(iter,7)=-pi/2;
        end

        jointAngle(iter,8)=jointAngle(iter,8)+pi/4;
        
        %% middle finger
         % proximal 
         mag=sqrt(magnetic_data(iter,M1*3+1)^2+magnetic_data(iter,M1*3+2)^2+magnetic_data(iter,M1*3+3)^2);
        a=magnetic_data(iter,M1*3+1)/mag;
        b=magnetic_data(iter,M1*3+2)/mag;

        X=atan2(gamma,alpha);
        if alpha*alpha+gamma*gamma-a*a>0
            jointAngle(iter,9)=atan2(sqrt(alpha*alpha+gamma*gamma-a*a),a)-X;
        else
            jointAngle(iter,9)=atan2(0,a)-X;
        end

        if jointAngle(iter,9)>pi/2
            jointAngle(iter,9)=pi/2;
        elseif jointAngle(iter,9)<-pi/2
            jointAngle(iter,9)=-pi/2;
        end

        Y(iter)=sin(jointAngle(iter,9))*alpha+cos(jointAngle(iter,9))*gamma;
        if Y(iter)*Y(iter)+beta*beta-b*b<0
            jointAngle(iter,10)=atan2(b,0)-atan2(beta,Y(iter));
        else
            jointAngle(iter,10)=atan2(b,sqrt(Y(iter)*Y(iter)+beta*beta-b*b))-atan2(beta,Y(iter));
        end

        if jointAngle(iter,10)>pi/2
            jointAngle(iter,10)=pi/2;
        elseif jointAngle(iter,10)<-pi/2
            jointAngle(iter,10)=-pi/2;
        end

        % distal
        mag=sqrt(magnetic_data(iter,M2*3+1)^2+magnetic_data(iter,M2*3+2)^2+magnetic_data(iter,M2*3+3)^2);
        a=magnetic_data(iter,M2*3+1)/mag;
        b=magnetic_data(iter,M2*3+2)/mag;

        X=atan2(alpha,gamma);
        if alpha*alpha+gamma*gamma-a*a>0
            jointAngle(iter,12)=atan2(a,sqrt(alpha*alpha+gamma*gamma-a*a))-X;
        else
            jointAngle(iter,12)=atan2(a,0)-X;
        end

        if jointAngle(iter,12)>pi/2
            jointAngle(iter,12)=pi/2;
        elseif jointAngle(iter,12)<-pi/2
            jointAngle(iter,12)=-pi/2;
        end


        Y(iter)=-sin(jointAngle(iter,12))*alpha+cos(jointAngle(iter,12))*gamma;
        if Y(iter) == 0
            Y(iter)=0.00001;
        end
        if Y(iter)*Y(iter)+beta*beta-b*b<0
            jointAngle(iter,11)=atan2(0,b)-atan2(Y(iter),beta);
        else
            jointAngle(iter,11)=atan2(sqrt(Y(iter)*Y(iter)+beta*beta-b*b),b)-atan2(Y(iter),beta);
        end

        if jointAngle(iter,11)>pi/2
            jointAngle(iter,11)=pi/2;
        elseif jointAngle(iter,11)<-pi/2
            jointAngle(iter,11)=-pi/2;
        end

        jointAngle(iter,12)=jointAngle(iter,12)+pi/4;
        
    end


end

