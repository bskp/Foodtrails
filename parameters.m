% Parameters
global meter hue_goal map_file R;


% Map
meter = 40; % * pixel, according to:
map_file = 'testmap.png';

% Map colors
hue_goal = [0.3 0.1]; % Value / Tolerance


% Boundary potential
R = 0.2 * meter; % according to paper
