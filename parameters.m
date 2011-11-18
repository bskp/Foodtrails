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


% Map
meter = 40; % * pixel, according to:
map_file = 'testmap.png';

% Map colors
hue_goal = [0.3 0.1]; % Value / Tolerance


% Boundary potential
R = 0.2 * meter; % according to paper

% Agents
v0_alphabeta=2.1;
sigma=0.3;
