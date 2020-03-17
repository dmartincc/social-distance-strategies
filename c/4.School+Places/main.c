#include "head.h"

int main(int argc, char *argv[])
{
  int t0;
  t0 = time(NULL);
    
  initialize(argv);
  openFiles();
  for(int run=0;run<n_runs;run++)
    {
      init();
      while((n_inf+n_latent)>0)
	spread(run);
    }
  closeFiles();
  printf("Execution time %d seconds\n",(int)time(NULL)-t0);
  
  freeMemory();
  
  return 0;
}

void initialize(char *argv[])
{
  int seed;
  
  meanlog = 1.54;
  sdlog = 0.47;
  Tg = 7.5;
  p_ItoR = 1.0/(Tg-5.2);
 
  N = 99775;
  pw[0] = 0.0765;
  pw[1] = 0.77;
  pw[2] = 1.24;
  beta = 3.67;
  n_runs = 1000; 
  threshold = atoi(argv[1]);

  list_inf = malloc(N * sizeof *list_inf);
  list_latent = malloc(N * sizeof *list_latent);
  new_list_latent = malloc(N * sizeof *new_list_latent);
  
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

  gsl_rng_env_setup();
  T = gsl_rng_default;
  random_gsl = gsl_rng_alloc (T);
  //gsl_rng_set(random_gsl,123);
  gsl_rng_set(random_gsl,time(NULL));
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
  free(list_latent);
  free(new_list_latent);

  gsl_rng_free(random_gsl);
}

void openFiles()
{
  sprintf(file_sim,"Results/simulation_th%d.txt",threshold);
  sprintf(file_sim_sir,"Results/simulation_sir_th%d.txt",threshold);
  
  fsim = fopen(file_sim,"w");
  fsim_sir = fopen(file_sim_sir,"w");
}

void closeFiles()
{
  fclose(fsim);
  fclose(fsim_sir);
}
	       
