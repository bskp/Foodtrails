% remote worker

sim_id = ['test' datestr(now)];

reset_sim;
simulate;

save('sim_id');