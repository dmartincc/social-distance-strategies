modifyNetwork = function(name,threshold){
	
  print("Reading file...")
  a = read.csv(name,stringsAsFactors=F)
  print("File read")

	a = a[a$w_ij>=threshold,]
	a = a[a$source_user!=a$target_user,]

	id = unique(c(a$source_user,a$target_user))
	ids = data.frame(old=id, new=c(1:length(id))-1)
  write.table(id,"data/nodes_ids_conversion.txt",row.names=F,col.names=T)

	a$source_user = ids$new[match(a$source_user,ids$old)]
	a$target_user = ids$new[match(a$target_user,ids$old)]

  print("Writing formatted network...")
	write.table(a[,c(2,3,5)],"data/network.txt",row.names=F,col.names=F)

	return(nrow(ids))
}

n_simus = 10000
N = modifyNetwork("data/contacts_network_layers_0.05.csv", 0.08)

cmd = sprintf("./sir %d", n_simus)
system(cmd)
