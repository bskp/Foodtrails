
%% INIT

%clear all;
clear global;

parameters();
load_map();
global dt agent_number statistic agents_f p_gain fetchtimes; %X_goals;
A=init_agents();

if(video_on)
vidObj= VideoWriter(['videos/foodtrail ' datestr(now) '.avi']);
open(vidObj);
end

%% STATISTICS

n_through = 0;
fetchtimes = [];
cpu_a = 0;
X_traces = X_walls(:,:,1)*0;

if (log_on)
    A_stat = zeros(3, agent_number, duration);
end

%% Simulation Loop
timestep=dt;

%my_figure = figure('Position', [20, 100, 600, 600], 'Name','Simulation Plot Window');

for stepnumber=1:duration
    
%timestep = stepnumber^-.2
% Calculate the Forces
% Calculate the resulting velocities ?
agents_f = zeros(2,agent_number);
agents_p = zeros(2,agent_number);
for agentID = 1:size(A,2)
    A(8,agentID) = T(round(A(2,agentID)),round(A(1,agentID)),A(6,agentID));
    agents_f(:,agentID) = agents_force(A,agentID);
    [agents_f(:,agentID), nb] = agents_force(A,agentID);
    agents_p(:,agentID) = potential_force(round(A(1,agentID)),round(A(2,agentID)),A(6,agentID));
    A(3:4,agentID) = (agents_p(:,agentID)...
        +1*agents_f(:,agentID)...
        +10 *[(rand(1)-.5);(rand(1)-.5)])...
        *timestep;
    if (log_on) % record density around agent
        A_stat(2, agentID, stepnumber) = nb; 
    end
end

% log velocities and goals and walkingtimes
if (log_on)
    A_stat(1, :, stepnumber) = sqrt(A(3,:).^2+A(4,:).^2);
    A_stat(3, :, stepnumber) = A(6,:);
    wtimes = stepnumber - A(9,:);
    wtimes(wtimes == stepnumber+1) = 0; % erase not-yet-started ones
    A_stat(4, :, stepnumber) = wtimes;
    
    % create "tracemap"
    
    
end

%Find Agents that exceed their max velocity
too_fast=find(sqrt(A(3,:).^2+A(4,:).^2)>A(5,:));
nan = (isnan(A(3,:))|isnan(A(4,:)));
A(3,nan) = 0; A(4,nan) = 0;
num_toofast = size(too_fast,2);
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
A(1, A(1,:)>map_y ) = map_y;

A(2, A(2,:)<1 ) = 1;
A(2, A(2,:)>map_x ) = map_x;

% Find Agents on target areas
for agentID = 1:size(A,2)
   X = round(A(2, agentID)); Y= round(A(1,agentID));
   %           (X,             Y,            Target layer);
   % Find Agents on target areas
   if ( X_goals(X,Y, A(6, agentID) ) )
       % agent reached his target
       %A(1, agentID) = randi(300,1,1);
       %A(2, agentID) = randi(300,1,1);
       
       if ( A(6, agentID) == 1) % agent past kassa?
           % pass-specific statistics are done here
           fetchtimes = [fetchtimes [A(9, agentID); stepnumber]];
           n_through = n_through + 1;
           
           A = init_agents(agentID,A); % restart agent
       else
           A(6, agentID) = 1; % shoo him to the kassa!
       end
   end
   
   % Find Agents leaving the red init area
   if ( A(9, agentID) == -1 && X_init(X,Y) == 0)
        A(9, agentID) = stepnumber;
   end
end


% Draw the the agents

% Statistics
count_passes;

fps = 1/(cputime - cpu_a);
cpu_a = cputime;

statistic = {'Durchgaenge:',[passes], '', 'Zu schnell:', num_toofast,...
             'Gefuettert:', n_through, 'fps', fps,...
             'Frame', stepnumber };

% draw

if (noplot)
    [fps stepnumber duration]
else

clf();

if (~video_on)

subplot(1,2,2);
image( X_fm(:,:,1) , 'CDataMapping','scaled' ); axis image;
hold on;

fieldplot = 1; % e_alpha-field to plot next to the simulation
space_x = floor(linspace(1,map_x, 50));
space_y = floor(linspace(1,map_y, 50));
quiver(space_y, space_x, ...
       e_alpha_x(space_x, space_y, fieldplot), ...
       e_alpha_y(space_x, space_y, fieldplot), 0.5);

subplot(1,2,1);
end
imagesc( map_pretty );        %Hintergrundbild laden
colormap('bone');
hold on;
 draw_field = 1;
plot(A(1,A(6,:)==1),A(2,A(6,:)==1),'o','MarkerSize',sigma,'MarkerEdgeColor','r','MarkerFaceColor','r'); %Punkte zeichnen
plot(A(1,A(6,:)~=1),A(2,A(6,:)~=1),'o','MarkerSize',sigma,'MarkerFaceColor','b'); %Punkte zeichnen
axis image;

annotation(figure(1),'textbox',...
    [0 0 0.1 0.5],...
    'String', statistic ,...
    'FitBoxToText','off');

pause(0.01);

if (video_on)
currentFrame=getframe;
writeVideo(vidObj,currentFrame);
end  

end %noplot

if (mod(stepnumber, 20) == 0)
    refresh_fields;
    X_traces = X_traces + X_people_conv;
end

end

if (video_on)
close(vidObj);
end 
