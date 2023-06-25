#This script is to plot all of the calculations that were made in "popCount_V2.R
#################3
###### Plots Version 2
###################


PlotPopTreg = function(popl,ctColumn, ratioColumnm, popnm, fileName, WorkingDirectory){
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


#function(popl, TotalCell, TotalRatio, fileName, PageTitle)
PlotPops(pop, "CD4CT", "CD4Ratio", "CD4 T cells", "10-CD4.pdf")
PlotPops(pop, "CD8ct", "CD8Ratio", "CD8 T cells", "12-CD8.pdf")
PlotPops(pop, "Bct", "Bratio", "B cells", "13-BCells.pdf")
PlotPops(pop, "X4TregCT", "X4TregRatio", "CD4 Tregs", "14-Tregs.pdf")
PlotPops(pop, "X8TregCT", "X8TregRatio", "CD8 T regs", "15-TTvregs.pdf")
PlotPops(pop, "TCRbCT", "TCRbRatio", "TCRb", "16-zzTcrb.pdf")

PlotPops(pop, "CD4ProlCT", "CD4ProlRatio", "CD4 Proliferation", "17-CD4Prol.pdf")



PlotPops(pop, "CD8ProlCT", "CD8ProlRatio", "CD8 Proliferation", "21-CD8Prol.pdf")


PlotPops(pop, "BprolCT", "BProlRatio", "B Proliferation", "25-BProl.pdf")

PlotPops(pop, "X4TregProlCT", "X4TregProlRatio", "CD4 Treg Proliferation", "29-X4tregProli.pdf")

PlotPops(pop, "X8TregProlCT", "X8TregProlRatio", "CD8 Treg Proliferation", "33-8tregprol.pdf")

setwd('/ModelData/')
write.csv(pop, "AfterCalulations.csv")
