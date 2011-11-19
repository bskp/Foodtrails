function [ map, map_init ] = load_map( )

% Generates a potential field, which represents the 
% boundary and goal forces.
% Each goal gets its own layer.
%
% Furthermore, a valid-start-positions layer will be created.
%

global hue_goal hue_init map_file R;

%% Read image

X = imread(['maps/' map_file ]);

m = size(X, 1);
n = size(X, 2);

%% Create layers

% Color transformations
X_hsv = rgb2hsv(X);
X_gs = sum(X, 3)/size(X,3); % Greyscale

% Goals
X_goal  = X_hsv(:,:,2) > 0.9 ... % sat
        & X_hsv(:,:,1) < hue_goal(1)+hue_goal(2) ... % hue max
        & X_hsv(:,:,1) > hue_goal(1)-hue_goal(2); % hue min

    
    
    
% Init areas
X_init  = X_hsv(:,:,2) > 0.9 ... % sat
        & X_hsv(:,:,1) < hue_init(1)+hue_init(2) ... % hue max
        & X_hsv(:,:,1) > hue_init(1)-hue_init(2); % hue min
    

% Wall potential: treat init- and goal-areas as free space
X_walls = X_gs;
X_walls(X_init | X_goal ) = 255 ; 

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

g_walls = exp( -sqrt( (k-k_0).^2+(l-l_0).^2 )/R );

% Filter for goal attraction
r = ceil( sqrt(m^2 + n^2) ); % Calculate minimal filter radius

[l,k] = meshgrid(1:(2*r),1:(2*r));

m_goal = 1000;
g_goal = 1/m_goal * sqrt( (k-r).^2+(l-r).^2 ); % create cone
g_goal = g_goal(r, 1) - g_goal; % shift cone
g_goal(g_goal<0) = 0; % saturate negative values

% Convolution
X_walls_conv = real(ifft2(ifftshift(F_walls .* g_walls))); % cyclic

X_goal_conv = conv2(double(X_goal), g_goal, 'same'); % zero-padded

%% Arrange output 

map = [ X_goal_conv + X_walls_conv ];
map_init = X_init;

end
