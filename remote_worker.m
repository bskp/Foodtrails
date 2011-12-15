% remote worker

sim_id = ['test' datestr(now)];

reset_sim;
simulate_v1;

save('sim_id');