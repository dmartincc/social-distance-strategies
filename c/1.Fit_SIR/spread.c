#include "head.h"

void init()
{
  for(int i=0;i<N;i++)
    node[i].state = S;

  for(int i=0;i<3;i++)
    count_layer[i] = 0;

  t = 0;
  seedInfection();
}

void seedInfection()
{
  int seed;

  n_inf = 0;
  for(int i=0;i<1;i++)
    {
      seed = (int)floor(N*WELLRNG1024a());

      node[seed].state = I;
      node[seed].t = 0;

      list_inf[n_inf] = seed;
      n_inf++;

      index_node = seed;
    }
  n_san = N-n_inf;
}

void spread(int run)
{
  int s, ta;
  
  t++;

  new_inf = 0;
  for(int i=0;i<n_inf;i++)
    {
      s = list_inf[i];
      for(int j=0;j<node[s].k;j++)
	{
	  ta = node[s].v[j];
	  if(node[ta].state==S && WELLRNG1024a()<(node[s].w[j]*pw[node[s].l[j]]))
	    {
	      if(s==index_node)
		R0_index++;
	      
	      new_list_inf[new_inf] = ta;
	      new_inf++;

	      count_layer[node[s].l[j]]++;
	      
	      node[ta].state = I;
	      node[ta].t = t;
	    }
	}
      if(WELLRNG1024a()<gammita)
	{
	  node[s].state = R;
	  list_inf[i] = list_inf[n_inf-1];
	  n_inf--;
	  i--;
	}      
    }

  for(int i=0;i<new_inf;i++)
    {
      list_inf[n_inf] = new_list_inf[i];
      n_inf++;
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
    }
}
