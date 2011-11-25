%% Primitive Zeichenfunktion

figure(my_figure);
clf()

global karte;
% 
% 
% 
    imagesc(karte);        %Hintergrundbild laden
% 
    hold on;  
    
    quiver(A(1,:),A(2,:),A(3,:),A(4,:));    %Pfeile zeichnen
    
    plot(A(1,:),A(2,:),'o','MarkerSize',10); %Punkte zeichnen
    
   
