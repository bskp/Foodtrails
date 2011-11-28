function F_tot=agents_force(A,alpha)
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
    %
    % Structure of Matrix A:
    %
    %                 | Agent 1  | Agent 2 | Agent 3
    %-----------------------------------------------
    % position x      |
    % position y      |
    % speed    x      |
    % speed    y      |
    % desired speed v0|
    % type            |

    
    global dt v0_alphabeta sigma meter; % global constants defined in parameters.m
        
    agent_number=size(A,2);
    
    % seperate agent alpha from other agents
    agent_others=[A(:,1:alpha-1) A(:,alpha+1:end)];
    agent_alpha=A(:,alpha);
    
    % calculate all r_alphabeta vectors and store in matrix
    r_alphabeta_matrix=(agent_alpha(1:2,:)*ones(1,agent_number-1)-agent_others(1:2,:))*meter;
    
    % get all v_betas
    v_beta_matrix=agent_others(3:4,:);
    
    % calculate Force Unit vector
    e_beta_matrix=r_alphabeta_matrix./(ones(2,1)*sum(r_alphabeta_matrix.^2));    
   
    % calculate smaller semi axis of ellipse 
    b=(1/2)*sqrt(...  
        (...
        sqrt(sum(r_alphabeta_matrix.^2))+...
        sqrt(sum((r_alphabeta_matrix-v_beta_matrix*dt).^2))...
        ).^2-...
        (sqrt(sum(v_beta_matrix.^2))*dt).^2);
    
    %b=sqrt(sum(r_alphabeta_matrix.^2)); circular potential..
    % absolute value of forces
    
    F_abs=v0_alphabeta*(-b/sigma).*exp(-b/sigma);
    
    % vector value of forces
    F=e_beta_matrix.*(ones(2,1)*F_abs);
    
    % sum / superposition over all forces -> one vector force
    F_tot=1000*sum(F,2);
    
end
