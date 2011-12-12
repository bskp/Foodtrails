% Which maps shall be drawn?

%draw_these = 1:n_goals; 
draw_these = [3 4];


parameters; 
load_map;

global fields_x fields_y n_goals map_pretty map_x map_y;

n_plots = size(draw_these,2);

space_x = floor(linspace(1,map_x, 100));
space_y = floor(linspace(1,map_y, 100));

for i = draw_these;
    
    field_x = fields_x(:,:,i);
    field_y = fields_y(:,:,i);
    
    subplot(1,n_plots,find(draw_these == i));
    hold on;
    
    image(map_pretty);
    quiver(space_y, space_x, ...
           e_alpha_x(space_x, space_y), e_alpha_y(space_x, space_y));
           field_x(space_x, space_y), field_y(space_x, space_y));
    
end