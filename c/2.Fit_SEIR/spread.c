#include "head.h"

void init()
{
  for(int i=0;i<N;i++)
    {
      node[i].state = S;
      node[i].R0 = 0;
    }
      
  for(int i=0;i<3;i++)
    count_layer[i] = 0;

  t = 0;
  seedInfection();
}

void seedInfection()
{
  int seed;

  n_latent = n_inf = 0;
  for(int i=0;i<1;i++)
    {
      seed = (int)floor(N*WELLRNG1024a());

      node[seed].state = I;
      node[seed].tE = node[seed].tI = 0;

      list_inf[n_inf] = seed;
      n_inf++;

      index_node = seed;
    }
  n_san = N-n_inf;
}

void spread(int run)
{
  int s, ta, Te;
  
  t++;

  fprintf(fsim,"%d %d %d %d %d\n",n_san,n_latent,n_inf,N-n_san-n_latent-n_inf,run);
  //From S to E
  new_latent = 0;
  for(int i=0;i<n_inf;i++)
    {
      s = list_inf[i];
      for(int j=0;j<node[s].k;j++)
	{
	  ta = node[s].v[j];
	  if(node[ta].state==S && WELLRNG1024a()<(beta*node[s].w[j]*pw[node[s].l[j]]))
	    {
	      //Add R0 and infections per layer
	      //if(s==index_node)
	      //R0_index++;
	      count_layer[node[s].l[j]]++;
	      node[s].R0++;

	      //Update state of target
	      new_list_latent[new_latent] = ta;
	      new_latent++;
	      
	      node[ta].state = E;
	      node[ta].tE = t;
	      Te = round(gsl_ran_lognormal(random_gsl,meanlog,sdlog));
	      if(Te<1)
		Te = 1;
	      node[ta].tI = t + Te;
	    }
	}

      //From I to R
      if(WELLRNG1024a()<p_ItoR)
	{
	  node[s].state = R;
	  node[s].tR = t;
	  list_inf[i] = list_inf[n_inf-1];
	  n_inf--;
	  i--;
	}      
    }

  //From E to I
  for(int i=0;i<n_latent;i++)
    {
      s = list_latent[i];
      if(t>=node[s].tI)
	{
	  list_inf[n_inf] = s;
	  n_inf++;
	  
	  node[s].state = I;
	  list_latent[i] = list_latent[n_latent-1];
	  n_latent--;
	  i--;
	}
    }

  //Adding the new E
  for(int i=0;i<new_latent;i++)
    {
      list_latent[n_latent] = new_list_latent[i];
      n_latent++;
      n_san--;
    }
}

void results()
{
  if((N-n_san)>1000)
    {
      survive++;

      inf_layer[0] += count_layer[0]/((double)N-n_san);
      inf_layer[1] += count_layer[1]/((double)N-n_san);
      inf_layer[2] += count_layer[2]/((double)N-n_san);

      n_inf_tot += (N-n_san);

      R0_index += node[index_node].R0;
    }
}
