% clear;
% clc
load('mat_files/pos_calibration.mat');

% draw index box


for finger=1:3
    num_pos = size(pos_calibZig{1,finger}, 1);
    for i=1:num_pos
        if finger==2
            color = 'g';
        elseif finger==3
            color = 'b';
        end
        pos_center = pos_calibZig{1,finger}(i,1:3);

        pos_left_down = [pos_center(1)-4, pos_center(2), pos_center(3)-6];
        pos_left_up = [pos_center(1)+4, pos_center(2), pos_center(3)-6];
        pos_right_down = [pos_center(1)-4, pos_center(2), pos_center(3)+6];
        pos_right_up = [pos_center(1)+4, pos_center(2), pos_center(3)+6];

        plot3([pos_left_down(1) pos_left_up(1)], [pos_left_down(2) pos_left_up(2)], [pos_left_down(3) pos_left_up(3)], color);
        hold on
        plot3([pos_left_up(1) pos_right_up(1)], [pos_left_up(2) pos_right_up(2)], [pos_left_up(3) pos_right_up(3)], color);
        hold on
        plot3([pos_right_up(1) pos_right_down(1)], [pos_right_up(2) pos_right_down(2)], [pos_right_up(3) pos_right_down(3)], color);
        hold on
        plot3([pos_right_down(1) pos_left_down(1)], [pos_right_down(2) pos_left_down(2)], [pos_right_down(3) pos_left_down(3)], color);
        hold on

    end
end

