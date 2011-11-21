function load_map()

% Generates a potential field, which represents the 
% boundary and goal forces.
% Each goal gets its own layer.
%
% Furthermore, a valid-start-positions layer will be created.
%
%
% fields_x, fields_y:   m*n*number_of_goals, contains the force-fields
% maps:                 m*n*number_of_goals, potential-fields
% map_init:             m*n, boolean map with valid start positions
%

% The Force field depends on the following globals:

global hue_goal hue_init map_file R v0_mean tau_alpha U_alphaB_0;


% New globals are created:

global fields_x fields_y maps map_init;

%% Read image

X = imread(['maps/' map_file ]);

m = size(X, 1);
n = size(X, 2);


%% Create layers

% Color transformations
X_hsv = rgb2hsv(X);
X_gs = sum(X, 3)/size(X,3); % Greyscale

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


%% Calculate filters and convolutions

% Fourier transformation
F_walls = fftshift(fft2(X_walls));

% Filter for walls
[l,k] = meshgrid(1:m,1:n);
l_0 = m/2;
k_0 = n/2;

g_walls = U_alphaB_0 * exp( -sqrt( (k-k_0).^2+(l-l_0).^2 )/R );

% Filter for goal attraction
r = ceil( sqrt(m^2 + n^2) ); % Calculate minimal filter radius

[l,k] = meshgrid(1:(2*r),1:(2*r));

g_goal = sqrt( (k-r).^2+(l-r).^2 ); % create cone
g_goal = g_goal(r, 1) - g_goal; % shift cone
g_goal(g_goal<0) = 0; % saturate negative values

% Convolution
X_walls_conv = real(ifft2(ifftshift(F_walls .* g_walls))); % cyclic conv.

for i = 1:CC.NumObjects % do this for every target
    px_count = size(CC.PixelIdxList{i},1); % target size for normalization
    f = v0_mean / tau_alpha; % see formula (2) in paper
    
    X_goals_conv(:,:,i) = f * 1/px_count * ... 
        conv2(double(X_goals(:,:,i)), g_goal, 'same'); % zero-padded conv.
end


%% Arrange output 

for i = 1:CC.NumObjects
    maps(:,:,i) = X_goals_conv(:,:,i) + X_walls_conv(:,:,1);
    [fields_x(:,:,i), fields_y(:,:,i)] = gradient( maps(:,:,i) );
end

map_init = X_init;

end
