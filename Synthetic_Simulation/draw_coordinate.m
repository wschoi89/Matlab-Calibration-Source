function [] = draw_coordinate(input)

    hold on
    % in case of transformation matrix
    if size(input) == [4, 4]
        newrot1=input*transl(1, 0, 0);
         newrot2=input*transl(0, 1, 0);
         newrot3=input*transl(0, 0 ,1);

        plot3([input(1,4) newrot1(1,4)],[input(2,4) newrot1(2,4)],[input(3,4) newrot1(3,4)],'r.-')
        plot3([input(1,4) newrot2(1,4)],[input(2,4) newrot2(2,4)],[input(3,4) newrot2(3,4)],'g.-')
        plot3([input(1,4) newrot3(1,4)],[input(2,4) newrot3(2,4)],[input(3,4) newrot3(3,4)],'b.-')
    end


end

