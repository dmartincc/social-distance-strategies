library(reshape2)
library(dplyr)
library(data.table)
library(ggplot2)
library(uuid)

# Read households nodes
setwd("~/epidemic_contacts/data/")
hh <- read.csv("nodes_households.csv")
nodes <- fread("nodes_network.csv")

hh <- rename(hh, user_id=id)
hh$user_id <- as.character(hh$user_id)
hh$GEOID <- as.character(hh$GEOID)
hh$tractcode <- as.character(hh$tractcode)
hh <- select(hh, -X)
hh <- inner_join(hh, nodes)

# number of children
hh$num_children <- 0
hh$num_children <- ifelse(hh$hh_kids & hh$hh_size_2 & hh$male_with_children, 1, hh$num_children)
hh$num_children <- ifelse(hh$hh_kids & hh$hh_size_2 & hh$female_with_children, 1, hh$num_children)
hh$num_children <- ifelse(hh$hh_kids & hh$hh_size_3 & hh$male_with_children, 2, hh$num_children)
hh$num_children <- ifelse(hh$hh_kids & hh$hh_size_3 & hh$female_with_children, 2, hh$num_children)

hh$num_children <- ifelse(hh$hh_kids & hh$hh_size_3 & hh$couple_with_children, 1, hh$num_children)
hh$num_children <- ifelse(hh$hh_kids & hh$hh_size_4 & hh$couple_with_children, 2, hh$num_children)
hh$num_children <- ifelse(hh$hh_kids & hh$hh_size_5 & hh$couple_with_children, 3, hh$num_children)
hh$num_children <- ifelse(hh$hh_kids & hh$hh_kids_6 & hh$couple_with_children, 4, hh$num_children)
hh$num_children <- ifelse(hh$hh_kids & hh$hh_size_7 & hh$couple_with_children, 5, hh$num_children)

hh$spouse <- ifelse(hh$couple_with_children | hh$couple_without_children, 1, 0)

# Create new links
new_links <- data.frame(
  user_id=character(),
  target_user_id=character(),
  GEOID=character(),
  tractcode=character(),
  w_ij=numeric(),
  w_ij_confinement=numeric(),
  layer=character()
)

new_links_couples <- data.frame(
  user_id=character(),
  target_user_id=character(),
  GEOID=character(),
  tractcode=character(),
  w_ij=numeric(),
  w_ij_confinement=numeric(),
  layer=character()
)

# Create new nodes
new_nodes_spouses <- data.frame(
  user_id=character(),
  quant=numeric(),
  GEOID=numeric(),
  tractcode=numeric()
)

new_nodes_kids <- data.frame(
  user_id=character(),
  quant=numeric(),
  GEOID=numeric(),
  tractcode=numeric()
)

# Community mixing in Households (Too Slow)
geoids <- unique(hh$GEOID)
parents <- c()
for(id in 1:length(geoids)) {
  pairs <- hh %>% filter(spouse & GEOID == geoids[id])
  print(paste(id, nrow(pairs), sep = " - ", collapse = NULL))
  if(nrow(pairs) > 1) {
    pairs <- split(sample(pairs$user_id),rep(1:(length(pairs$user_id)/2),each=2))
    for(i in 1:length(pairs)) {
      parent <- hh %>% filter(user_id == pairs[i][[1]][1])
      if(parent$hh_kids){
        parents <- c(parents, pairs[i][[1]][1])
      }
      new_links_couples <- rbind(new_links_couples, data.frame(
        user_id=pairs[i][[1]][1],
        target_user_id=pairs[i][[1]][2],
        w_ij=1*0.6,
        w_ij_confinement=1,
        GEOID="",
        tractcode="",
        layer="HOUSEHOLD"
      ))
      new_links_couples <- rbind(new_links_couples, data.frame(
        user_id=pairs[i][[1]][2],
        target_user_id=pairs[i][[1]][1],
        w_ij=1*0.6,
        w_ij_confinement=1,
        GEOID="",
        tractcode="",
        layer="HOUSEHOLD"
      ))
      new_links <- rbind(new_links, new_links_couples)
    }
  }
}

# Create kids
for(i in 1:lenght(parents)) {
  subset <- hh %>% filter(user_id == parents[i])
  new_links_family <- data.frame(
    user_id=character(),
    target_user_id=character(),
    GEOID=character(),
    tractcode=character(),
    w_ij=numeric(),
    w_ij_confinement=numeric(),
    layer=character()
  )
  uid_spouse <- UUIDgenerate(use.time = NA)
  if(subset[i,]$spouse & subset[i,]$hh_kids) {
    new_nodes_spouses <- rbind(new_nodes_spouses, data.frame(
      user_id=uid_spouse,
      quant=subset[i, ]$quant,
      GEOID=subset[i, ]$GEOID,
      tractcode=subset[i, ]$tractcode
    )) 
    new_links_family <- rbind(new_links_family, data.frame(
      user_id=subset[i, ]$user_id,
      target_user_id=uid_spouse,
      w_ij=1/n_nodes*0.6,
      w_ij_confinement=1/n_nodes,
      GEOID=subset[i, ]$GEOID,
      tractcode=subset[i, ]$tractcode,
      layer="HOUSEHOLD"
    ))
    new_links_family <- rbind(new_links_family, data.frame(
      user_id=uid_spouse,
      target_user_id=subset[i, ]$user_id,
      w_ij=1/n_nodes*0.6,
      w_ij_confinement=1/n_nodes,
      GEOID=subset[i, ]$GEOID,
      tractcode=subset[i, ]$tractcode,
      layer="HOUSEHOLD"
    ))
  }
  
  n_nodes <- subset[i,]$num_children
  if(n_nodes > 0){
    print(i)
    for(j in 1:n_nodes){
      uid <- UUIDgenerate(use.time = NA)
      new_nodes_kids <- rbind(new_nodes_kids, data.frame(
        user_id=uid,
        quant=subset[i, ]$quant,
        GEOID=subset[i, ]$GEOID,
        tractcode=subset[i, ]$tractcode
      )) 
      new_links_family <- rbind(new_links_family, data.frame(
        user_id=subset[i, ]$user_id,
        target_user_id=uid,
        w_ij=1/n_nodes*0.6,
        w_ij_confinement=1/n_nodes,
        GEOID=subset[i, ]$GEOID,
        tractcode=subset[i, ]$tractcode,
        layer="HOUSEHOLD"
      ))
      new_links_family <- rbind(new_links_family, data.frame(
        user_id=uid,
        target_user_id=subset[i, ]$user_id,
        w_ij=1/n_nodes*0.6,
        w_ij_confinement=1/n_nodes,
        GEOID=subset[i, ]$GEOID,
        tractcode=subset[i, ]$tractcode,
        layer="HOUSEHOLD"
      ))
      if(subset[i,]$spouse) {
        new_links_family <- rbind(new_links_family, data.frame(
          user_id=uid_spouse,
          target_user_id=uid,
          w_ij=1/n_nodes*0.6,
          w_ij_confinement=1/n_nodes,
          GEOID=subset[i, ]$GEOID,
          tractcode=subset[i, ]$tractcode,
          layer="HOUSEHOLD"
        ))
        new_links_family <- rbind(new_links_family, data.frame(
          user_id=uid,
          target_user_id=uid_spouse,
          w_ij=1/n_nodes*0.6,
          w_ij_confinement=1/n_nodes,
          GEOID=subset[i, ]$GEOID,
          tractcode=subset[i, ]$tractcode,
          layer="HOUSEHOLD"
        ))
      }
    }
    new_links <- rbind(new_links, new_links_family)
    if(n_nodes > 1){
      prob <- 1/(n_nodes-1)
      kids <- t(combn(new_links_family$target_user_id, 2))
      kids <- data.frame(
        user_id = kids[,1],
        target_user_id = kids[,2],
        layer="HOUSEHOLD"
      )
      kids$w_ij <- ifelse(n_nodes > 1, prob*0.6, 1)
      kids$w_ij_confinement <- ifelse(n_nodes > 1, prob, 1)
      kids$GEOID <- subset[i, ]$GEOID
      kids$tractcode <- subset[i, ]$tractcode
      new_links <- rbind(new_links, kids)
    }
  }
}

new_nodes_kids <- distinct(new_nodes_kids)
new_links <- distinct(new_links)

tracts <- unique(new_nodes_kids$tractcode)

# Generate school connections
tau_j <- new_nodes_kids %>%
  group_by(tractcode) %>%
  summarize(
    target_tau_i = n()
  )

for(id in tracts) {
  print(id)
  school_nodes <- filter(new_nodes_kids, tractcode == id)
  print(nrow(school_nodes))
  prob <- 1/(filter(tau_j, tractcode == id)$target_tau_i-1)
  if(nrow(school_nodes) > 1){
    school_nodes <- t(combn(unique(school_nodes$user_id), 2))
    school_nodes <- data.frame(
      user_id = school_nodes[,1],
      target_user_id = school_nodes[,2]
    )
    school_nodes$w_ij <- ifelse(nrow(school_nodes) > 1, prob*0.4, 1)
    school_nodes$w_ij_confinement <- 0
    school_nodes$GEOID <- ""
    school_nodes$tractcode <- id
    school_nodes$layer <- "SCHOOL" 
    school_nodes <- distinct(school_nodes)
    new_links <- rbind(new_links, school_nodes)
  }
}

# Merge all together
nodes <- select(hh, user_id, quant, GEOID, tractcode)
nodes <- rbind(nodes, new_nodes_kids, new_nodes_spouses)
nodes <- unique(nodes)

new_links <- unique(new_links)

setwd("~/epidemic_contacts/data/")
write.csv(nodes, "nodes_all.csv", row.names=FALSE)
write.csv(dplyr::select(new_links, -GEOID, -tractcode), "households_schools_layers.csv", row.names=FALSE)

# Fast rebuild
new_links <- read.csv("households_schools_layers.csv")
new_links$w_ij_restaurants <- 0
new_links <- select(new_links, user_id, target_user_id, w_ij, w_ij_restaurants, w_ij_confinement, layer)

community_links <- read.csv("contacts_network_community_restaurants_restricted_0.01.csv")
community_links$layer <- "COMMUNITY" 

u <- select(hh, user_id)
community_links <- inner_join(community_links, u)
u <- select(hh, target_user_id=user_id)
community_links <- inner_join(community_links, u)

new_links2 <- rbind(community_links, new_links)
new_links2 <- distinct(new_links2)

# Write final
write.csv(new_links2, "community_households_schools_confinement_layers.csv", row.names=FALSE)


