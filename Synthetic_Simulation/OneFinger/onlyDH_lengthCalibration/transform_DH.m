
function rot_mat = transform_DH(DH_table, frame_to, frame_from)
%return transformation using DH parameters
    rot_mat=zeros(4);
    rot_mat=transl(0,0,DH_table(frame_to,1))*trotz(DH_table(frame_to,2))*transl(DH_table(frame_to,3),0,0)*trotx(DH_table(frame_to,4));
end

