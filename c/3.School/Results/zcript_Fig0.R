library(ggplot2)
library(data.table)
source("theme.R")
options(scipen=999)
library(cowplot)

transformData = function(threshold)
{
	a = read.table(paste0("simulation_sir_th",threshold,".txt"))
	colnames(a) = c("t","S","I","R","run")

	data = data.table(a)
	data = data[,list(maxI=max(I)),by='run']
	run = data$run[data$maxI>1000]

	a = a[a$run %in% run,]
	data = data.table(a)
	data = data[,list(I50=which.min(abs((I+R)-50))),by='run']

	a$index = data$I50[match(a$run,data$run)]
	a$t = a$t - a$index

	a = data.table(a)
	a = a[,list(I=mean(I),IR=mean(I+R)),by='t']

	return(data.frame(t=a$t,I=a$I,IR=a$IR,type=threshold))

}

data = transformData(0)
data = rbind(data,transformData(50))
data = rbind(data,transformData(100))
data = rbind(data,transformData(500))
data = rbind(data,transformData(1000))
data = rbind(data,transformData(100000))
data$type[data$type==100000] = "baseline"

p2 = ggplot() +
		theme_thesis() +
		geom_line(data = data, aes(x = t, y = IR, color = as.factor(type), group = as.factor(type)), size = 2) +
		theme(legend.position=c(0.9,0.5),
			legend.title = element_blank(),
			legend.direction = "vertical",
			legend.key.width = unit(3, "line")#,
			#legend.text = element_text(size = 24),
		#	axis.text.x = element_text(angle=45,hjust=1)
			) +
		#scale_x_continuous(expand = c(0,0), limits = c(-50,70)) +
		#scale_y_continuous(expand = c(0,0), limits = c(0,2500)) +
		xlab("t") +
		ylab("C(t)")

p1 = ggplot() +
		theme_thesis() +
		geom_line(data = data, aes(x = t, y = I, color = as.factor(type), group = as.factor(type)), size = 2) +
		theme(legend.position=c(0.9,0.5),
			legend.title = element_blank(),
			legend.direction = "vertical",
			legend.key.width = unit(3, "line")#,
			#legend.text = element_text(size = 24),
		#	axis.text.x = element_text(angle=45,hjust=1)
			) +
		#scale_x_continuous(expand = c(0,0), limits = c(-50,70)) +
		#scale_y_continuous(expand = c(0,0), limits = c(0,2500)) +
		xlab("t") +
		ylab("I(t)")


pdf("Fig0.pdf",width=20,height=8)
print(plot_grid(p1,p2,nrow=1))
dev.off()
