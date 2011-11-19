
parameters; 

[ map, map_init ] = load_map();

%subplot(1,2,1);
%image(X_gs); axis equal; colormap('bone');

n_goals = size(map, 3);

for i = 1:n_goals
    subplot(1,n_goals,i);
    hold on;
    mesh( -map(:,:,i) ); colormap('bone');
    [px,py] = gradient( -map(:,:,i) );
    quiver(1:10:300, 1:10:300, -px(1:10:300,1:10:300), -py(1:10:300,1:10:300));
    
    % sqrt( px.^2 + py.^2 ) % to validate inclination != v0_mean/tau_alpha
end