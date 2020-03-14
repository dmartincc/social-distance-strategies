# 🧑‍🤝‍🧑 Social Distance Strategies #

This folder contains scripts for running discrete simulations over a contact network with the current structure:

"id","source_user","target_user","layer","w_ij"

"1","000277100d5593fec35a151e228f6a485210a3fa87cda78d79c465bbebb6e71e","000277100d5593fec35a151e228f6a485210a3fa87cda78d79c465bbebb6e71e","Community",0.247279943674103

"2","000277100d5593fec35a151e228f6a485210a3fa87cda78d79c465bbebb6e71e","2362ac333f83b3c2c10d78f0082011bf3b08fce5b0d413a04dc07414c58b2b3c","Community",0.0644235188818452

# Simulation hyperparameters:

__Probability of getting infected__

rho = 0.25 

days = since infected

Beta = w_ij * rho * 1/days

__Probability of getting recovered__

Gamma = 1/3

# Running python scripts:

Argument n controls the number of simulations to run.

```
 nohup python sir_discrete_simulations_parallel.py n > simulations.out 2> simulations.err &
```

# Running C code:

Compile

```
 make
```

Run

```
./sir numOfSimulations
```

# Output:

Two different of files for each simulation:

1) Discrete results of the epidemic at each step.

simulations,t,S,I,R

2) Aggregated results of the epidemic at each step.

simulations,node_infected,infected_by,t_node_infected,t_infected_by