#include "head.h"

void readNetwork() {
  int s, t, l;
  double w;
  FILE *f;
  char *token;
  char string[500];

  node = malloc(N *sizeof *node);
  for(int i=0; i<N; i++) {
    node[i].k = 0;
    node[i].v = malloc(sizeof *node[i].v);
    node[i].w = malloc(sizeof *node[i].w);
    node[i].layer = malloc(sizeof *node[i].layer);
  }
  
  f = fopen("data/network.txt","r");
  while(fgets(string, 500, f)) {
    token = strtok(string," ");
    s = atoi(token);
    token = strtok(NULL," ");
    t = atoi(token);
    token = strtok(NULL," ");
    w = atof(token);
    token = strtok(NULL,"\n");
    l = atoi(token);

    node[s].k++;
    node[s].v = realloc(node[s].v, node[s].k * sizeof *node[s].v);
    node[s].w = realloc(node[s].w, node[s].k * sizeof *node[s].w);
    node[s].layer = realloc(node[s].layer, node[s].k * sizeof *node[s].layer);
    node[s].v[node[s].k-1] = t;
    node[s].w[node[s].k-1] = w;
    node[s].layer[node[s].k-1] = l;

  }
  fclose(f);
}
