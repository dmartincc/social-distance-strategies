#include <stdio.h>
#include <stdlib.h>
#include "WELL1024a.h"
#include <math.h>
#include <time.h>
#include <string.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

typedef struct Node{
  int k;
  int tE;
  int tI;
  int tR;
  int R0;
  int *l;
  int *v;
  double *w;
  double *w_cont;
  int state;
} Node;

#define S 0
#define E 1
#define I 2
#define R 3
#define SCHOOLS 2

const gsl_rng_type * T;
gsl_rng *random_gsl;

Node *node;
int *list_inf, *list_latent, *new_list_latent, count_layer[3];
int N, n_runs, n_inf, new_latent, n_latent, t, n_san, index_node, survive;
int threshold, inf_cum;
double beta, pw[3], inf_layer[3], n_inf_tot, R0_index;
double meanlog, sdlog, p_ItoR, Tg;
FILE *fsim, *fsim_sir;
char file_sim[100], file_sim_sir[100];

void initialize();
void initRandom(int);
void seedInfection();
void init();
void spread(int);
void readNetwork();
void freeMemory();
void openFiles();
void closeFiles();
