%% Primitive Zeichenfunktion

figure(my_figure);
clf()

global map_pretty;
% 
% 
% 
    imagesc( map_pretty );        %Hintergrundbild laden
    colormap('bone');
    
    hold on;
    
    % draw vector field
    draw_field = 2;
    quiver(1:10:300, 1:10:300, fields_x(1:10:300,1:10:300,draw_field), ...
                               fields_y(1:10:300,1:10:300,draw_field));
    
    quiver(A(1,:),A(2,:),A(3,:),A(4,:));    %Pfeile zeichnen
    
    plot(A(1,:),A(2,:),'o','MarkerSize',10); %Punkte zeichnen
    
   
