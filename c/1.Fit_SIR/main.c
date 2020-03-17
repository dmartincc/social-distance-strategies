#include "head.h"

int main(int argc, char *argv[])
{
  //int t0;
  //t0 = time(NULL);
    
  initialize(argv);

  for(int run=0;run<n_runs;run++)
    {
      init();
      while(n_inf>0)
	spread(run);
      results();
    }
  for(int i=0;i<3;i++)
    inf_layer[i] /= survive;
  printf("%lf %lf %lf %lf %lf %d\n",inf_layer[0],inf_layer[1],inf_layer[2],R0_index/n_runs,n_inf_tot/survive,survive);
  inf_layer[0] -= 0.52; inf_layer[1] -= 0.3; inf_layer[2] -= 0.18; R0_index = (R0_index/n_runs)-1.3;
  printf("Results = %lf\n",inf_layer[0]*inf_layer[0]+inf_layer[1]*inf_layer[1]+inf_layer[2]*inf_layer[2]+R0_index*R0_index);
  //printf("Execution time %d seconds\n",(int)time(NULL)-t0);

  freeMemory();
  
  return 0;
}

void initialize(char *argv[])
{
  int seed;
  
  //rho = 0.25;
  gammita = 1.0/3;
 
  N = 99775;
  pw[0] = atof(argv[1]);
  pw[1] = atof(argv[2]);
  pw[2] = atof(argv[3]);  
  n_runs = atoi(argv[4]);

  list_inf = malloc(N * sizeof *list_inf);
  new_list_inf = malloc(N * sizeof *new_list_inf);
  
  seed = time(NULL);
  initRandom(seed);

  readNetwork();

  for(int i=0;i<3;i++)
    inf_layer[i] = 0;
  survive = 0;
  n_inf_tot = 0;
  R0_index = 0;
}
  

void initRandom(int s)
{
  unsigned long int seed;
  unsigned int *random_ini;
  int size, rank, sizint;

  size = 1;
  rank = 0;
  sizint = 32;

  random_ini = (unsigned int*)calloc(sizint, sizeof(unsigned int));

  seed = (unsigned long int)s;
  srand(seed);
  for(int i=0;i<sizint;i++)
    random_ini[i]=(int)floor((double)(rand()/size)*(rank+1));
  InitWELLRNG1024a(random_ini);

  free(random_ini);
}

void freeMemory()
{
  for(int i=0;i<N;i++)
    {
      free(node[i].v);
      free(node[i].w);
      free(node[i].l);
    }
  free(node);

  free(list_inf);
  free(new_list_inf);
}
