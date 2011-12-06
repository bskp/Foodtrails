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
    % e_alpha               = 2 by 1 vector, desired direction of the agent
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

    
    global dt v0_alphabeta sigma tau_alpha maps X_goals fields_x fields_y; % global constants defined in parameters.m
    global A1 A2 B1 B2;
    agent_number=size(A,2);
    
    % seperate agent alpha from other agents
    agent_others=[A(:,1:alpha-1) A(:,alpha+1:end)];
    agent_alpha=A(:,alpha);
    
    e_alpha = [fields_x(round(agent_alpha(2)),round(agent_alpha(1)),agent_alpha(6))
        fields_y(round(agent_alpha(2)),round(agent_alpha(1)),agent_alpha(6))];
    e_alpha = e_alpha/norm(e_alpha,2);
    % calculate all r_alphabeta vectors and store in matrix
    % Doesn't alphabeta mean: beta-alpha? 
    r_alphabeta_matrix=(agent_alpha(1:2,:)*ones(1,agent_number-1)-agent_others(1:2,:));
    
    % In case two agents are on top of each other
    % Find the entries where x and y are zero
    null_entries = find(r_alphabeta_matrix(1,:)==0 & r_alphabeta_matrix(1,:)==0);
    % Replace the entries by random numbers
    r_alphabeta_matrix(:,null_entries)=rand(2,size(null_entries,2));
    
    % Nur Agents in einem Radius von radius=15 beachten
    rausschmeissen = sqrt(sum(r_alphabeta_matrix.^2))>15;
    agent_others(:,rausschmeissen) = [];
    r_alphabeta_matrix(:,rausschmeissen) = [];
    agent_number=size(agent_others,2)+1;
    % get all v_betas
    v_beta_matrix=agent_others(3:4,:);
    
    % calculate Force Unit vector
    % Somethings' odd: The unity vectors are not so much unity
    % Solved: sqrt was missing...
    e_beta_matrix=r_alphabeta_matrix./(ones(2,1)*sqrt(sum(r_alphabeta_matrix.^2)));
    
     
    % calculate smaller semi axis of ellipse 
%     b=(1/2)*sqrt(...  
%         (...
%         sqrt(sum(r_alphabeta_matrix.^2))+...
%         sqrt(sum((r_alphabeta_matrix-v_beta_matrix*deltat).^2))...
%         ).^2-...
%         (sqrt(sum(v_beta_matrix.^2))*deltat).^2);
%     
    %b=sqrt(sum(r_alphabeta_matrix.^2)); %circular potential..
    % absolute value of forces
    
    
    
    %F_abs=v0_alphabeta*(-1/sigma).*exp(-b/sigma);
    
%     F_abs=v0_alphabeta*...
%     [ (((x.^2 + y.^2).^(1/2) + ((r - y).^2 + (s - x).^2).^(1/2))*((2*s - 2*x)/(2*((r - y).^2 + (s - x).^2).^(1/2)) - x/(x.^2 + y.^2).^(1/2)))/(sigma*exp((((x.^2 + y.^2).^(1/2) + ((r - y).^2 + (s - x).^2).^(1/2)).^2 - s.^2 - r.^2).^(1/2)/sigma)*(((x.^2 + y.^2).^(1/2) + ((r - y).^2 + (s - x).^2).^(1/2)).^2 - s.^2 - r.^2).^(1/2))
%     (((x.^2 + y.^2).^(1/2) + ((r - y).^2 + (s - x).^2).^(1/2))*((2*r - 2*y)/(2*((r - y).^2 + (s - x).^2).^(1/2)) - y/(x.^2 + y.^2).^(1/2)))/(sigma*exp((((x.^2 + y.^2).^(1/2) + ((r - y).^2 + (s - x).^2).^(1/2)).^2 - s.^2 - r.^2).^(1/2)/sigma)*(((x.^2 + y.^2).^(1/2) + ((r - y).^2 + (s - x).^2).^(1/2)).^2 - s.^2 - r.^2)^(1/2))]
    
    F_tot = 1/tau_alpha*(-agent_alpha(3:4));
%     for i=1:agent_number-1
%         s = v_beta_matrix(1,i)*3; r = v_beta_matrix(2,i)*3;
%         x = r_alphabeta_matrix(1,i); y = r_alphabeta_matrix(2,i);
%         F_tot= F_tot...
%             -[ (((x^2 + y^2)^(1/2) + ((r - y)^2 + (s - x)^2)^(1/2))*((2*s - 2*x)/(2*((r - y)^2 + (s - x)^2)^(1/2)) - x/(x^2 + y^2)^(1/2)))/(sigma*exp((((x^2 + y^2)^(1/2) + ((r - y)^2 + (s - x)^2)^(1/2))^2 - s^2 - r^2)^(1/2)/sigma)*(((x^2 + y^2)^(1/2) + ((r - y)^2 + (s - x)^2)^(1/2))^2 - s^2 - r^2)^(1/2));...
%             (((x^2 + y^2)^(1/2) + ((r - y)^2 + (s - x)^2)^(1/2))*((2*r - 2*y)/(2*((r - y)^2 + (s - x)^2)^(1/2)) - y/(x^2 + y^2)^(1/2)))/(sigma*exp((((x^2 + y^2)^(1/2) + ((r - y)^2 + (s - x)^2)^(1/2))^2 - s^2 - r^2)^(1/2)/sigma)*(((x^2 + y^2)^(1/2) + ((r - y)^2 + (s - x)^2)^(1/2))^2 - s^2 - r^2)^(1/2))]...
%             *v0_alphabeta;
%     end
%         
    F_tot = F_tot ...
        + A2*sum(ones(2,1)*exp(2*sigma*ones(1,agent_number-1)-sum(r_alphabeta_matrix.^2)/B2)...
        .*e_beta_matrix,2);
    % vector value of forces
    %F=e_beta_matrix.*(ones(2,1)*F_abs);
    
    % sum / superposition over all forces -> one vector force
    %F_tot=sum(F,2);
    %F_tot = [ F_tot(2); F_tot(1) ]; %transponieren
    
end
