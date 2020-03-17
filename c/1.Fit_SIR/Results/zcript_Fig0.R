library(ggplot2)

a = read.table("simulations_sir.txt")
colnames(a) = c("id","t","S","I","R")

p = ggplot() +
		geom_line(data = data, aes(x = t, y = I, group = as.factor(id), color = as.factor(id)), size = 2) +
		theme(legend.position="none",
			legend.title = element_blank(),
			legend.direction = "vertical",
			legend.key.width = unit(4, "line"),
			legend.text = element_text(size = 24),
			axis.text.x = element_text(angle=45,hjust=1)
			) #+
		#geom_dl(data=data, aes(x= x, y = y, label = id), method = list(dl.combine("first.qp", "last.qp"), cex = 0.8)) +
		#scale_x_continuous(expand = c(0,4), limits = c(0,35),
		#			breaks=seq(0,35,by=5),labels=c("12-Jan","17-Jan","22-Jan","27-Jan",
		#							"1-Feb","6-Feb","11-Feb","16-Feb")) +
		#scale_y_continuous(labels=function(x) {ifelse(x==0, "0", parse(text=gsub("[+]", "", gsub("e", " %.% 10^", scales::scientific_format()(x)))))} , limits = c(0,120000000), breaks = c(0,3E7,6E7,9E7,12E7), expand=c(0,0)) +
		#xlab("") +
		#ylab("Population")



plot("Fig1.pdf")
plot(p)
dev.off()
