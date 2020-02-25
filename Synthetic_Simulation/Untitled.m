pos_wrist_wrt_global = [13.186 3.110 1.550];
% rot_wrist = [-49.599 -85.389 56.769];
rot_wrist = [0 0 0];

transform_wrist = eye(4)*transl(pos_wrist_wrt_global(1), pos_wrist_wrt_global(2), pos_wrist_wrt_global(3)) ...
    * trotz(rot_wrist(3)*pi/180)*troty(rot_wrist(2)*pi/180)*trotx(rot_wrist(1)*pi/180);

pos_thumb_wrt_wrist = [2.737 2.016 2.738];
% rot_thumb_wrt_wrist = [-111.854 -51.613 43.295];
rot_thumb_wrt_wrist = [0 0 0];

pos_index_wrt_wrist = [8.114 0.099 2.900];
% rot_index_wrt_wrist = [-9.209 -9.737 1.013];
rot_index_wrt_wrist = [0 0 0];

transform_thumb_wrt_wrist = eye(4)*transl(pos_thumb_wrt_wrist(1), pos_thumb_wrt_wrist(2), pos_thumb_wrt_wrist(3)) ...
    * trotz(rot_thumb_wrt_wrist(3)*pi/180)*troty(rot_thumb_wrt_wrist(2)*pi/180)*trotx(rot_thumb_wrt_wrist(1)*pi/180);

transform_index_wrt_wrist = eye(4)*transl(pos_index_wrt_wrist(1), pos_index_wrt_wrist(2), pos_index_wrt_wrist(3)) ...
    * trotz(rot_index_wrt_wrist(3)*pi/180)*troty(rot_index_wrt_wrist(2)*pi/180)*trotx(rot_index_wrt_wrist(1)*pi/180);


inv(transform_index_wrt_wrist)*transform_thumb_wrt_wrist
inv(transform_thumb_wrt_wrist)*transform_index_wrt_wrist
transform_thumb_wrt_wrist*inv(transform_index_wrt_wrist)
transform_index_wrt_wrist*inv(transform_thumb_wrt_wrist)