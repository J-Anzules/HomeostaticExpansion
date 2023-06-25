#Preparing the data and the function
library(ggplot2)
library(scales)
library(tidyr)
library(ggbreak)
library(ggpubr)



#Setting title size
xAxisTextSize = 15
yAxisTextSize = 15
titleAxisTextSize = 10
AxisTickSize = 13
dotSize = 6


pop = read.csv("C:/Laptop Backups/HomestaticExpansionProject/ModelData/AfterCalculations.csv")


#-----------------------------------------------------------------------------#
#                                Figure 2A - Thymus
#-----------------------------------------------------------------------------#


#Getting only the Thymus Weights
popThym = subset(pop, Organ == "Thymus")
#Making miligram
popThym$OrganWeight = popThym$OrganWeight * 100 
#Plotting the Thymus

ThyWeight = ggplot(popThym, aes(intage, OrganWeight, shape = Genotype)) + 
  scale_shape_manual(values = c(16, 1)) +
  geom_point(position = position_dodge(1), size = dotSize)+
  #scale_x_continuous(breaks = seq(0,57,4), limits = c(-0.8,56))+
  scale_y_continuous(breaks = seq(0,max(popThym$OrganWeight, na.rm = TRUE), 
                                  length.out =5), labels = label_number(accuracy = 0.11))+
  labs(titles = "Thymus Weight", x = "Age in Days", y = "Weight (milligram)")+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text(face="bold", colour="black", size=xAxisTextSize),
        axis.title.y = element_text(face = "bold", colour = "black", 
                                    angle = 90, size = yAxisTextSize),
        plot.title = element_text(lineheight=.8, face="bold", size = titleAxisTextSize),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=AxisTickSize))+
  stat_summary(aes(group=Genotype, color = Genotype), fun=mean, geom="line") +
  xlim(0, 58)+
  scale_x_break(c(21, 54), scale = 0.2, ticklabels = c(54,56,58))

# ggsave("C:/Laptop Backups/HomestaticExpansionProject/Figures/For Dissertation/Experimental/ThyWeight.pdf",
#        width = 7,
#        height = 4)


#-----------------------------------------------------------------------------#
#                                Figure 2B - Spleen
#-----------------------------------------------------------------------------#

popSpln = subset(pop, Organ == "Spleen")
#Making the data in milligrams
popSpln$OrganWeight = popSpln$OrganWeight * 100 
#removing the day 56 outlier
popSpln = subset(popSpln, OrganWeight < 75)
#Plotting the Thymus
SplnWeight = ggplot(popSpln, aes(intage, OrganWeight, shape = Genotype)) + 
  scale_shape_manual(values = c(16, 1)) +
  geom_point(position = position_dodge(1), size = dotSize)+
  # scale_x_continuous(breaks = seq(0,56,4))+
  labs(titles = "Spleen Weight", x = "Age in Days", y = "Weight (milligram)")+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text(face="bold", colour="black", size=xAxisTextSize),
        axis.title.y = element_text(face = "bold", colour = "black",
                                    angle = 90, size = yAxisTextSize),
        plot.title = element_text(lineheight=.8, face="bold", size = titleAxisTextSize),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=AxisTickSize))+
  stat_summary(aes(group=Genotype, color = Genotype), fun=mean, geom="line")+
  xlim(0, 58)+
  scale_x_break(c(21, 54), scale = 0.2, ticklabels = c(54,56,58))


ggsave("C:/Laptop Backups/HomestaticExpansionProject/Plots/HomeoPlots/WithDay56/SpleenWeight.png",
       width = 7,
       height = 4)


ggsave(file = "~/my.work/PhD/HomestaticExpansionProject/Figures/ForPaper/Figure2/Figure2_V2.pdf", a,
       height = 11,
       width = 8)