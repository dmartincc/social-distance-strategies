# 🧑‍🤝‍🧑 Social Distance Strategies #

This folder contains scripts for running discrete simulations over a contact network with the current structure:

"user_id","target_user_id","w_ij"

"1,1,0.247279943674103

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

Build

```
./sir numOfSimulations
```

# Output:

Two different of files for each simulation:

1) Discrete results of the epidemic at each step.

simulations,t,S,I,R

2) Aggregated results of the epidemic at each step.

simulations,node_infected,infected_by,t_node_infected,t_infected_by