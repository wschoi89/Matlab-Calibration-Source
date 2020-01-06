function linkLength = loadLinkLength()
%load CAD link length data for 3 digits
%thumb은 OneFingerLinkLength.pptx 에 있는 자료 값

    linkLength = zeros(8, 3);
    thumb = 1;
    index = 2;
    middle = 3;
    %thumb links(8 links for end-effector position)
    linkLength(1, thumb) = 24.21;
    linkLength(2, thumb) = 56.03;
    linkLength(3, thumb) = 12.94;
    linkLength(4, thumb) = 57.5;
    linkLength(5, thumb) = 17.25;
    linkLength(6, thumb) = 37;
%     linkLength(7, thumb) = 37;
%     linkLength(8, thumb) = 16.61;
%     
%     %index links
%     linkLength(1, index) = 24.2;
%     linkLength(2, index) = 56.03;
%     linkLength(3, index) = 12.94;
%     linkLength(4, index) = 47.5;
%     linkLength(5, index) = 19.5;
%     linkLength(6, index) = 24.90;
%     linkLength(7, index) = -10.42;
%     linkLength(8, index) = 16.61;
%     
%     %middle links which is same with index link lengths
%     linkLength(1, middle) = linkLength(1, index);
%     linkLength(2, middle) = linkLength(2, index);
%     linkLength(3, middle) = linkLength(3, index);
%     linkLength(4, middle) = linkLength(4, index);
%     linkLength(5, middle) = linkLength(5, index);
%     linkLength(6, middle) = linkLength(6, index);
%     linkLength(7, middle) = linkLength(7, index);
%     linkLength(8, middle) = linkLength(8, index);
        
end



