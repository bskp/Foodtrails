function [ fx, fy ] = potential_force( x, y, goal_layer )
% This function might not really be necessary, but serves as an example how
% to use the results of load_map.m

    global fields_x fields_y;

    fx = fields_x(x,y,goal_layer);
    fy = fields_y(x,y,goal_layer);

end

