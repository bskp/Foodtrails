function f = potential_force( x, y, goal_layer )
% This function might not really be necessary, but serves as an example how
% to use the results of load_map.m

    global fields_x fields_y;

    f = [fields_x(y,x,goal_layer);
         fields_y(y,x,goal_layer)];

end

