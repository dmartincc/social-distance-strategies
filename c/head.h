#include <stdio.h>
#include <stdlib.h>
#include "WELL1024a.h"
#include <math.h>
#include <time.h>
#include <string.h>

typedef struct Node {
  int k;
  int t;
  int *v;
  double *w;
  int state;
} Node;

#define S 0
#define I 1
#define R 2

Node *node;
int *list_inf, *new_list_inf;
int N, n_runs, n_inf, new_inf, t, n_san;
double rho, gammita;
FILE *fsim, *fsim_sir;

void initialize();
void initRandom(int);
void seedInfection();
void init();
void spread(int);
void readNetwork();
void freeMemory();
