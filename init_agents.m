function Anew=init_agents(agentID,A)

    % DESCRIPTION:
    % This is a function which initializes the Agentsmatrix. The agentmatrix
    % holds all required agent information. The structure of the matrix is as
    % follows:
    %                   | Agent 1  | Agent 2 | Agent 3
    %-----------------------------------------------
    % 1 position x      |
    % 2 position y      |
    % 3 speed    x      |
    % 4 speed    y      |
    % 5 desired speed v0|
    % 6 type            |
    % 7 last counter    |
    % 9 red-carpet-time | (indicates the frame when the agent actually
    %                      left the red area; thus "entered" the mensa)
    %
    % PARAMETERS:
    % A                 = agent Matrix
    % agent_number      = global constant, total # of agents at any time
    % map               = matrix containing zeros/ones legal/nonlegal positions
    % legal_pos         = all legal positions ordered
    % shuffled_legal_pos= all legal positions shuffled

    
    parameters; % load global parameters

    global agent_number v0_mean sqrt_theta map_init n_goals;
    
    % check if agentID is set, if so reinitialize only this agent and leave
    % the rest of the A matrix alone
    
    a_num=agent_number;
    if(nargin~=0) % if inputargument given, only one agent
        a_num=1;
        if(A(6,agentID)~=1)
            A(6,agentID)=1;
            Anew = A;
            return
        end
    end
    
    map = map_init';
    %map(140:175,100:300)=1;
    
    
    %map = ones(300,300);
    % find legal x and y positions on map
    %[row,col,v] = find(X, ...) returns a column or row vector v of the nonzero 
    %entries in X

    [row, col, ~]=find(map);


    % all legal positions ordered
    legal_pos=[row col]; 

    % random order positions
    rand_index=randperm(size(legal_pos,1));
    shuffled_legal_pos=legal_pos(rand_index,:);
    

    Anew=shuffled_legal_pos(1:a_num,:)';

    % generate gaussian distributed v0, the desired speed and initial speed of
    % an agent

    v0=normrnd(v0_mean,sqrt_theta,1,a_num); 

    %random unit direction
    
    agent_directions=[sin(rand(1,a_num)*2*pi);cos(rand(1,a_num)*2*pi)];

    % adding speeds to A

    agent_speeds = agent_directions.*(ones(2,1)*v0);

    % add v0 and agent speeds to A
    

    Anew(3:4,:)=agent_speeds;
    Anew(5,:)=v0;
    % Random Goal from 2 until n_goals, the first goal is the cash point
    %Anew(6,:)=randi(n_goals-3,1,a_num)+randi(2,1,a_num)+1;
    %1=Bio
    %2=Menu1
    %3=Spezial
    %4=Salat
    %5=Vegi
    Menus = [ 1 2 2 2 2 3 3 4 5 5 ]; 
    Anew(7,:) = 0;
    for i = 1:a_num
        bla = randi(size(Menus,2))
        Anew(6,i)= Menus(bla)+1;
    end
    Anew(9,:) = -1;
    
    if(nargin~=0) 
        A(:,agentID)=Anew;
        Anew=A;
    end

end







