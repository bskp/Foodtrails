
parameters; 

load_map();

global fields_x fields_y maps;

%subplot(1,2,1);
%image(X_gs); axis equal; colormap('bone');

n_goals = size(maps, 3);

for i = 1:n_goals
    subplot(1,n_goals,i);
    hold on;
    mesh( -maps(:,:,i) ); colormap('bone');
    
    r = sqrt( fields_x.^2 + fields_y.^2 );
    fields_x = fields_x./r;
    fields_y = fields_y./r;
    
    quiver(1:10:300, 1:10:300, fields_x(1:10:300,1:10:300), ...
                               fields_y(1:10:300,1:10:300));
    
    % sqrt( px.^2 + py.^2 ) % to validate inclination != v0_mean/tau_alpha
end