#include "head.h"

void init() {
  for(int i=0;i<N;i++)
    node[i].state = S;

  t = 0;
  seedInfection();
}

void seedInfection() {
  int seed;

  n_inf = 0;
  for(int i=0;i<20;i++) {
    seed = (int)floor(N*WELLRNG1024a());

    node[seed].state = I;
    node[seed].t = t;
    
    list_inf[n_inf] = seed;
    n_inf++;
  }
  n_san = N-n_inf;
}

void spread(int run) {
  int s, ta;
  int days;
  int cases[3];
  
  for(int i=0;i<3;i++)
    cases[i] = 0;
  
  t++;

  new_inf = 0;
  for(int i=0;i<n_inf;i++) {
    s = list_inf[i];
    days = t - node[s].t;
    for(int j=0;j<node[s].k;j++) {
      ta = node[s].v[j];
      if(node[ta].state==S && WELLRNG1024a()<(node[s].w[j]*rho/days)) {
        new_list_inf[new_inf] = ta;
        new_inf++;
        node[ta].state = I;
        node[ta].t = t;
        cases[node[s].layer[j]]++;
        fprintf(fsim,"%d %d %d %d %d\n",run,ta,s,t,node[s].t);
      }
    }
    if(WELLRNG1024a()<gammita) {
      node[s].state = R;
      list_inf[i] = list_inf[n_inf-1];
      n_inf--;
      i--;
    } 
  }

  for(int i=0;i<new_inf;i++) {
    list_inf[n_inf] = new_list_inf[i];
    n_inf++;
    n_san--;
  }  
 
  fprintf(fsim_sir, "%d %d %d %d %d\n", run, t, n_san, n_inf, N-n_san-n_inf);
  // No sé exactamente como hacer lo que comentas de normalizarlo
  fprintf(fsim_sir_layers, "%d %d %d\n", cases[0], cases[1], cases[2]);
}
