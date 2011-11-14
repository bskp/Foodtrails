% Bild Einlesen
subplot(1,2,1);
X = imread('maps/testmap.png');
X = sum(X, 3)/size(X,3); %Grauskala
imsize = size(X);

image(X); axis equal; colormap('bone');

% Fouriertransformation
F = fftshift(fft2(X));
%subplot(1,2,2);
%image(log(abs(F))); colormap('bone');

m = imsize(1);
n = imsize(2);

% Filter berechnen
[l,k] = meshgrid(1:m,1:n);
l_0 = m/2;
k_0 = n/2;
sigma = 5;
g_e = exp(-(((k-k_0).^2+(l-l_0).^2)/(2*sigma^2)));
g_kegel = sqrt( (m/2).^2 + (n/2).^2 ) - sqrt( (l - m/2).^2 + (k - n/2).^2 );
F = F .* g_e;

X = real(ifft2(ifftshift(F)));

subplot(1,2,2);
mesh(X); colormap('bone');
