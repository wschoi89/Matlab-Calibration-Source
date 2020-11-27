function plotThreeFingers(Origin_in,pos_frame_in)
    % plot three fingers
    num_fingers = 3;
    num_joints = 7;
    for finger=1:num_fingers
        % plot links for forward kinematics
        color = ["black.-","black.-","black.-"];
        plot3([Origin_in(1,4,finger) pos_frame_in{1,1,finger}(1)],[Origin_in(2,4,finger) pos_frame_in{1,1,finger}(2)],[Origin_in(3,4,finger) pos_frame_in{1,1,finger}(3)],color(finger), 'LineWidth', 2);
        hold on
        % plot point at each finger's origin
        plot3(Origin_in(1, 4, finger),Origin_in(2, 4, finger),Origin_in(3, 4, finger), '-o','MarkerSize',8,'MarkerFaceColor', [0 1 0], 'MarkerEdgeColor', [0 1 0])
        hold on
        
        for joint=1:num_joints-1
            % plot links for forward kinematics
            plot3([pos_frame_in{1,joint,finger}(1) pos_frame_in{1,joint+1,finger}(1)],[pos_frame_in{1,joint,finger}(2) pos_frame_in{1,joint+1,finger}(2)],[pos_frame_in{1,joint,finger}(3) pos_frame_in{1,joint+1,finger}(3)],color(finger), 'LineWidth', 2);
            hold on
            
            % plot points at joint positions
            plot3(pos_frame_in{1,joint+1,finger}(1),pos_frame_in{1,joint+1,finger}(2),pos_frame_in{1,joint+1,finger}(3),'-o','MarkerSize',8,'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [0 0 0])
            hold on
            
       end
    end
end

