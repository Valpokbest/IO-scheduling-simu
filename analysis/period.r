library(reshape2)
library(data.table)
library(ggplot2)
library(scales) 
library(grid)


#########################
## Plotting impact of period (one set for paper)
#########################

set=8
x <- paste("study_kp/simu_all_set",set,sep = "")
dat = read.table(x, header = TRUE)

pSysEff = ggplot(dat, aes(x = Period, y = SysEff)) + 
	xlab("")+scale_x_continuous(label=comma)+
#	xlab("Period")+ scale_x_continuous(label=comma)+
	ylab("SysEff")+
	geom_line(size=1, colour="#000099")+ geom_point(colour="#000099")+ 
	theme(axis.text=element_text(size=12),
	axis.title.x = element_text(size=14, face="bold"),
	axis.title.y = element_text(size=14, face="bold")
	)
#ggsave("../fig/evol_period_syseff.pdf", width=6, height=3,device=cairo_pdf)

pDil = ggplot(dat, aes(x = Period, y = Dilation)) + 
	xlab("Period")+ scale_x_continuous(label=comma)+
	ylab("Dilation")+
	geom_line(size=1, colour="#FF9999")+ geom_point(colour="#FF9999")+ 
	theme(axis.text=element_text(size=12),
	axis.title.x = element_text(size=14, face="bold"),
	axis.title.y = element_text(size=14, face="bold")
	)
#ggsave("../fig/evol_period_dil.pdf", width=6, height=3,device=cairo_pdf)

#This is to print both figures as one, sharing xlab. 
#To print individually, remove all commented text above.
cairo_pdf(file ="evol_period.pdf", width=6, height=7)
pushViewport(viewport(layout = grid.layout(2, 1)))
print(pSysEff, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(pDil, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
dev.off()



#########################
## Plotting impact of period (all sets for verif)
#########################

n_expes = 10 #number of expes


cairo_pdf(file ="evol_period_allsets.pdf", width=30, height=7*n_expes %/% 5)
pushViewport(viewport(layout = grid.layout(2 *n_expes %/% 5, 5)))

for (j in 1:n_expes) {
	x <- paste("results_kp_10/simu_all_set",j,sep = "")
	dat = read.table(x, header = TRUE)

	myTitle <- paste("Set",j,sep = " ")
	pSysEff = ggplot(dat, aes(x = Period, y = SysEff)) + 
		labs(title = myTitle) +
		xlab("")+scale_x_continuous()+
		ylab(if ( (j%%5) == 1 ){"SysEff"} else {""})+
		geom_line(size=1, colour="#000099")+ geom_point(colour="#000099")+ 
	theme(axis.text=element_text(size=18),
	axis.title.x = element_text(size=30),
	axis.title.y = element_text(size=30)
	)

	pDil = ggplot(dat, aes(x = Period, y = Dilation)) + 
		xlab(if ( ((j-1) %/%5) == 1 ){"Period"} else {""})+ scale_x_continuous()+
		ylab(if ( (j%%5) == 1 ){"Dilation"} else {""})+
		geom_line(size=1, colour="#FF9999")+ geom_point(colour="#FF9999")+ 
	theme(axis.text=element_text(size=16),
	axis.title.x = element_text(size=30),
	axis.title.y = element_text(size=30)
	)
print(pSysEff, vp = viewport(layout.pos.row = 1 + 2*(j-1) %/% 5, layout.pos.col = 1+ (j-1)%%5))
print(pDil, vp = viewport(layout.pos.row = (2+ 2*(j-1) %/% 5), layout.pos.col = 1+ (j-1)%%5))
}
dev.off()

