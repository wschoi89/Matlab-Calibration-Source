function linkLength = loadLinkLength()
%load CAD link length data for 3 digits
%thumb은 OneFingerLinkLength.pptx 에 있는 자료 값

    linkLength = zeros(6, 3);
    thumb = 1;
    index = 2;
    middle = 3;
    %thumb links(7 links for end-effector position)
    linkLength(1, thumb) = 24.21;
    linkLength(2, thumb) = 54.80;
    linkLength(3, thumb) = 17.43;
    linkLength(4, thumb) = 57.51;
    linkLength(5, thumb) = 14.07;
    linkLength(6, thumb) = 35.72;
    
     
%     %index links
    linkLength(1, index) = 24.2;
    linkLength(2, index) = 54.80;
    linkLength(3, index) = 17.43;
    linkLength(4, index) = 47.51;
    linkLength(5, index) = 14.07;
    linkLength(6, index) = 35.72;
    

     
%     %middle links which is same with index link lengths
    linkLength(1, middle) = linkLength(1, index);
    linkLength(2, middle) = linkLength(2, index);
    linkLength(3, middle) = linkLength(3, index);
    linkLength(4, middle) = linkLength(4, index);
    linkLength(5, middle) = linkLength(5, index);
    linkLength(6, middle) = linkLength(6, index);
    

        
end



