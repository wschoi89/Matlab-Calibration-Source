% model = createpde;
% model_2 = createpde;
% model_3 = createpde;
% model_4 = createpde;
% model_5 = createpde;
% importGeometry(model,'HandMocapJig01.stl');
% importGeometry(model_2,'HandMocapJig02.stl');
% importGeometry(model_3,'HandMocapJig03.stl');
% importGeometry(model_4,'HandMocapJig04.stl');
% importGeometry(model_5,'HandMocapJig05.stl');
% pdegplot(model,'FaceLabels','off')
% hold on
% pdegplot(model_2,'FaceLabels','off')
% hold on
% pdegplot(model_3,'FaceLabels','off')
% hold on
% pdegplot(model_4,'FaceLabels','off')
% hold on
% pdegplot(model_5,'FaceLabels','off')

fv = stlread('femur.stl');

fv.vertices(:,1) =  fv.vertices(:,1)+10;
fv.vertices(:,2) =  fv.vertices(:,2)+10;
fv.vertices(:,3) =  fv.vertices(:,3)+10;
patch(fv,'FaceColor',       [0.8 0.8 1.0], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15);


% Add a camera light, and tone down the specular highlighting
camlight('headlight');
material('dull');

% Fix the axes scaling, and set a nice view angle
axis('image');
view([-135 35]);



