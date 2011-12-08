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
% ddirect_x, ddirect_y  m*n*n_goals, the desired directions

% The Force field depends on the following globals:

global hue_goal hue_init map_file R v0_mean tau_alpha U_alphaB_0;


% New globals are created:

global fields_x fields_y ddirect_x ddirect_y n_goals map_init map_pretty X_goals map_x map_y;

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
        & X_hsv(:,:,1) > hue_goal(1)-hue_goal(2); % hue min

CC = bwconncomp( X_goal );
clear X_goals;
for i = 1:CC.NumObjects % for every found component in the goal-layer
    layer = X_goal*0;
    layer(CC.PixelIdxList{i}) = 1;
    X_goals(:,:,i) = layer; % add a layer with it to X_goals
end
    
% Init areas
X_init  = X_hsv(:,:,2) > 0.9 ... % sat
        & X_hsv(:,:,1) < hue_init(1)+hue_init(2) ... % hue max
        & X_hsv(:,:,1) > hue_init(1)-hue_init(2); % hue min
    

% Wall potential: treat init- and goal-areas as free space
X_walls = X_gs/255;
X_walls(X_init | X_goal ) = 1 ; 

if ( max(max( X_init )) == 0) % if there are no init spots
    X_init = X_hsv(:,:,3) < 1; % use free space as x_init
end


%% Calculate filter and convolution

% Fourier transformation
F_walls = fftshift(fft2(X_walls));

% Filter for walls
[l,k] = meshgrid(1:map_x,1:map_y);
l_0 = map_x/2;
k_0 = map_y/2;

g_walls = U_alphaB_0 * exp( -sqrt( (k-k_0).^2+(l-l_0).^2 )/R );

% Convolution
X_walls_conv = real(ifft2(ifftshift(F_walls .* g_walls'))); % cyclic conv.

%% Create force fields

[field_walls_x field_walls_y] = gradient(X_walls_conv);

% Fast marching algorithm
X_mf = 0.001 + X_walls*0.5;
addpath fm/;
f = v0_mean / tau_alpha; % see formula (2) in paper

for i = 1:CC.NumObjects
    [t_x, t_y] = find(X_goals(:,:,i) == 1); % Create list of target-pxs
    [T, Y] = msfm(X_mf, [t_x t_y]'); % Do the fast marching thing
    [ddirect_x(:,:,i), ddirect_y(:,:,i)] = gradient(-T);
    r = sqrt( ddirect_x(:,:,i).^2 + ddirect_y(:,:,i).^2 );
    ddirect_x(:,:,i) = ddirect_x(:,:,i)./r;
    ddirect_y(:,:,i) = ddirect_y(:,:,i)./r;
    % Now we've got the fields for the desired direction, e_alpha.
    
    fields_x(:,:,i) =  field_walls_x;
    fields_y(:,:,i) =  field_walls_y; % Scale & sum fields
end

% Arrange output
map_init = X_init;
n_goals = size(fields_x, 3);
