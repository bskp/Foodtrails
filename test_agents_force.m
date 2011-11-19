%% File to test the agent_force.m

parameters; % load global varibales

A=rand(5,100);

tic
for i=1:size(A,2)
    F_agents=agents_force(A,i);
end
toc
