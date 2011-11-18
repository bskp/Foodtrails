function [ map map_init ] = load_map( )

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

% Init positions
X_init  = X_hsv(:,:,2) > 0.9 ... % sat
        & X_hsv(:,:,1) < hue_init(1)+hue_init(2) ... % hue max
        & X_hsv(:,:,1) > hue_init(1)-hue_init(2); % hue min
    
if ( max(max( X_init )) == 0) % if there are no spots
    X_init = X_hsv(:,:,3) < 1; % use free space as x_init
end


%% Calculate filter and convolution

% Fourier transformation
F = fftshift(fft2(X_gs));

% Filter
[l,k] = meshgrid(1:m,1:n);
l_0 = m/2;
k_0 = n/2;

g_walls = exp( -sqrt( (k-k_0).^2+(l-l_0).^2 )/R );

% Convolution
X_walls = real(ifft2(ifftshift(F .* g_walls)));


%% Arrange output 

map = [ X_init X_walls ];

end
