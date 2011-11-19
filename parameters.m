%%%%%%%%%%%%%%%%%%%%
% GLOBAL PARAMETERS
%%%%%%%%%%%%%%%%%%%%

global ...
    dt ... 
    meter...
    hue_goal ...
    hue_init ...
    map_file ...
    R ... 
    v0_alphabeta ...
    sigma ...
    agent_number...
    v0_mean...
    sqrt_theta;

% General
dt=1;
agent_number=100;

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
v0_mean=1.34; % this is the mean of the desired speed of an agent
sqrt_theta=0.26; % standard deviation of gaussian distributed v0_mean

