%%%%%%%%%%%%%%%%%%%%
% GLOBAL PARAMETERS
%%%%%%%%%%%%%%%%%%%%

global ...
    dt ... 
    meter...
    hue_goal ...
    map_file ...
    R ... 
    v0_alphabeta ...
    sigma ...
    agent_number;

%General
dt=1;
agent_number=50;

% Parameters
global meter hue_goal hue_init map_file R;


% Map
meter = 40; % * pixels, according to:
map_file = 'testmap.png'; % Bitmap file for goals and walls

% Map colors
hue_goal = [0.3 0.1]; % Value / Tolerance
hue_init = [0.0 0.1]; % Value / Tolerance


% Boundary potential
R = 0.2 * meter; % according to paper

% Agents
v0_alphabeta=2.1;
sigma=0.3;
