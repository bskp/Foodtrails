% Parameter

meter = 40; % * pixel, according to:
map = 'testmap.png';

R = 0.2 * meter; % 

Hue_goal = [0.3 0.1]; % Value / Tolerance

% Read image
subplot(1,2,1);
X = imread(['maps/' map]);

% Create layers
X_hsv = rgb2hsv(X);
X_gs = sum(X, 3)/size(X,3); % Greyscale

X_goal  = X_hsv(:,:,2) > 0.9 ... % sat
        & X_hsv(:,:,1) < Hue_goal(1)+Hue_goal(2) ... % hue max
        & X_hsv(:,:,1) > Hue_goal(1)-Hue_goal(2); % hue min

imsize = size(X);
image(X_gs); axis equal; colormap('bone');

% Fouriertransformation
F = fftshift(fft2(X_gs));

m = imsize(1);
n = imsize(2);

% Calculate filter and convolution
[l,k] = meshgrid(1:m,1:n);
l_0 = m/2;
k_0 = n/2;

g_walls = exp( -sqrt( (k-k_0).^2+(l-l_0).^2 )/R );

X_walls = real(ifft2(ifftshift(F .* g_walls)));

subplot(1,2,2);
mesh(X_walls); colormap('bone');
