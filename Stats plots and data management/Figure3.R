library(ggplot2)
library(ggpubr)
library(ggbreak)

ModeldataWT = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Stats plots and data management/ModelOutputWT2.csv")
ModeldataKO = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Stats plots and data management/ModelOutputKO2.csv")
WTData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen.csv")
ProlWTData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl.csv")
KOData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen.csv")
ProlKOData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl.csv")

WTData$hours = WTData$hours / 24
KOData$hours = KOData$hours / 24
ProlWTData$hours = ProlWTData$hours / 24
ProlKOData$hours = ProlKOData$hours / 24

colnames(ModeldataWT) = c("NaiveCT", "ActTCT", "TregCT", "ThyNaive", "ActTNaive", "ThyTregs",
                          "TregNaive", "ProlNaive", "ProlActT", "ProlTreg", "IL-2", "ThymWeigth")
colnames(ModeldataKO) = c("NaiveCT", "ActTCT", "TregCT", "ThyNaive", "ActTNaive", "ThyTregs",
                          "TregNaive", "ProlNaive", "ProlActT", "ProlTreg", "IL-2", "ThymWeigth")

ModeldataWT$time = 0:431
ModeldataKO$time = 0:431
ModeldataWT$time = ModeldataWT$time / 24
ModeldataKO$time = ModeldataKO$time / 24

dotsize = 4
wdt = 14.6
ht = 8.3
Dotedline = 2
simLine = 2

###########################################
#  WT - Naive
###########################################

# NAIVE T CELLS

NaiveCTWT = ggplot(WTData, aes(x=hours, y=NaiveCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=NaiveCT), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Naive T Cell Count", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,5000000), breaks = c(0, 1e+06, 2e+06, 3e+06, 4e+06, 5e+06), labels = c(0,1,2,3,4,5))

#TODO: Fix the axis on these to make so it shows 1,2,3,4,5 on all of these axis'
#PROLIFERATING NAIVE
ProlNaiveWT = ggplot(ProlWTData, aes(x=hours, y=NaiveProlCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ProlNaive), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Proliferating Naive T Cells", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,5000000), breaks = c(0, 1e+06, 2e+06, 3e+06, 4e+06, 5e+06), labels = c(0,1,2,3,4,5))

#THYMIC NAIVE
ThymicNaiveWT = ggplot(WTData, aes(x=hours, y=ThymicNaive)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ThyNaive), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Thymic Derived Naive T Cells", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,5000000), breaks = c(0, 1e+06, 2e+06, 3e+06, 4e+06, 5e+06), labels = c(0,1,2,3,4,5))

#############################################
# IL-2 KO Naive
#############################################


# NAIVE T CELLS

NaiveCTKO = ggplot(KOData, aes(x=hours, y=NaiveCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=NaiveCT), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Naive T Cell Count", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,5000000), breaks = c(0, 1e+06, 2e+06, 3e+06, 4e+06, 5e+06), labels = c(0,1,2,3,4,5))
  # scale_y_continuous(limits = c(0,4000000))

#PROLIFERATING NAIVE
ProlNaiveKO = ggplot(ProlKOData, aes(x=hours, y=NaiveProlCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=ProlNaive), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Proliferating Naive T Cells", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,5000000), breaks = c(0, 1e+06, 2e+06, 3e+06, 4e+06, 5e+06), labels = c(0,1,2,3,4,5))

#THYMIC NAIVE
ThymicNaiveKO = ggplot(KOData, aes(x=hours, y=ThymicNaive)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=ThyNaive), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Thymic Derived Naive T Cells", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,5000000), breaks = c(0, 1e+06, 2e+06, 3e+06, 4e+06, 5e+06), labels = c(0,1,2,3,4,5))


#Total Naive Overlap
TotalNaiveOverlap = ggplot(data=ModeldataWT, aes(x=time, y=NaiveCT)) +
  geom_line(lwd = simLine)+
  geom_line(data = ModeldataKO, aes(x = time, y=NaiveCT), linetype = "dashed", colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Naive T cells Comparison ", x = "Age in days", y = "Cell Counts")
  # scale_y_continuous(limits = c(0,1500000))

YlabelTregOverlap = expression(Cell~Counts~(10^5))
# TotalTregOverlap = 
  ggplot(data=ModeldataWT, aes(x=time, y=TregCT)) +
  geom_line(lwd = 1.5)+
  geom_line(data = ModeldataKO, aes(x = time, y=TregCT), linetype = "dashed", colour = "black", lwd = 1.5)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20),
        panel.border = element_rect(color = "black",
                                    fill = "NA",
                                    size = 2))+
  labs(titles = "Total Treg Comparison ", x = "Age in days", y = YlabelTregOverlap)+
scale_y_continuous(limits = c(0,300000), breaks = c(0, 100000, 200000, 300000), label = c(0,1,2,3))
  

YlabelTregOverlap = expression(Cell~Counts~(10^5))
# TotalTregOverlap = 
  ggplot(data=ModeldataWT, aes(x=time, y=ProlTreg)) +
    geom_line(lwd = 1.5)+
    geom_line(data = ModeldataKO, aes(x = time, y=ProlTreg), linetype = "dashed", colour = "black", lwd = 1.5)+
    theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
          legend.key = element_rect(fill = "white", colour = "black"),
          legend.background = (element_rect(colour= "black", fill = "white")),
          axis.title.x = element_text( colour="black", size=20),
          axis.title.y = element_text( colour = "black", size = 20),
          plot.title = element_text(lineheight=.8,  size = 20),
          axis.ticks.length=unit(.25, "cm"), 
          text = element_text(size=20),
          panel.border = element_rect(color = "black",
                                      fill = "NA",
                                      size = 2))+
    labs(titles = "Proliferating Treg Comparison ", x = "Age in days", y = YlabelTregOverlap)+
    scale_y_continuous(limits = c(0,150000), breaks = c(0,50000, 100000, 150000), label = c(0,0.5,1,1.5))
  
max(ModeldataWT$ProlTreg)

ggsave(file = "C:/Laptop Backups/HomestaticExpansionProject/Figures/ForPaper/Figure3/TotalNaive.pdf", TotalNaiveOverlap)
       # height = 4,
       # width = 4)

#################################################
#################################################
########### B - Activated T Cells ###############
#################################################
#################################################

# Total Activated

ActTCD4CTWT = ggplot(WTData, aes(x=hours, y=ActivatedCD4CT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ActTCT), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Activated T Cell Count", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,7075000))

#PROLIFERATING ACTIVATED T
ProlActTWT = ggplot(ProlWTData, aes(x=hours, y=ActivatedProlCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ProlActT), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Proliferating Activated T Cells", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,7075000))

#Naive Derived ActT
NaiveActTWT = ggplot(WTData, aes(x=hours, y=ActivatedNaiveCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ActTNaive), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Naive Derived Activated T Cells ", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,7075000))

#############################################
# IL-2 KO Naive
#############################################

# Total Activated

ActTCD4CTKO = ggplot(KOData, aes(x=hours, y=ActivatedCD4CT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=ActTCT), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Activated T Cell Count ", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,7075000))

#PROLIFERATING ACTIVATED T
ProlActTKO = ggplot(ProlKOData, aes(x=hours, y=ActivatedProlCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=ProlActT), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Proliferating Activated T Cells ", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,7075000))

#Naive Derived ActT
NaiveActTKO = ggplot(KOData, aes(x=hours, y=ActivatedNaiveCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=ActTNaive), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Naive Derived Activated T Cells ", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,7075000))


###########################################
#  WT - Acitve
##############################################

# Total Activated

ActTCD4CTWT = ggplot(WTData, aes(x=hours, y=ActivatedCD4CT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ActTCT), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Activated T Cell Count", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,7075000))

#PROLIFERATING ACTIVATED T
ProlActTWT = ggplot(ProlWTData, aes(x=hours, y=ActivatedProlCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ProlActT), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Proliferating Activated T Cells", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,7075000))

#Naive Derived ActT
NaiveActTWT = ggplot(WTData, aes(x=hours, y=ActivatedNaiveCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ActTNaive), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Naive Derived Activated T Cells ", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,7075000))

#############################################
# IL-2 KO Naive
#############################################

# Total Activated

ActTCD4CTKO = ggplot(KOData, aes(x=hours, y=ActivatedCD4CT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=ActTCT), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Activated T Cell Count ", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,7075000))

#PROLIFERATING ACTIVATED T
ProlActTKO = ggplot(ProlKOData, aes(x=hours, y=ActivatedProlCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=ProlActT), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Proliferating Activated T Cells ", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,7075000))

#Naive Derived ActT
NaiveActTKO = ggplot(KOData, aes(x=hours, y=ActivatedNaiveCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=ActTNaive), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Naive Derived Activated T Cells ", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,7075000))

#Overlap of the model lines

NaiveActTOverlap = ggplot(data=ModeldataWT, aes(x=time, y=ActTNaive)) +
  geom_line(lwd = 1.5)+
  geom_line(data = ModeldataKO, aes(x = time, y=ActTNaive), linetype = "dashed", colour = "black", lwd = 2)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Naive Derived Activated T cells ", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,2200000))


#####################################
#####################################
########### C - Tregs ###############
#####################################
#####################################

###########################################
#  WT - Tregs
##############################################

#Total Tregs
TregCTWT = ggplot(WTData, aes(x=hours, y=X4TregCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=TregCT), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Treg Counts", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,820000))

# Thymic Tregs

ThymicTregWT = ggplot(WTData, aes(x=hours, y=ThymicDerivedTregsCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ThyTregs), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Thymic Derived Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,820000))

#Naive Derived Tregs
NaiveTregWT = ggplot(WTData, aes(x=hours, y=NaiveDerivedTregsCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=TregNaive), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Peripherally Derived Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,820000))


#Proliferating Tregs
ProlTregWT = ggplot(ProlWTData, aes(x=hours, y=X4TregProlCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ProlTreg), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Proliferating Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,820000))



#############################################
# IL-2 KO Tregs
#############################################


#Total Tregs
TregCTKO = ggplot(KOData, aes(x=hours, y=X4TregCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=TregCT), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Treg Counts", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,820000))

# Thymic Tregs

ThymicTregKO = ggplot(KOData, aes(x=hours, y=ThymicDerivedTregsCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=ThyTregs), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Thymic Derived Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,820000))

#Naive Derived Tregs
NaiveTregKO = ggplot(KOData, aes(x=hours, y=NaiveDerivedTregsCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=TregNaive), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Peripherally Derived Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,820000))

#Proliferating Tregs
ProlTregKO = ggplot(ProlKOData, aes(x=hours, y=X4TregProlCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=ProlTreg), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Proliferating Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,820000))



#--------------------------------------------------------#

#--------------- Break plot Piece

ProlTregKO_Break = ggplot(ProlKOData, aes(x=hours, y=X4TregProlCT)) + geom_point(size = dotsize) +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataKO, aes(x = time, y=ProlTreg), colour = "black", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Proliferating Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,850000))+
  scale_y_break(c(400000, 800000))

#--------------------------------------------------------#








########################
########################
##### The ggsave #######
########################
########################
#---------------#
#------3A-------#
#---------------#
NaivePlots = ggarrange(NaiveCTWT, ProlNaiveWT, ThymicNaiveWT, NaiveCTKO, ProlNaiveKO, ThymicNaiveKO,
                       labels = c("A"),
                       ncol = 3, nrow = 2)

ggsave(file = "C:/Laptop Backups/HomestaticExpansionProject/Figures/ForPaper/Figure3/Figure3A.pdf", NaivePlots,
       height = 9,
       width = 14.75)

ggsave(file = "C:/Laptop Backups/HomestaticExpansionProject/Figures/ForPaper/Figure3/TotalNaive.pdf", TotalNaiveOverlap,
       height = 8.3,
       width = 10)

#---------------#
#------3B-------#
#---------------#
ActTPlots = ggarrange(ActTCD4CTWT, ProlActTWT, NaiveActTWT, ActTCD4CTKO, ProlActTKO, NaiveActTKO,
                      labels = c("B"),
                      ncol = 3, nrow = 2)

ggsave(file = "C:/Laptop Backups/HomestaticExpansionProject/Figures/ForPaper/Figure3/Figure3B.pdf", ActTPlots,
       height = 8.3,
       width = 14.95)

#Simulation comparison
ggsave(file = "C:/Laptop Backups/HomestaticExpansionProject/Figures/ForPaper/Figure3/Overlap.pdf", NaiveActTOverlap,
       height = 8.3,
       width = 10)


#---------------#
#------3C-------#
#---------------#

TregPlots = ggarrange(TregCTWT, ThymicTregWT, NaiveTregWT, ProlTregWT, TregCTKO, ThymicTregKO, NaiveTregKO, ProlTregKO,
                      labels = c("C"),
                      ncol = 4, nrow = 2)

ggsave(file = "C:/Laptop Backups/HomestaticExpansionProject/Figures/ForPaper/Figure3/Figure3C.pdf", TregPlots,
       height = ht,
       width = 19.8)

#the broken KO plot


ggsave(file = "C:/Laptop Backups/HomestaticExpansionProject/Figures/ForPaper/Figure3/ProlTregKO_Break.pdf", ProlTregKO_Break,
       height = ht,
       width = wdt)
