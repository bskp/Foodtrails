%% Primitive Zeichenfunktion

clf()
karte = imread('maps/testmap.png');


steptime=0.05;

    imagesc([0 100], [0 100],karte);        %Hintergrundbild laden

      
    
    quiver(A(1,:),A(2,:),A(3,:),A(4,:));    %Pfeile zeichnen
    
    plot(A(1,:),A(2,:),'o','MarkerSize',5); %Punkte zeichnen
    
   
