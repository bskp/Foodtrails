
n_agents = 100;

'potential forces: '
tic;
for i=1:n_agents
    [a,b] = potential_force(round(i/4+1), round(300-i/4),1); % 4 ms
end;
toc;

'plotting: '
tic;
plot(A(1,:), A(2,:)); % 4 ms
toc;

'agent forces'
tic;
for i=1:n_agents
    %test_agents_force;
end;
toc;
%%
'matrix operations'
tic;
for i=1:n_agents
    
    distx = ones(n_agents,1)*A(1,:) - A(1,1:n_agents)'*ones(1,n_agents);
    disty = ones(n_agents,1)*A(2,:) - A(2,1:n_agents)'*ones(1,n_agents);
    
    dist = sqrt( distx.^2 + disty.^2);
    
    dv = A(5,:) - sqrt( A(3,:).^2 + A(4,:).^2 );

    
end;
toc;
