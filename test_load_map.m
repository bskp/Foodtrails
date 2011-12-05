
parameters; 
load_map;

global fields_x fields_y n_goals map_pretty;

%subplot(1,2,1);
%image(X_gs); axis equal; colormap('bone');

%n_goals = size(maps, 3);

for i = 1:n_goals
    field_x = fields_x(:,:,i);
    field_y = fields_y(:,:,i);
    
    subplot(1,n_goals,i);
    hold on;
    
    %surf( -maps(:,:,i), r,'LineStyle','none'); colormap('bone');
    image(map_pretty);
    quiver(1:10:300, 1:10:300, field_x(1:10:300,1:10:300), ...
                               field_y(1:10:300,1:10:300));
    
end