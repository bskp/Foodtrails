function A=init_agents()
    % DESCRIPTION:
    % This is a function which initializes the Agentsmatrix. The agentmatrix
    % holds all required agent information. The structure of the matrix is as
    % follows:
    %                 | Agent 1  | Agent 2 | Agent 3
    %-----------------------------------------------
    % position x      |
    % position y      |
    % speed    x      |
    % speed    y      |
    % desired speed v0|
    % type            |
    %
    % PARAMETERS:
    % A                 = agent Matrix
    % agent_number      = global constant, total # of agents at any time
    % map               = matrix containing zeros/ones legal/nonlegal positions
    % legal_pos         = all legal positions ordered
    % shuffled_legal_pos= all legal positions shuffled


    parameters; % load global parameters

    global agent_number v0_mean sqrt_theta;

    map=[ones(100,100) zeros(100,100)]; % NEEDS TO BE REPLACED BY LOADED MAP !


    % find legal x and y positions on map
    %[row,col,v] = find(X, ...) returns a column or row vector v of the nonzero 
    %entries in X

    [row, col, ~]=find(map);


    % all legal positions ordered
    legal_pos=[row col]; 

    % random order positions
    rand_index=randperm(size(legal_pos,1));
    shuffled_legal_pos=legal_pos(rand_index,:);

    A=shuffled_legal_pos(1:agent_number,:)';

    % generate gaussian distributed v0, the desired speed and initial speed of
    % an agent

    v0=normrnd(v0_mean,sqrt_theta,1,agent_number); 

    %random unit direction

    agent_directions=[sin(rand(1,agent_number)*2*pi);cos(rand(1,agent_number)*2*pi)];

    % adding speeds to A

    agent_speeds = agent_directions.*(ones(2,1)*v0);

    % add v0 and agent speeds to A

    A(3:4,:)=agent_speeds;
    A(5,:)=v0;

end







