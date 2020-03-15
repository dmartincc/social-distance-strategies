#include "head.h"

int main(int argc, char *argv[]) {
  int t0;

  t0 = time(NULL);
    
  initialize(argv);

  for(int run=0;run<n_runs;run++) {
    init();
    while(n_inf>0)
	  spread(run);	
  }
  fclose(fsim);
  fclose(fsim_sir);
  fclose(fsim_sir_layers);
  printf("Execution time %d seconds\n",(int)time(NULL)-t0);

  freeMemory();
  
  return 0;
}

void initialize(char *argv[]) {
  int seed;
  
  N = 97216;
  rho = 0.25;
  gammita = 1.0/3;
  
  n_runs = atoi(argv[1]);

  list_inf = malloc(N * sizeof *list_inf);
  new_list_inf = malloc(N * sizeof *new_list_inf);
  
  seed = time(NULL);
  initRandom(seed);

  readNetwork();

  fsim = fopen("results/simulations.txt","w");
  fsim_sir = fopen("results/simulations_sir.txt","w");
  fsim_sir_layers = fopen("results/simulations_sir_layers.txt","w");
}
  

void initRandom(int s) {
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

void freeMemory() {
  for(int i=0;i<N;i++) {
    free(node[i].v);
    free(node[i].w);
    free(node[i].layer);
  }
  free(node);
  free(list_inf);
  free(new_list_inf);
}
