
parameters;
load_map;

X_mf = 0.001 + X_walls*0.5;

addpath fm/;
[i_x, i_y] = find(X_goals(:,:,2) == 1);

[T, Y] = msfm(X_mf, [i_x i_y]');
[fields_x, fields_y] = gradient(T);
r = sqrt( fields_x.^2 + fields_y.^2 );
    fields_x = fields_x./r;
    fields_y = fields_y./r;

quiver(1:10:300, 1:10:300, -fields_x(1:10:300,1:10:300), ...
                           -fields_y(1:10:300,1:10:300));