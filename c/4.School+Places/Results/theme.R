require(grid)
require(ggthemes)
require(ggplot2)
library(reshape2)

GlobalFont = "Helvetica"

theme_thesis = function(base_size=30) 
{
      return(theme_foundation(base_size=base_size, base_family=GlobalFont) +
		theme(plot.title = element_text(face = "bold",size = rel(1.2), hjust = 0.5),
			text = element_text(),
			panel.background = element_rect(colour = NA),
			plot.background = element_rect(colour = NA),
			panel.border = element_rect(colour = NA),
			axis.title = element_text(face = "bold",size = rel(1)),
			axis.title.y = element_text(angle=90,vjust =2),
			axis.title.x = element_text(vjust = -0.2),
			axis.text = element_text(), 
			axis.line = element_line(colour="black"),
			axis.ticks = element_line(),
			panel.grid.major = element_blank(),
			panel.grid.minor = element_blank(),
			legend.key = element_rect(colour = NA),
			legend.position = "bottom",
			legend.direction = "horizontal",
			legend.key.size = unit(0.2, "cm"),
			legend.text = element_text(size = 20),
			legend.title = element_text(face="italic"),
			legend.background = element_rect(colour = NA, fill = NA),
			plot.margin=unit(c(5,10,5,10),"mm"),
			strip.background=element_rect(colour="#f0f0f0",fill="#f0f0f0"),
			strip.text = element_text(face="bold")
		)
	)
      
}
