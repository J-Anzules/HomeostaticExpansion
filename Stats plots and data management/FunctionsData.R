data_summary = function(data, varname, groupnames){
  require(plyr)
  summary_func = function(x, col){
    c(mean = mean(x[[col]], na.rm = TRUE),
      sd = sd(x[[col]], na.rm = TRUE))
  }
  data_sum = ddply(data, groupnames, .fun=summary_func,
                   varname)
  data_sum = rename(data_sum, c("mean" = varname))
  return(data_sum)
}

# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}




PlotPops = function(popl,ctColumn, ratioColumnm, popnm, fileName, WorkingDirectory){
  ###
  # Makes plots for both Thymus and Spleen. Top row is the Thymus data, bottom row is the Spleen
  # First column is percentages, second row is the total numbers, final is the mean of total
  # numbers and standard error of the mean.
  ###
  
  thym = subset(popl, Organ == "Thymus")
  spln = subset(popl, Organ == 'Spleen')
  ThymSum = data_summary(thym, varname = ctColumn,
                         groupnames = c("Age", "Genotype"))
  SplnSum = data_summary(spln, varname = ctColumn,
                         groupnames = c("Age", "Genotype"))
  
  #####Spleenic Data
  
  p1 = ggplot(spln, aes_string(x = "Age", y = ratioColumnm)) +  
    geom_point(aes(colour = Genotype), size = 4)+
    labs(title = paste0("Spleen: ",popnm, " Frequency"),
         y = paste0(popnm, " Frequency"))+
    theme(plot.title = element_text(size=15))
  
  p3 = ggplot(spln, aes_string(x = "Age", y = ctColumn)) + 
    geom_point(aes(colour = Genotype), size = 4)+
    labs(title = paste0("Spleen: ", popnm," Counts at 10^6"),
         y = paste0(popnm, " Counts at 10^6"))+
    theme(plot.title = element_text(size=15))
  
  p5 = ggplot(SplnSum, aes_string(x="Age", y=ctColumn, group = "Genotype", color="Genotype")) + 
    geom_line() +
    geom_point(size = 6)+
    geom_errorbar(aes_string(ymin=paste(ctColumn,"-sd"), ymax=paste(ctColumn,"+sd")), width=.3,
                  position=position_dodge(0.18), size =1.5 )+
    labs(title=paste0("Spleen: ", popnm, " Count Mean and Error Bars"))+
    theme(plot.title = element_text(size=15))
  
  ###Thymus Data
  
  p2 = ggplot(thym, aes_string(x = "Age", y = ratioColumnm)) +  
    geom_point(aes(colour = Genotype), size = 4)+
    labs(title = paste0("Thymus: ",popnm, " Frequency"),
         y = paste0(popnm, " Frequency"))+
    theme(plot.title = element_text(size=15))
  
  p4 = ggplot(thym, aes_string(x = "Age", y = ctColumn)) + 
    geom_point(aes(colour = Genotype), size = 4)+
    labs(title = paste0("Thymus: ", popnm," Counts at 10^6"),
         y = paste0(popnm, " Counts at 10^6"))+
    theme(plot.title = element_text(size=15))
  
  p6 = ggplot(ThymSum, aes_string(x="Age", y=ctColumn, group = "Genotype", color="Genotype")) + 
    geom_line() +
    geom_point(size = 6)+
    geom_errorbar(aes_string(ymin=paste(ctColumn,"-sd"), ymax=paste(ctColumn,"+sd")), width=.3,
                  position=position_dodge(0.18), size =1.5 )+
    labs(title=paste0("Thymus: ", popnm, " Count Mean and Error Bars"))+
    theme(plot.title = element_text(size=15))
  pdf(file =paste0(WorkingDirectory, "/", fileName), width = 14)
  multiplot(p1, p2, p3, p4, p5, p6, cols = 3)
  dev.off()
}

