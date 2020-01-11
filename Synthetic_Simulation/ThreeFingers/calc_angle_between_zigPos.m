for i=1:20
    vec_1(i,1:3) = pos_calibZig{1,1}(i,1:3)- [0 -35 0];
    mag_1(i,1) = sqrt(sum(vec_1(i,1:3).^2));
    vec_2(i,1:3) = pos_calibZig{1,1}(i+1,1:3)-[0 -35 0];
    mag_2(i,1) = sqrt(sum(vec_2(i,1:3).^2));
    dot_(i,1) = dot(vec_1(i,1:3), vec_2(i,1:3));
    
    cos_theta(i,1) = dot_(i,1)/(mag_1(i,1)*mag_2(i,1));
    angle_thumb(i,1)=acosd(dot_(i,1)/(mag_1(i,1)*mag_2(i,1)));
end

for i=1:15
    vec_1(i,1:3) = pos_calibZig{1,2}(i,1:3)- [0 -33.996 0];
    mag_1(i,1) = sqrt(sum(vec_1(i,1:3).^2));
    vec_2(i,1:3) = pos_calibZig{1,2}(i+1,1:3)-[0 -33.996 0];
    mag_2(i,1) = sqrt(sum(vec_2(i,1:3).^2));
    dot_(i,1) = dot(vec_1(i,1:3), vec_2(i,1:3));
    
    cos_theta(i,1) = dot_(i,1)/(mag_1(i,1)*mag_2(i,1));
    angle_index(i,1)=acosd(dot_(i,1)/(mag_1(i,1)*mag_2(i,1)));
    
end

for i=1:15
    vec_1(i,1:3) = pos_calibZig{1,3}(i,1:3)- [0 -33.996 19];
    mag_1(i,1) = sqrt(sum(vec_1(i,1:3).^2));
    vec_2(i,1:3) = pos_calibZig{1,3}(i+1,1:3)-[0 -33.996 19];
    mag_2(i,1) = sqrt(sum(vec_2(i,1:3).^2));
    dot_(i,1) = dot(vec_1(i,1:3), vec_2(i,1:3));
    
    cos_theta(i,1) = dot_(i,1)/(mag_1(i,1)*mag_2(i,1));
    angle_middle(i,1)=acosd(dot_(i,1)/(mag_1(i,1)*mag_2(i,1)));
    
end