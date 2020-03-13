#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import division

import argparse
import random
import structlog
import time
from datetime import datetime

import pandas as pd
import numpy as np

from sets import Set

logger = structlog.getLogger(__name__)

def simulations(nodes, W, simulations, tf):

  now = datetime.now()
  date_time = now.strftime("%m-%d-%Y_%H:%M:%S")

  rho = 0.25 
  n = 1

  for sim in range(1, simulations + 1):
    start_time = time.time()

    ts = []
    sir = []
    
    nodes_sample = W.groupby(['user_id']).size().reset_index(name='count').sort_values('count')
    nodes_sample = nodes_sample.loc[(nodes_sample['count'] > 80)]

    zero_patient = nodes_sample.sample(n=n)

    # SIR sets
    S = set([ node for node in nodes ])
    I = { node: 0 for node in zero_patient.user_id}
    R = set([])

    logger.info("# Sim ({}) has started with {} nodes, {} edges and {} zero patient with {} encounters".format(sim, len(nodes), len(W), n, zero_patient['count'].iloc[0]))

    # epidemic days
    for t in range(1, tf + 1):

      # iterate over infectious individuals
      for i in I.keys():
        
        days = t - I[i]
        
        N = W.loc[(W['user_id'] == i) & (W['target_user_id'] != i) & (W['target_user_id'].isin(S))]
        N = N.copy()
        N['beta'] = N['w_ij'] * rho * 1/days
        N['r'] = np.random.rand(len(N))
        N['infected'] = np.where(N['r'] <= N['beta'] , 1, 0)
        
        # iterate over i neighbours
        for j in N.loc[N['infected'] == 1].target_user_id:
          S.remove(j)
          I[j] = t
          ts.append([sim, j, i, t, I[i]])

          # logger.info("# Node {} infected by {} at epidemic day {} and infection day {}".format(j, i, t, days))

        # Probability of i of gettings recovered
        r = random.random()
        gamma = 1/3

        if r <= gamma:
          del I[i]
          R.add(i)
      
      sir.append([sim, t, len(S), len(I), len(R)])
      
      # logger.info("# Sim ({}) - day {} finished - S({}), I({}), R({})".format(sim, t, len(S), len(I), len(R)))
    
    logger.info("# Sim ({}) has finished (Elapsed time {})".format(sim, (time.time() - start_time)//60))

    if len(ts) > 0:
    
      df = pd.DataFrame(np.vstack(ts))
      df.columns = ['simulations','node_infected','infected_by','t_node_infected', 't_infected_by']
      
      df.to_csv('simulations/simulations_' + str(sim) + '_' + date_time + '.csv', index=False)

      df = pd.DataFrame(np.vstack(sir))
      df.columns = ['simulations','t','S','I','R']
      
      df.to_csv('simulations/simulations_sir_' + str(sim) + '_' + date_time + '.csv', index=False)

def main(n=50):
  
  n_simulations = n
  tf = 100
  W = pd.read_csv('contacts_network_0.01.csv')
  W = W[W['w_ij'] >= 0.08]
  nodes = W.user_id.append(W.target_user_id).unique()

  start_time = time.time()

  simulations(nodes, W, n_simulations, tf)

  logger.info("# Total time elapsed - {}".format((time.time() - start_time)//60))


class QueryAction(argparse.Action):

    def __call__(self, parser, namespace, values, option_string=None):
        # TODO: Merge parameters into a list when the key is already present
        # (instead of overriding as happens ATM)
        key, value = values.split('=', 1)
        getattr(namespace, self.dest)[key] = value


if __name__ == '__main__':
    
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("simulations", 
      help="Add number of simulations",
      type=int)
    
    args = parser.parse_args()

    logger.info("Number of simulations to run {}".format(args.simulations))

    main(args.simulations)

