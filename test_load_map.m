
parameters; 
load_map;

global ddirect_x ddirect_y fields_x fields_y n_goals map_pretty map_x map_y;

%subplot(1,2,1);
%image(X_gs); axis equal; colormap('bone');

%n_goals = size(maps, 3);

for i = 1:n_goals
    field_x = ddirect_x(:,:,i);
    field_y = ddirect_y(:,:,i);
    
    subplot(1,n_goals,i);
    hold on;
    
    %surf( -maps(:,:,i), r,'LineStyle','none'); colormap('bone');
    image(map_pretty);
    quiver(1:10:300, 1:10:300, field_x(1:10:300,1:10:300), ...
                               field_y(1:10:300,1:10:300));
    
end