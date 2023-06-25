library("ggplot2")

#Model Output
ModeldataWT = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ModelOutputEverythingWT.csv")
ModeldataKO = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ModelOutputEverythingKO.csv")

#Experimental Data
WTData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen.csv")
ProlWTData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl.csv")
KOData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen.csv")
ProlKOData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl.csv")
#Residuals
WTResiduals = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ResidualsWT.csv")
KOResiduals = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ResidualsKO.csv")

WTResiduals$day = WTResiduals$hour/24
KOResiduals$day = KOResiduals$hour/24

WTData$hours = WTData$hours / 24
KOData$hours = KOData$hours / 24
ProlWTData$hours = ProlWTData$hours / 24
ProlKOData$hours = ProlKOData$hours / 24

colnames(ModeldataWT) = c("NaiveCT", "ActTCT", "TregCT", "ThyNaive", "ActTNaive", "ThyTregs",
                          "TregNaive", "ProlNaive", "ProlActT", "ProlTreg", "IL-2", "ThymWeigth")
colnames(ModeldataKO) = c("NaiveCT", "ActTCT", "TregCT", "ThyNaive", "ActTNaive", "ThyTregs",
                          "TregNaive", "ProlNaive", "ProlActT", "ProlTreg", "IL-2", "ThymWeigth")

ModeldataWT$time = 0:432
ModeldataKO$time = 0:432
ModeldataWT$time = ModeldataWT$time / 24
ModeldataKO$time = ModeldataKO$time / 24

dotsize = 4
wdt = 14.6
ht = 8.3
Dotedline = 2
simLine = 2

#----------------------------------------------------------------------------#
#                     Total Cellular Populations
#----------------------------------------------------------------------------#

############################################################################
#                         Naive T cells WT
############################################################################

ggplot(WTData, aes(x=hours, y=NaiveCT)) + geom_point(size = dotsize) +
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
  labs(titles = "Total Naive T Cell Count (WT)", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(limits = c(0,7075000), )

ggplot(WTResiduals, aes(x=hour, y=N)) + geom_point(size = dotsize) +
  geom_hline(yintercept =  0, size= simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Naive T Cell Count (WT)", x = "Age in days", y = "Cell Counts")



############################################################################
#                         Naive T cells KO
############################################################################

ggplot(KOData, aes(x=hours, y=NaiveCT)) + geom_point(size = dotsize) +
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
  labs(titles = "Total Naive T Cell Count (KO)", x = "Age in days", y = "Cell Counts")

ggplot(KOResiduals, aes(x=hour, y=N)) + geom_point(size = dotsize) +
  geom_hline(yintercept =  0, size= simLine)+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=20),
        axis.title.y = element_text( colour = "black", size = 20),
        plot.title = element_text(lineheight=.8,  size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  labs(titles = "Total Naive T Cell Count (KO)", x = "Age in days", y = "Cell Counts")



############################################################################
#                         Activated T cells
############################################################################

