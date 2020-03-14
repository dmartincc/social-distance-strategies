modifyNetwork = function(name,threshold){
	
  print("Reading file...")
  a = read.csv(name,stringsAsFactors=F)
  print("File read")
  
  # print(nrow(a))
  # a = a[a$layer!="School",]
  
  print(nrow(a))
	a = a[a$w_ij>=threshold,]
  
  print(nrow(a))
	
  a = a[a$source_user!=a$target_user,]
  print(nrow(a))

	id = unique(c(a$source_user,a$target_user))
	ids = data.frame(old=id, new=c(1:length(id))-1)
  
  write.table(ids,"data/nodes_ids_conversion.txt",row.names=F,col.names=T)

	a$source_user = ids$new[match(a$source_user,ids$old)]
	a$target_user = ids$new[match(a$target_user,ids$old)]

  print("Writing formatted network...")
	write.table(a[,c(2,3,5)],"data/network.txt",row.names=F,col.names=F)

	return(nrow(ids))
}

n_simus = 10000
N = modifyNetwork("data/contacts_network_layers_0.05.csv", 0.05)

cmd = sprintf("./sir %d", n_simus)
system(cmd)
