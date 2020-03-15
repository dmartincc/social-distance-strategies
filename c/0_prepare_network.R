modifyNetwork = function(name,threshold){
	
  print("Reading file...")
  a = read.csv(name,stringsAsFactors=F)
  print("File read")

  id = unique(c(a$user_id,a$target_user_id))
	ids = data.frame(old=id, new=c(1:length(id))-1)
  write.table(ids, "data/nodes_ids_conversion.txt", row.names=F, col.names=T)
  print("Number of nodes:")
  print(length(id))

  layer = unique(c(a$layer))
  layers = data.frame(old=layer, new=c(1:length(layer))-1)
  write.table(layers, "data/layers_ids_conversion.txt", row.names=F, col.names=T)
  print("Number of layers:")
  print(length(layer))
  
  print("Number of edges:")
  print(nrow(a))
  a = a[a$layer!="SCHOOL",]
  
  print("Number of edges:")
  print(nrow(a))
	a = a[a$w_ij>=threshold,]
  
  print("Number of edges:")
  print(nrow(a))
  a = a[a$user_id!=a$target_user_id,]
  
	a$user_id = ids$new[match(a$user_id,ids$old)]
	a$target_user_id = ids$new[match(a$target_user_id,ids$old)]
  a$layer = layers$new[match(a$layer,layers$old)]

  print(head(a))

  print("Writing formatted network...")
	write.table(a[,c(1,2,3,4)], "data/network.txt", row.names=F, col.names=F)

	return(nrow(ids))
}

n_simus = 10000
N = modifyNetwork("data/community_households_schools_layers.csv", 0.02)

cmd = sprintf("./sir %d", n_simus)
system(cmd)
