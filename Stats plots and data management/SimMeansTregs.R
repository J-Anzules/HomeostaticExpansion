library(ggplot2)
library(ggpubr)

ModeldataWT = read.csv("~/my.work/PhD/HomestaticExpansionProject/Code/Stats plots and data management/ModelOutputWT.csv")
ModeldataKO = read.csv("~/my.work/PhD/HomestaticExpansionProject/Code/Stats plots and data management/ModelOutputKO.csv")
WTData = read.csv("~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen.csv")
ProlWTData = read.csv("~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl.csv")
KOData = read.csv("~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen.csv")
ProlKOData = read.csv("~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl.csv")

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

###########################################
#  WT - Tregs
##############################################

#Total Tregs
TregCTWT = ggplot(WTData, aes(x=hours, y=X4TregCT)) + geom_point() +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted")+
  geom_line(data = ModeldataWT, aes(x = time, y=TregCT), colour = "purple")+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Treg Counts", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,665000))

# Thymic Tregs

ThymicTregWT = ggplot(WTData, aes(x=hours, y=ThymicDerivedTregsCT)) + geom_point() +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted")+
  geom_line(data = ModeldataWT, aes(x = time, y=ThyTregs), colour = "purple")+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Thymic Derived Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,665000))

#Naive Derived Tregs
NaiveTregWT = ggplot(WTData, aes(x=hours, y=NaiveDerivedTregsCT)) + geom_point() +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted")+
  geom_line(data = ModeldataWT, aes(x = time, y=TregNaive), colour = "purple")+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Peripherally Derived Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,665000))

#Proliferating Tregs
ProlTregWT = ggplot(ProlWTData, aes(x=hours, y=X4TregProlCT)) + geom_point() +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted")+
  geom_line(data = ModeldataWT, aes(x = time, y=ProlTreg), colour = "purple")+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Proliferating Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,665000))

#############################################
# IL-2 KO Tregs
#############################################


#Total Tregs
TregCTKO = ggplot(KOData, aes(x=hours, y=X4TregCT)) + geom_point() +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted")+
  geom_line(data = ModeldataKO, aes(x = time, y=TregCT), colour = "purple")+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Treg Counts", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,665000))

# Thymic Tregs

ThymicTregKO = ggplot(KOData, aes(x=hours, y=ThymicDerivedTregsCT)) + geom_point() +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted")+
  geom_line(data = ModeldataKO, aes(x = time, y=ThyTregs), colour = "purple")+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Thymic Derived Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,665000))

#Naive Derived Tregs
NaiveTregKO = ggplot(KOData, aes(x=hours, y=NaiveDerivedTregsCT)) + geom_point() +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted")+
  geom_line(data = ModeldataKO, aes(x = time, y=TregNaive), colour = "purple")+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Peripherally Derived Tregs", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,665000))

#Proliferating Tregs
ProlTregKO = ggplot(ProlKOData, aes(x=hours, y=X4TregProlCT)) + geom_point() +
  stat_summary(fun=mean, colour="black", geom="line", linetype="dotted")+
  geom_line(data = ModeldataKO, aes(x = time, y=ProlTreg), colour = "purple")+
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

TregPlots = ggarrange(TregCTWT, ThymicTregWT, NaiveTregWT, ProlTregWT, TregCTKO, ThymicTregKO, NaiveTregKO, ProlTregKO,
          labels = c("C"),
          ncol = 4, nrow = 2)

ggsave(file = "~/my.work/PhD/HomestaticExpansionProject/Figures/ForPaper/Figure3C.pdf", TregPlots,
       height = 8,
       width = 18)

