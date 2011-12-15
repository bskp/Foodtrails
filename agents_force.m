function [F_tot, agent_number_back] = agents_force(A,alpha)
    % DISCRIPTION:
    % This function calculates the force caused on the agent in coloumn alpha
    % of matrix A. 
    % 
    % DETAILED DESCRIPTION:
    % The calculation is based on the social force model. The
    % potential function used was V_alphabeta=v0_alphabeta*exp(-b/sigma).
    % The parameter b calculates the smaller semi axis of the ellipse which
    % is centered on other agents (beta agents). The longer axis of this ellipse
    % is parallel with the directio vector of other agents. This means that 
    % the exerted force from other agents depends which direction they are
    % facing. For more information see "Social forces model for pedestrian
    % dynamics"  III. FORMULATION OF SOCIAL FORCE MODEL  Dirk Helbing et
    % al
    % 
    %
    % PARAMETERS:
    % A                     = 2 by agent_number matrix, Agentmatrix
    % alpha                 = Agent ID for which Force is to be calculated
    % b                     = smaller semi axis of ellipse
    % F                     = 2 by 1 vector, force caused by other Agents
    % agent_others          = 2 by agent_number-1 matrix containing other agent information
    % agent_alpha           = 2 by 1 vector containing agent alpha information
    % r_alphabeta_matrix    = 2 by agent_number-1 matrix with all distances between alpha/others
    % v_beta_matrix         = 2 by agent_number-1 matrix  all velocities of other agents
    % e_beta_matrix         = 2 by agent_number-1 matrix, direction vector
    % F_abs                 = 1 by agent_number-1 vector, absolute Force
    % e_alpha               = 2 by 1 vector, desired direction of the agent
    % Structure of Matrix A:
    %
    %                 | Agent 1  | Agent 2 | Agent 3
    %-----------------------------------------------
    % 1 position x      |
    % 2 position y      |
    % 3 speed    x      |
    % 4 speed    y      |
    % 5 desired speed v0|
    % 6 goal            |
    % 7 last counter
    % 8 ETR from FM
    % 9 Red Carpet...
    %
    %
    % ==Some hints to understand the calculations below:==
    %
    % if A=[a b c; d e f] sum(A) or sum(A,1) creates the matrix [a+d,b+e,c+f]
    % and sum(A,2) creates the matrix [a+b+c;d+e+f]
    %
    % if B=[3 4 2 5 1], then (B>2) creates the matrix
    % [1 1 0 1 0] which one can use select partial matrices
    % for example B([1 1 0 1 0]) results in [3 4 5] 
    %
    
    
    
    global sigma tau_alpha agent_number; % global constants defined in parameters.m
    global A1 A2 B1 B2 e_alpha_x e_alpha_y v0_mean sight;
    agent_alpha=A(:,alpha);
    
    % calculate all r_alphabeta vectors (distance between) and store in matrix
    r_alphabeta_matrix=(agent_alpha(1:2,:)*ones(1,agent_number)-A(1:2,:));
    
    
    % Select only Agents inside the radius "sight"
    close_agents = sqrt(sum(r_alphabeta_matrix.^2))<sight;
    
    % Exclude agent_alpha from the selection
    close_agents(alpha) = 0; 
    
    agent_others = A(:,close_agents);
    agent_number_back = size(agent_others,2)+1;
    
    % Remove unnecessary distances
    r_alphabeta_matrix(:,~close_agents) = [];
    
    
    
    % In case two agents are on top of each other
    % Find the entries where x and y are zero
    % Totally unlikely, but it would cause a division by zero 
    null_entries = find(r_alphabeta_matrix(1,:)==0 & r_alphabeta_matrix(1,:)==0);
    % Replace the entries by random numbers
    r_alphabeta_matrix(:,null_entries)=rand(2,size(null_entries,2));
    
    % Calculating the normal vectors (aka the directions) towards the other agents  
    e_beta_matrix=r_alphabeta_matrix./(ones(2,1)*sqrt(sum(r_alphabeta_matrix.^2)));
    
     
    % d_direction: Desired Direction
    % Read the desired direction from the Fast March Gradient
    d_direction = [e_alpha_x(round(agent_alpha(2)),round(agent_alpha(1)),agent_alpha(6));...
        e_alpha_y(round(agent_alpha(2)),round(agent_alpha(1)),agent_alpha(6))];
    
    % Queueing
    % Select all agents around alpha that have smaller time till reaching the goal.
    closer_agents = agent_others([1 2 8],((agent_others(8,:)<agent_alpha(8))&(agent_others(6,:)==agent_alpha(6))));
    
    % Exclude the agents towards the first goal (aka cash point)
    % They should not queue as the cassa is not designed like it
    if(size(closer_agents,2)>0&&agent_alpha(6)~=1) 
        % Of these take the one that has the longest 
        % expected time as the new desired direction.
        [~,I] = max (closer_agents(3,:));
        closest_agent = closer_agents(1:2,I);
        % Mix the desired direction with the queueing direction
        d_direction = d_direction*.2+0.8*(closest_agent-agent_alpha(1:2))/norm(closest_agent-agent_alpha(1:2),2);
    end
   
    % Relaxion term
    % If the agent already has its desired speed
    % and direction, no force comes from this term
    F_tot = 1/tau_alpha*(...
        v0_mean*d_direction/norm(d_direction,2)...
        -agent_alpha(3:4)...
        );

    F_tot = F_tot ...
                + A2*sum(...
                (ones(2,1)...
                *((3*(agent_others(6,:)==1)+1)...The agents towards the cashpoint have more power
                .*exp((2+2*(agent_alpha(6)==1))...and because of the tray the have a double radius
                *sigma*ones(1,agent_number_back-1)-sum(r_alphabeta_matrix.^2)/B2))...
                ).*e_beta_matrix,2);
    
end
