function plotThreeFingers(Origin_in,pos_frame_in)
% plot three fingers
num_fingers = 3;
    for finger=1:num_fingers
        color = ["red.-","blue.-","black.-"];
        plot3([Origin_in(1,4,finger) pos_frame_in{1,1,finger}(1)],[Origin_in(2,4,finger) pos_frame_in{1,1,finger}(2)],[Origin_in(3,4,finger) pos_frame_in{1,1,finger}(3)],color(finger), 'LineWidth', 2);
        hold on
        plot3([pos_frame_in{1,1,finger}(1) pos_frame_in{1,2,finger}(1)],[pos_frame_in{1,1,finger}(2) pos_frame_in{1,2,finger}(2)],[pos_frame_in{1,1,finger}(3) pos_frame_in{1,2,finger}(3)],color(finger), 'LineWidth', 2);
        hold on
        plot3([pos_frame_in{1,2,finger}(1) pos_frame_in{1,3,finger}(1)],[pos_frame_in{1,2,finger}(2) pos_frame_in{1,3,finger}(2)],[pos_frame_in{1,2,finger}(3) pos_frame_in{1,3,finger}(3)],color(finger), 'LineWidth', 2);
        hold on
        plot3([pos_frame_in{1,3,finger}(1) pos_frame_in{1,4,finger}(1)],[pos_frame_in{1,3,finger}(2) pos_frame_in{1,4,finger}(2)],[pos_frame_in{1,3,finger}(3) pos_frame_in{1,4,finger}(3)],color(finger), 'LineWidth', 2);
        hold on
        plot3([pos_frame_in{1,4,finger}(1) pos_frame_in{1,5,finger}(1)],[pos_frame_in{1,4,finger}(2) pos_frame_in{1,5,finger}(2)],[pos_frame_in{1,4,finger}(3) pos_frame_in{1,5,finger}(3)],color(finger), 'LineWidth', 2);
        hold on
        plot3([pos_frame_in{1,5,finger}(1) pos_frame_in{1,6,finger}(1)],[pos_frame_in{1,5,finger}(2) pos_frame_in{1,6,finger}(2)],[pos_frame_in{1,5,finger}(3) pos_frame_in{1,6,finger}(3)],color(finger), 'LineWidth', 2);
        hold on
        plot3([pos_frame_in{1,6,finger}(1) pos_frame_in{1,7,finger}(1)],[pos_frame_in{1,6,finger}(2) pos_frame_in{1,7,finger}(2)],[pos_frame_in{1,6,finger}(3) pos_frame_in{1,7,finger}(3)],color(finger), 'LineWidth', 2);
        hold on
    end
end

