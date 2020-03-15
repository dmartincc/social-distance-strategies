# 🧑‍🤝‍🧑 Social Distance Strategies #

This folder contains scripts for running discrete simulations over a contact network with the current structure:

"id","source_user","target_user","layer","w_ij"

"1","000277100d5593fec35a151e228f6a485210a3fa87cda78d79c465bbebb6e71e","000277100d5593fec35a151e228f6a485210a3fa87cda78d79c465bbebb6e71e","Community",0.247279943674103

"2","000277100d5593fec35a151e228f6a485210a3fa87cda78d79c465bbebb6e71e","2362ac333f83b3c2c10d78f0082011bf3b08fce5b0d413a04dc07414c58b2b3c","Community",0.0644235188818452

Run the folllowing script

```
Rscript 0_prepare_network.R
````

it will transform the data to the following format and launch 10.000 simulations.

```
user_id target_user_id       w_ij     layer
2        0           5881 0.02069848 COMMUNITY
4        0          10161 0.06442352 COMMUNITY
5        0          11070 0.03677175 COMMUNITY
22       0          37255 0.03940118 COMMUNITY
24       0          39284 0.03230890 COMMUNITY
25       0          42431 0.03466259 COMMUNITY

```

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