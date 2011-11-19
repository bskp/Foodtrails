
parameters; 

[ map, map_init ] = load_map();

%subplot(1,2,1);
%image(X_gs); axis equal; colormap('bone');

mesh( -map ); colormap('bone');

%subplot(1,2,2);

%mesh( X_goal_cconv ); colormap('bone');