function map = load_map( )

% Generates a potential field, which represents the 
% boundary and goal forces.
% Each goal gets its own layer.


global hue_goal map_file R;

% Read image
X = imread(['maps/' map_file ]);

% Create layers
X_hsv = rgb2hsv(X);
X_gs = sum(X, 3)/size(X,3); % Greyscale

X_goal  = X_hsv(:,:,2) > 0.9 ... % sat
        & X_hsv(:,:,1) < hue_goal(1)+hue_goal(2) ... % hue max
        & X_hsv(:,:,1) > hue_goal(1)-hue_goal(2); % hue min

imsize = size(X);

% Fourier transformation
F = fftshift(fft2(X_gs));

m = imsize(1);
n = imsize(2);

% Calculate filter and convolution
[l,k] = meshgrid(1:m,1:n);
l_0 = m/2;
k_0 = n/2;

g_walls = exp( -sqrt( (k-k_0).^2+(l-l_0).^2 )/R );

X_walls = real(ifft2(ifftshift(F .* g_walls)));

map = [ X_walls ];

end
