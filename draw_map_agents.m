%% Primitive Zeichenfunktion
%function draw_map_agents(my_figure,A,zkarte,zpfeile,zpunkte,psize)

figure(my_figure);
clf()

global map_pretty fields_x fields_y sigma;
% 
% 
% 
    imagesc( map_pretty );        %Hintergrundbild laden
    colormap('bone');
    
    hold on;
    %axis equal;
    
    % draw vector field
    draw_field = 2;
    %quiver(1:10:300, 1:10:300, fields_x(1:10:300,1:10:300,draw_field), ...
    %                           fields_y(1:10:300,1:10:300,draw_field));
    
    %quiver(A(1,:),A(2,:),A(3,:),A(4,:),0);    %Pfeile zeichnen
    quiver(A(1,:),A(2,:),agents_f(1,:),agents_f(2,:));
    %quiver(A(1,:),A(2,:),agents_p(1,:),agents_p(2,:));
    
    plot(A(1,:),A(2,:),'o','MarkerSize',sigma/4); %Punkte zeichnen
    
   
