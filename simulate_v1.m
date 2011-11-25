%% Basic draft of a Simulation

%% INIT
parameters();
load_map();
A=init_agents();
global dt;
%% Simulation Loop
timestep=dt;
my_figure = figure('Position', [20, 100, 1200, 600], 'Name','Simulation Plot Window');

for stepnumber=1:10000
% Calculate the Forces
% Calculate the resulting velocities ?
for agentID = 1:size(A,2)
    A(3:4,agentID) = ( potential_force(round(A(1,agentID)),round(A(2,agentID)),A(6,agentID))...
        )*timestep;
end

%Find Agents that exceed their max velocity
too_fast=find(sqrt(A(3,:).^2+A(4,:).^2)>A(5,:));
%too_fast_x=find(abs(A(3,:))>A(5,:));
%too_fast_y=find(abs(A(4,:))>A(5,:));

% Throttle them to their desired velocity
A(3:4,too_fast)= A(3:4,too_fast)./([1 1]'*sqrt(A(3,too_fast).^2+A(4,too_fast).^2))...
    .*[A(5,too_fast); A(5,too_fast)];

%A(3,too_fast_x) = A(5,too_fast_x).*sign(A(3,too_fast_x));
%A(4,too_fast_y) = A(5,too_fast_y).*sign(A(4,too_fast_y));

% Calculate the new positions (X+V*t)
deltaPos=A(3:4,:)*timestep;
A(1:2,:)=A(1:2,:)+deltaPos;

% Find Agents that exceed the boundries
outside_x=find(A(1,:)>=300 | A(1,:)<=1);
A(:,outside_x) = [];
outside_y=find(A(2,:)>=300 | A(2,:)<=1);
A(:,outside_y) = [];

% Draw the the agents
draw_map_agents();
pause(0.01);

end