library(ggplot2)
library(ggpubr)
library(ggbreak)

ModeldataWT = read.csv("../../Data/ModelOutputWT.csv")
ModeldataKO = read.csv("../../Data/ModelOutputKO.csv")
WTData = read.csv("../../RawData/ActivatedWTSpleen.csv")
ProlWTData = read.csv("../../RawData/WTProl.csv")
KOData = read.csv("../../RawData/ActivatedKOSpleen.csv")
ProlKOData = read.csv("../../RawData/KOProl.csv")

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

NaiveCTWT = ggplot(WTData, aes(x=hours, y=NaiveCT)) + geom_point(shape = 17, size = dotsize, colour = "#8c8c8cff") +
  stat_summary(fun=mean, colour = "#8c8c8cff", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=NaiveCT), colour = "#8c8c8cff", lwd = simLine)+
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


#PROLIFERATING NAIVE
ProlNaiveWT = ggplot(ProlWTData, aes(x=hours, y=NaiveProlCT)) + geom_point(shape = 17, size = dotsize, colour = "#8c8c8cff") +
  stat_summary(fun=mean, colour = "#8c8c8cff", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ProlNaive), colour = "#8c8c8cff", lwd = simLine)+
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
ThymicNaiveWT = ggplot(WTData, aes(x=hours, y=ThymicNaive)) + geom_point(shape = 17, size = dotsize, colour = "#8c8c8cff") +
  stat_summary(fun=mean, colour = "#8c8c8cff", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ThyNaive), colour = "#8c8c8cff", lwd = simLine)+
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

ggsave(file = "../../Plots/Figure3/TotalNaive.pdf", TotalNaiveOverlap)
       # height = 4,
       # width = 4)

#################################################
#################################################
########### B - Activated T Cells ###############
#################################################
#################################################

# Total Activated

ActTCD4CTWT = ggplot(WTData, aes(x=hours, y=ActivatedCD4CT)) + geom_point(shape = 17, size = dotsize, colour = "#8c8c8cff") +
  stat_summary(fun=mean, colour = "#8c8c8cff", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ActTCT), colour = "#8c8c8cff", lwd = simLine)+
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
ProlActTWT = ggplot(ProlWTData, aes(x=hours, y=ActivatedProlCT)) + geom_point(shape = 17, size = dotsize, colour = "#8c8c8cff") +
  stat_summary(fun=mean, colour = "#8c8c8cff", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ProlActT), colour = "#8c8c8cff", lwd = simLine)+
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
NaiveActTWT = ggplot(WTData, aes(x=hours, y=ActivatedNaiveCT)) + geom_point(shape = 17, size = dotsize, colour = "#8c8c8cff") +
  stat_summary(fun=mean, colour = "#8c8c8cff", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ActTNaive), colour = "#8c8c8cff", lwd = simLine)+
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
#  WT - Activated
##############################################

# Total Activated

ActTCD4CTWT = ggplot(WTData, aes(x=hours, y=ActivatedCD4CT)) + geom_point(shape = 17, size = dotsize, colour = "#8c8c8cff") +
  stat_summary(fun=mean, colour = "#8c8c8cff", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ActTCT), colour = "#8c8c8cff", lwd = simLine)+
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
ProlActTWT = ggplot(ProlWTData, aes(x=hours, y=ActivatedProlCT)) + geom_point(shape = 17, size = dotsize, colour = "#8c8c8cff") +
  stat_summary(fun=mean, colour = "#8c8c8cff", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ProlActT), colour = "#8c8c8cff", lwd = simLine)+
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
NaiveActTWT = ggplot(WTData, aes(x=hours, y=ActivatedNaiveCT)) + geom_point(shape = 17, size = dotsize, colour = "#8c8c8cff") +
  stat_summary(fun=mean, colour = "#8c8c8cff", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ActTNaive), colour = "#8c8c8cff", lwd = simLine)+
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

# Total Tregs
TregCTWT = ggplot(WTData, aes(x=hours, y=X4TregCT)) + geom_point(shape = 17, size = dotsize, colour = "#8c8c8cff") +
  stat_summary(fun=mean, colour = "#8c8c8cff", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=TregCT), colour = "#8c8c8cff", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Treg Counts", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,1050000), breaks = c(0, 2e+05, 4e+05, 6e+05, 8e+05, 1e+06), labels = c(0,2,5,6,8,10))

# Thymic Tregs

ThymicTregWT = ggplot(WTData, aes(x=hours, y=ThymicDerivedTregsCT)) + geom_point(shape = 17, size = dotsize, colour = "#8c8c8cff") +
  stat_summary(fun=mean, colour = "#8c8c8cff", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ThyTregs), colour = "#8c8c8cff", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Thymic Derived Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,1050000), breaks = c(0, 2e+05, 4e+05, 6e+05, 8e+05, 1e+06), labels = c(0,2,5,6,8,10))

#Naive Derived Tregs
NaiveTregWT = ggplot(WTData, aes(x=hours, y=NaiveDerivedTregsCT)) + geom_point(shape = 17, size = dotsize, colour = "#8c8c8cff") +
  stat_summary(fun=mean, colour = "#8c8c8cff", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=TregNaive), colour = "#8c8c8cff", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Peripherally Derived Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,1050000), breaks = c(0, 2e+05, 4e+05, 6e+05, 8e+05, 1e+06), labels = c(0,2,5,6,8,10))


#Proliferating Tregs
ProlTregWT = ggplot(ProlWTData, aes(x=hours, y=X4TregProlCT)) + geom_point(shape = 17, size = dotsize, colour = "#8c8c8cff") +
  stat_summary(fun=mean, colour = "#8c8c8cff", geom="line", linetype="dotted", lwd = Dotedline)+
  geom_line(data = ModeldataWT, aes(x = time, y=ProlTreg), colour = "#8c8c8cff", lwd = simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Proliferating Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,1050000), breaks = c(0, 2e+05, 4e+05, 6e+05, 8e+05, 1e+06), labels = c(0,2,5,6,8,10))



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
scale_y_continuous(limits = c(0,1050000), breaks = c(0, 2e+05, 4e+05, 6e+05, 8e+05, 1e+06), labels = c(0,2,5,6,8,10))

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
  scale_y_continuous(limits = c(0,1050000), breaks = c(0, 2e+05, 4e+05, 6e+05, 8e+05, 1e+06), labels = c(0,2,5,6,8,10))

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
  scale_y_continuous(limits = c(0,1050000), breaks = c(0, 2e+05, 4e+05, 6e+05, 8e+05, 1e+06), labels = c(0,2,5,6,8,10))

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
  scale_y_continuous(limits = c(0,1050000), breaks = c(0, 2e+05, 4e+05, 6e+05, 8e+05, 1e+06), labels = c(0,2,5,6,8,10))





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


ggsave(file = "../../Plots/Figure3/Figure3A.pdf", NaivePlots,
       height = 9,
       width = 14.75)

ggsave(file = "../../Plots/Figure3/TotalNaive.pdf", TotalNaiveOverlap,
       height = 8.3,
       width = 10)

#---------------#
#------3B-------#
#---------------#
ActTPlots = ggarrange(ActTCD4CTWT, ProlActTWT, NaiveActTWT, ActTCD4CTKO, ProlActTKO, NaiveActTKO,
                      labels = c("B"),
                      ncol = 3, nrow = 2)

ggsave(file = "../../Plots/Figure3/Figure3B.pdf", ActTPlots,
       height = 8.3,
       width = 14.95)

#Simulation comparison
ggsave(file = "../../Plots/Figure3/Overlap.pdf", NaiveActTOverlap,
       height = 8.3,
       width = 10)


#---------------#
#------3C-------#
#---------------#

TregPlots = ggarrange(TregCTWT, ThymicTregWT, NaiveTregWT, ProlTregWT, TregCTKO, ThymicTregKO, NaiveTregKO, ProlTregKO,
                      labels = c("C"),
                      ncol = 4, nrow = 2)

ggsave(file = "../../Plots/Figure3/Figure3C.pdf", TregPlots,
       height = ht,
       width = 19.8)

#---------------------- Figure Parameters -------------------------------------

# Define sizes
dotsize_mm_KO   <- 1.75
dotsize_mm_WT   <- 2.06
linewidth_pt    <- 0.655
width_fig       <- 31.39
height_fig      <- 25.29

# As minimal as possible theme
small_theme_clean <- theme_minimal(base_size = 6) +
  theme(
    axis.title.x = element_blank(),                   # No x-axis title
    axis.title.y = element_blank(),                   # No y-axis title
    axis.text.x  = element_blank(),                   # No x-axis numbers
    axis.text.y  = element_blank(),                   # No y-axis numbers
    axis.ticks.x = element_line(linewidth = 0.3),     # Keep x-axis ticks
    axis.ticks.y = element_line(linewidth = 0.3),     # Keep y-axis ticks
    axis.line    = element_blank(),                   # No axis lines beyond ticks
    panel.grid   = element_blank(),                   # No grid lines
    panel.background = element_blank(),
    plot.background  = element_blank(),               # No white background
    panel.background = element_rect(
      fill = "white", color = "black", linewidth = 0.4  # Border box
    ),
    plot.background = element_rect(fill = "white", color = NA),
    plot.title = element_blank(),                     # No title
    plot.margin = margin(0, 0, 0, 0, "mm")
  )

# summarizing
stat_summary_KO <- stat_summary(
  fun       = mean,
  colour    = "black",
  geom      = "line",
  linetype  = "dotted",
  size      = linewidth_pt
)

stat_summary_WT <- stat_summary(
  fun=mean, 
  colour = "#8c8c8cff", 
  geom="line", 
  linetype="dotted", 
  lwd = linewidth_pt)

# Geom Points
geom_point_WT <- geom_point(shape = 17, size = dotsize_mm_WT, colour = "#8c8c8cff")
geom_point_KO <- geom_point(size = dotsize_mm_KO)

# Y axis scale
scale_y_Treg <- scale_y_continuous(
  limits = c(0, 1050000),
  breaks = c(0, 2e5, 4e5, 6e5, 8e5, 1e6),
  labels = c(0, 2, 5, 6, 8, 10)
)

#------------------------Figures 3C WT--------------------------------------
# Total Tregs
TregCTWT = ggplot(WTData, aes(x=hours, y=X4TregCT)) + 
  geom_line(data = ModeldataWT, aes(x = time, y=TregCT), colour = "#8c8c8cff", lwd = linewidth_pt)+
  geom_point_WT +
  stat_summary_WT +
  small_theme_clean +
  scale_y_Treg

ggsave(
  filename = "../../Plots/Figure3/Fig3C/WT/TregCTWT.pdf",
  plot     = TregCTWT,
  width    =  width_fig,  # mm
  height   =  height_fig,  # mm
  units    = "mm",
  dpi      = 300
)

# Thymic Tregs

ThymicTregWT = ggplot(WTData, aes(x=hours, y=ThymicDerivedTregsCT)) + 
  geom_line(data = ModeldataWT, 
            aes(x = time, y=ThyTregs), 
            colour = "#8c8c8cff", 
            lwd = linewidth_pt)+
  geom_point_WT +
  stat_summary_WT +
  small_theme_clean +
  scale_y_Treg

ggsave(
  filename = "../../Plots/Figure3/Fig3C/WT/ThymicTregWT.pdf",
  plot     = ThymicTregWT,
  width    =  width_fig,  # mm
  height   =  height_fig,  # mm
  units    = "mm",
  dpi      = 300
)


#Naive Derived Tregs
NaiveTregWT = ggplot(WTData, aes(x=hours, y=NaiveDerivedTregsCT)) +  
  geom_line(data = ModeldataWT, 
            aes(x = time, y=TregNaive), 
            colour = "#8c8c8cff", 
            lwd = linewidth_pt)+
  geom_point_WT +
  stat_summary_WT +
  small_theme_clean +
  scale_y_Treg

ggsave(
  filename = "../../Plots/Figure3/Fig3C/WT/NaiveTregWT.pdf",
  plot     = NaiveTregWT,
  width    =  width_fig,  # mm
  height   =  height_fig,  # mm
  units    = "mm",
  dpi      = 300
)


#Proliferating Tregs
ProlTregWT = ggplot(ProlWTData, aes(x=hours, y=X4TregProlCT)) + 
  geom_line(data = ModeldataWT, 
            aes(x = time, y=ProlTreg), 
            colour = "#8c8c8cff", 
            lwd = linewidth_pt)+
  stat_summary_WT +
  geom_point_WT +
  small_theme_clean +
  scale_y_Treg

ggsave(
  filename = "../../Plots/Figure3/Fig3C/WT/ProlTregWT.pdf",
  plot     = ProlTregWT,
  width    =  width_fig,  # mm
  height   =  height_fig,  # mm
  units    = "mm",
  dpi      = 300
)




#----------------------- Figures 3C KO---------------------------------------
#############################################
# IL-2 KO Tregs
#############################################

#Total Tregs
TregCTKO = ggplot(KOData, aes(x=hours, y=X4TregCT)) + 
  geom_line(data = ModeldataKO, 
            aes(x = time, y=TregCT), 
            colour = "black", 
            lwd = linewidth_pt)+
  geom_point_KO +
  stat_summary_KO +
  small_theme_clean +
  scale_y_Treg

ggsave(
  filename = "../../Plots/Figure3/Fig3C/KO/TregCTKO.pdf",
  plot     = TregCTKO,
  width    =  width_fig,  # mm
  height   =  height_fig,  # mm
  units    = "mm",
  dpi      = 300
)

# Thymic Tregs
ThymicTregKO = ggplot(KOData, aes(x=hours, y=ThymicDerivedTregsCT)) +
  geom_line(data = ModeldataKO, 
            aes(x = time, y=ThyTregs), 
            colour = "black", 
            lwd = linewidth_pt)+
  geom_point_KO +
  stat_summary_KO +
  small_theme_clean +
  scale_y_Treg

ggsave(
  filename = "../../Plots/Figure3/Fig3C/KO/ThymicTregKO.pdf",
  plot     = ThymicTregKO,
  width    =  width_fig,  # mm
  height   =  height_fig,  # mm
  units    = "mm",
  dpi      = 300
)

#Naive Derived Tregs KO
NaiveTregKO = ggplot(KOData, aes(x=hours, y=NaiveDerivedTregsCT)) + 
  geom_line(data = ModeldataKO, 
            aes(x = time, y=TregNaive), 
            colour = "black", 
            lwd = linewidth_pt)+
  geom_point_KO +
  stat_summary_KO +
  small_theme_clean +
  scale_y_Treg

ggsave(
  filename = "../../Plots/Figure3/Fig3C/KO/NaiveTregKO.pdf",
  plot     = NaiveTregKO,
  width    =  width_fig,  # mm
  height   =  height_fig,  # mm
  units    = "mm",
  dpi      = 300
)


# Prol Treg KO
ProlTregKO <- ggplot(ProlKOData, aes(x = hours, y = X4TregProlCT)) +
  geom_line(
    data   = ModeldataKO,
    aes(x = time, y = ProlTreg),
    colour = "black",
    size    = linewidth_pt
  ) +
  geom_point_KO +
  stat_summary_KO +
  small_theme_clean +
  scale_y_Treg


ggsave(
  filename = "../../Plots/Figure3/Fig3C/KO/ProlTregKO.pdf",
  plot     = ProlTregKO,
  width    =  width_fig,  # mm
  height   =  height_fig,  # mm
  units    = "mm",
  dpi      = 300
)




