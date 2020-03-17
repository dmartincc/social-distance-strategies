#include <stdio.h>
#include <stdlib.h>
#include "WELL1024a.h"
#include <math.h>
#include <time.h>
#include <string.h>

typedef struct Node{
  int k;
  int t;
  int *l;
  int *v;
  double *w;
  int state;
} Node;

#define S 0
#define I 1
#define R 2

Node *node;
int *list_inf, *new_list_inf, count_layer[3];
int N, n_runs, n_inf, new_inf, t, n_san, index_node, survive;
//double rho;
double gammita, pw[3], inf_layer[3], n_inf_tot, R0_index;
FILE *fsim, *fsim_sir;

void initialize();
void initRandom(int);
void seedInfection();
void init();
void spread(int);
void results();
void readNetwork();
void freeMemory();
