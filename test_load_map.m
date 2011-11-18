
parameters;

map = load_map();

%subplot(1,2,1);
%image(X_gs); axis equal; colormap('bone');

subplot(1,2,2);
mesh(-map); colormap('bone');