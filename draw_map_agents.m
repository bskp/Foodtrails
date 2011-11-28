%% Primitive Zeichenfunktion
function draw_map_agents(my_figure,A,zkarte,zpfeile,zpunkte,psize)

figure(my_figure);
clf()

global karte;



    hold on;
    if zkarte
    imagesc(karte);        %Hintergrundbild laden
    end
      
    if zpfeile
    quiver(A(1,:),A(2,:),A(3,:),A(4,:));    %Pfeile zeichnen
    end
    if zpunkte
    plot(A(1,:),A(2,:),'o','MarkerSize',psize); %Punkte zeichnen
    end
=======
>>>>>>> 195ce9a5f66fed45331d93f690ee7a7e03887080
   
