%% Basic draft of a Simulation

%% INIT
parameters();
load_map();
A=init_agents();
%A = [150 150 30 10 30 1; 150 150 20 20 35 1; 150 150 20 20 40 1]';
    %agent_number = 3;
global dt agent_number agents_f; %X_goals;

%% Simulation Loop
timestep=dt;
my_figure = figure('Position', [20, 100, 1200, 600], 'Name','Simulation Plot Window');

for stepnumber=1:10000
% Calculate the Forces
% Calculate the resulting velocities ?
agents_f = zeros(2,agent_number);
agents_p = zeros(2,agent_number);
for agentID = 1:size(A,2)
    agents_f(:,agentID) = agents_force(A,agentID);
    agents_p(:,agentID) = potential_force(round(A(1,agentID)),round(A(2,agentID)),A(6,agentID));
    A(3:4,agentID) = (5*agents_p(:,agentID)...
        +1*agents_f(:,agentID)...
        +1*[(rand(1)-.5)*1e3;(rand(1)-.5)*1e3])...
        *timestep;

end
%Find Agents that exceed their max velocity
too_fast=find(sqrt(A(3,:).^2+A(4,:).^2)>A(5,:));
nan = (isnan(A(3,:))|isnan(A(4,:)));
A(3,nan) = 0; A(4,nan) = 0;
num_toofast =size(too_fast,2);
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
A(1, A(1,:)<1 ) = 1;
A(1, A(1,:)>300 ) = 300;

A(2, A(2,:)<1 ) = 1;
A(2, A(2,:)>300 ) = 300;
% Find Agents on target areas
for agentID = 1:size(A,2)
   X = round(A(2, agentID)); Y= round(A(1,agentID));
   %           (X,             Y,            Target layer);
   if ( X_goals(X,Y, A(6, agentID) ) )
       % agent reached his target
       %A(1, agentID) = randi(300,1,1);
       %A(2, agentID) = randi(300,1,1);
       A=init_agents(agentID,A);
   end
end

% Draw the the agents
draw_map_agents;


end
