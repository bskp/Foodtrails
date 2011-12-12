%function load_map()

% Generates a potential field, which represents the 
% boundary and goal forces.
% Each goal gets its own layer.
%
% Furthermore, a valid-start-positions layer will be created.
%
%
% fields_x, fields_y:   m*n*number_of_goals, contains the force-fields
% X_goals:              m*n*number_of_goals, target areas
% n_goals:              1*1, number of goals
% map_x:                1*1, = m
% map_y:                1*1, = n
% map_init:             m*n, boolean map with valid start positions
% e_alpha_x, e_alpha_y  m*n*n_goals, the desired directions

% The Force field depends on the following globals:

global hue_goal hue_init hue_counter wall_th map_file R v0_mean tau_alpha U_alphaB_0;


% New globals are created:

global fields_x fields_y n_goals map_init map_pretty X_goals X_counter n_counters map_x map_y e_alpha_x e_alpha_y T;
%% Read image

X = imread(['maps/' map_file ]);

map_x = size(X, 1);
map_y = size(X, 2);


%% Create layers

% Color transformations
X_hsv = rgb2hsv(X);
X_gs = sum(X, 3)/size(X,3); % Greyscale
map_pretty = X; %X_gs;

% Detect goals
X_goal  = X_hsv(:,:,2) > 0.9 ... % sat
        & X_hsv(:,:,1) < hue_goal(1)+hue_goal(2) ... % hue max
        & X_hsv(:,:,1) > hue_goal(1)-hue_goal(2)... % hue min
        & X_hsv(:,:,3) > 0.5; % brightness min

[X_goals n_goals] = seperateAreas(X_goal);

% Detect goal-boundaries
X_goal_bd  = X_hsv(:,:,2) > 0.9 ... % sat
           & X_hsv(:,:,1) < hue_goal(1)+hue_goal(2) ... % hue max
           & X_hsv(:,:,1) > hue_goal(1)-hue_goal(2); % hue min
       
[X_goals_bd n_goals_bd] = seperateAreas(X_goal_bd); % seperate
X_goals_bd( X_goals == 1 ) = 0; % remove actual goal areas
% why is this done this way? it ensures (hopefully) matching enumeration for
% the goals an their corresponding boundaries.

% Init areas
X_init  = X_hsv(:,:,2) > 0.9 ... % sat
        & X_hsv(:,:,1) < hue_init(1)+hue_init(2) ... % hue max
        & X_hsv(:,:,1) > hue_init(1)-hue_init(2); % hue min
    
% Counter areas
X_counter  = X_hsv(:,:,2) > 0.9 ... % sat
        & X_hsv(:,:,1) < hue_counter(1)+hue_counter(2) ... % hue max
        & X_hsv(:,:,1) > hue_counter(1)-hue_counter(2); % hue min
    
[X_counters, n_counters] = seperateAreas(X_counter);

X_counter = X_counter*0; % compose counter-layers to one map
for i = 1:n_counters
    X_counter = X_counter + X_counters(:,:,i)*i; % number indicates counter
end

passes = zeros(n_counters, 1);

% Wall potential: treat init-, counter- and goal-areas as free space
% and grey drawings too;
% and goal-specific walls too;

X_walls = X_gs/255;
X_walls(X_init | X_goal | X_counter | X_walls > 1-wall_th | X_goal_bd) = 1 ; 

if ( max(max( X_init )) == 0) % if there are no init spots
    X_init = X_hsv(:,:,3) < 1; % use free space as x_init
end

X_walls = repmat(X_walls, [1 1 n_goals]) - X_goals_bd;

%% Calculate filter and convolution

% Fourier transformation
F_walls = fftshift(fft2(X_walls));

% Filter for walls
[l,k] = meshgrid(1:map_x,1:map_y);
l_0 = map_x/2;
k_0 = map_y/2;

g_walls = U_alphaB_0 * exp( -sqrt( (k-k_0).^2+(l-l_0).^2 )/R );

g_walls = repmat(fftshift(fft2(g_walls))', [1 1 n_goals]);

% Convolution
X_walls_conv = fftshift(real(ifft2(ifftshift(F_walls .* g_walls)))); % cyclic conv.

X_walls_conv = ifftshift( X_walls_conv, 3 ); %swap along third dimension, too

% Debugger's little helper:
% image( X_walls_conv(:,:,5) , 'CDataMapping','scaled' ); axis image;

%% Create force fields

[fields_walls_x fields_walls_y] = gradient(X_walls_conv);

% Fast marching algorithm
X_fm = 0.001 + X_walls*0.5;
addpath fm/;
f = v0_mean / tau_alpha; % see formula (2) in paper

for i = 1:n_goals
    [t_x, t_y] = find(X_goals(:,:,i) == 1); % Create list of target-pxs
<<<<<<< HEAD
    [T(:,:,i), Y] = msfm(X_fm(:,:,i), [t_x t_y]'); % Do the fast marching thing
    [e_alpha_x(:,:,i), e_alpha_y(:,:,i)] = gradient(-T(:,:,i));
    
=======
    [T, Y] = msfm(X_fm(:,:,i), [t_x t_y]'); % Do the fast marching thing
    [e_alpha_x(:,:,i), e_alpha_y(:,:,i)] = gradient(-T);
>>>>>>> ad8a5220f587b2d18c370d8aa2348f3123c99e3b
    r = sqrt( e_alpha_x(:,:,i).^2 + e_alpha_y(:,:,i).^2 );
    
    r( r==0) = inf;
    
    e_alpha_x(:,:,i) = e_alpha_x(:,:,i)./r;
    e_alpha_y(:,:,i) = e_alpha_y(:,:,i)./r;
    % Now we've got the fields for the desired direction, e_alpha.
    
<<<<<<< HEAD
    fields_x(:,:,i) =  fields_walls_x(:,:,i);% + f*e_alpha_x(:,:,i);
    fields_y(:,:,i) =  fields_walls_y(:,:,i);% + f*e_alpha_y(:,:,i); % Scale & sum fields
=======
    fields_x(:,:,i) =  fields_walls_x(:,:,i) + f*e_alpha_x(:,:,i);
    fields_y(:,:,i) =  fields_walls_y(:,:,i) + f*e_alpha_y(:,:,i); % Scale & sum fields
>>>>>>> ad8a5220f587b2d18c370d8aa2348f3123c99e3b
end

% Arrange output
map_init = X_init;
