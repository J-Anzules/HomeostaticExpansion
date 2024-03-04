############################################
#
# Generates a figure that will be edited in inkscape
# TODO: I need to make the file locations a relative location
#
#
#


library(scales)
library(ggplot2)
library(scales)
library(tidyr)
library(ggpubr)


#-----------------------------------------------------------#
#                     Plot parameters
#-----------------------------------------------------------#


dotSize = 6
xAxisTextSize = 10
yAxisTextSize = 10
titleAxisTextSize = 12
panelBorder = 2

#Makign a function that change the decimal places ofy axis values
scaleFUN <- function(x) sprintf("%.1f", x)

#Creating Y axis label for D-F
# YlabelDF = expression(CD44^"+"~CD62L^"-"~(10^6))
YlabelA =  expression("%"~CD4^"+"~CD69^"+")
YlabelB =  expression(~CD4^"+"~CD69^"+"~"Cells"~(10^6))
YlabelC = expression("%"~CD44^"+"~CD62L^"-"~kI67^"-")
YlabelD = expression(~CD44^"+"~CD62L^"-"~kI67^"-"~"Cells"~(10^6))
YlabelE = expression("%"~CD44^"+"~CD62L^"-"~kI67^"+")
YlabelF = expression(~CD44^"+"~CD62L^"-"~kI67^"+"~"Cells"~(10^6))
YlabelG = expression("%"~CD4^"+"~Foxp3^"+")
YlabelH = expression(CD4^"+"~Foxp3^"+"~"Cells"~(10^6))


#Color selection 
WTColor = "#8c8c8c"
KOColor = "#000000"

#-----------------------------------------------------------#
#                     Data Prep                             #
#-----------------------------------------------------------#

WTProl = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl.csv')
KOProl = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl.csv')
ActivatedWTSpleen = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen.csv')
ActivatedKOSpleen = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen.csv')

# CD69Data = read.csv('C:/Laptop Backups/HomestaticExpansionProject/ModelData/CD69DataFromGen.csv')
# #Removing day 0, because it is always weird
# CD69Data = subset(CD69Data, Age > 0 & Age < 19)



#=============================================================================================#
#--------------------------- Figure 1A - Early Activation Percentage--------------------------#
#=============================================================================================#
#Reduce all y axis lower limit by 0.0769 of the max value
# Percentage of CD44+CD62L-CD69+ cells

ActT = read.csv('C:/Laptop Backups/HomestaticExpansionProject/ModelData/TCellActivationSummary_filled.csv')

ActT$Genotype[ActT$Genotype == "IL-2-KO"] = "KO"
ActT$Genotype[ActT$Genotype == "IL-2-HET"] = "WT"
ActT$Genotype[ActT$Genotype == "CD25-KO"] = "KO"

ActT[ActT$Genotype != "",]
ActT = ActT[!(ActT$Genotype == ""),]
ActT = subset(ActT, Age <= 18 & Age > 0)

ActT = ActT[ActT$Age != 16, ]

CD4CD69 =
  ggplot(ActT, aes(Age, pct_CD4_CD69_pos, color = Genotype, shape = Genotype))+
  scale_color_manual(values = c(KOColor, WTColor))+
  geom_point(position = position_dodge(1), size = dotSize)+
  scale_x_continuous(breaks = c(0,5,10,15,18), limits=c(0,18.8))+
  scale_y_continuous(limits=c(-2.052, 40), breaks = c(0, 13, 26, 39))+
  labs(titles = "Early Activation Percentage", x = "Age in Days", y =YlabelA)+
  theme(panel.background = element_rect(fill = "white", colour = "black"),
        # legend.position = c(0.15, 0.85),
        legend.position = "none",
        axis.title.x = element_text(colour="black", size=xAxisTextSize),
        axis.title.y = element_text( colour = "black", size = yAxisTextSize),
        plot.title = element_text(lineheight=.8,  size = titleAxisTextSize),
        #axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20),
        panel.border = element_rect(color = "black",
                                    fill = "NA",
                                    size = panelBorder))+
    stat_summary(aes(group=Genotype, color = Genotype), fun=mean, geom="line", lwd = 1.3)
# 0 - (40 * 0.0513)
# seq(0, 39, length.out = 4)
#=============================================================================================#
#------------------------- Figure 1B - Early Activation Count --------------------------------#
#=============================================================================================#
#Total count of CD44+CD62L-CD69+ cells

ActivatedWTSpleen$EarlyActivatedCD4CTWT = ActivatedWTSpleen$EarlyActivatedCD4CT 
#Setting up Data
EarlyActivatedCD4CTWT = subset(ActivatedWTSpleen, select = c("EarlyActivatedCD4CTWT", "Age"))
LongEarlyActivatedCD4CTWT = gather(EarlyActivatedCD4CTWT, variable, value, -Age)

EarlyActivatedCD4CTKO = subset(ActivatedKOSpleen, select = c("EarlyActivatedCD4CT", "Age"))
LongEarlyActivatedCD4CTKO = gather(EarlyActivatedCD4CTKO, variable, value, -Age)
LongEarlyActivatedCD4CT = rbind(LongEarlyActivatedCD4CTWT, LongEarlyActivatedCD4CTKO)

LongEarlyActivatedCD4CT$variable = factor(LongEarlyActivatedCD4CT$variable, 
                                          levels = c("EarlyActivatedCD4CT", "EarlyActivatedCD4CTWT"), 
                                          labels = c( "KO", "WT"))

EarlyActivated_CT =
  ggplot(LongEarlyActivatedCD4CT, aes(x = Age, y = value, color = variable, shape = variable)) + 
  geom_point(position = position_dodge(1), size = dotSize)+
  stat_summary(aes(group=variable, color = variable), fun=mean, geom="line", lwd = 1.3)+
  labs(titles = "Early Activation Cell Count", x = "Age in Days", y = YlabelB)+
  theme(panel.background = element_rect(fill = "white", colour = "black"),
        legend.position = "none",
        axis.title.x = element_text(colour="black", size=xAxisTextSize),
        axis.title.y = element_text( colour = "black", size = yAxisTextSize),
        plot.title = element_text(lineheight=.8,  size = titleAxisTextSize),
        #axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20),
        panel.border = element_rect(color = "black",
                                    fill = "NA",
                                    size = panelBorder))+
  scale_y_continuous(breaks = c(0.0, 0.3, 0.6, 0.9), limits=c(-0.043605, 0.9))+
  scale_x_continuous(breaks = c(0,5,10,15,18), limits=c(0,18.8))+
  scale_color_manual(values = c(KOColor, WTColor))+
  guides(color = guide_legend("Legend"))

# 0 - (0.85*0.0513)
# seq(0, 0.9, length.out = 4)

#=============================================================================================#
#-------------------- Figure 1C - Non proliferating Activated T Cells % ----------------------#
#=============================================================================================#
#Percentage of CD44+CD62L-KI-67-



WTProl$NonProlActivatedRatioWT = WTProl$NonProlActivatedRatio * 100
KOProl$NonProlActivatedRatio = KOProl$NonProlActivatedRatio * 100 

#Setting up Data
NonProlActivatedRatioWT = subset(WTProl, select = c("NonProlActivatedRatioWT", "Age"))
LongNonProlActivatedRatioWT = gather(NonProlActivatedRatioWT, variable, value, -Age)

NonProlActivatedRatioKO = subset(KOProl, select = c("NonProlActivatedRatio", "Age"))
LongNonProlActivatedRatioKO = gather(NonProlActivatedRatioKO, variable, value, -Age)
LongNonProlActivatedRatio = rbind(LongNonProlActivatedRatioWT, LongNonProlActivatedRatioKO)

LongNonProlActivatedRatio$variable = factor(LongNonProlActivatedRatio$variable, 
                                      levels = c("NonProlActivatedRatio", "NonProlActivatedRatioWT"), 
                                      labels = c("KO", "WT"))

NonProlActT_pct =
  ggplot(LongNonProlActivatedRatio, aes(x = Age, y = value, color = variable, shape = variable)) + 
  geom_point(position = position_dodge(1), size = dotSize)+
  stat_summary(aes(group=variable, color = variable), fun=mean, geom="line", lwd = 1.3)+
  labs(titles = "Percentage of Non Proliferating Activated T Cells", x = "Age in Days", y = YlabelC)+
  theme(panel.background = element_rect(fill = "white", colour = "black"),
        legend.position = "none",
        axis.title.x = element_text(colour="black", size=xAxisTextSize),
        axis.title.y = element_text( colour = "black", size = yAxisTextSize),
        plot.title = element_text(lineheight=.8,  size = titleAxisTextSize),
        #axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20),
        panel.border = element_rect(color = "black",
                                    fill = "NA",
                                    size = panelBorder))+
  scale_y_continuous(breaks = c(40, 60, 80, 100), limits=c(34.87, 105))+
  scale_x_continuous(breaks = c(0,5,10,15,18), limits=c(0,18.8))+
  scale_color_manual(values = c(KOColor, WTColor))+
  guides(color = guide_legend("Legend"))

# 40 - (100*0.0513)
#=============================================================================================#
#-------------------- Figure 1D - Non proliferating Activated T Cells Count ----------------------#
#=============================================================================================#
#Percentage of CD44+CD62L-KI-67-

WTProl$NonProlActivatedCTWT = WTProl$NonProlActivatedCT


# plot(WTProl$Age,WTProl$NonProlActivatedCT, ylim = c(0, 1000000))
# plot(KOProl$Age, KOProl$NonProlActivatedCT, ylim = c(0, 1000000))
# 
# max(KOProl$NonProlActivatedCT)
# max(WTProl$NonProlActivatedCT)

#Setting up Data
NonProlActivatedCTWT = subset(WTProl, select = c("NonProlActivatedCTWT", "Age"))
LongNonProlActivatedCTWT = gather(NonProlActivatedCTWT, variable, value, -Age)

NonProlActivatedCTKO = subset(KOProl, select = c("NonProlActivatedCT", "Age"))
LongNonProlActivatedCTKO = gather(NonProlActivatedCTKO, variable, value, -Age)
LongNonProlActivatedCT = rbind(LongNonProlActivatedCTWT, LongNonProlActivatedCTKO)

LongNonProlActivatedCT$variable = factor(LongNonProlActivatedCT$variable, 
                                            levels = c("NonProlActivatedCT", "NonProlActivatedCTWT"), 
                                            labels = c("KO", "WT"))

NonProlActT_CT =
ggplot(LongNonProlActivatedCT, aes(x = Age, y = value, color = variable, shape = variable)) + 
  geom_point(position = position_dodge(1), size = dotSize)+
  stat_summary(aes(group=variable, color = variable), fun=mean, geom="line", lwd = 1.3)+
  labs(titles = "Non Proliferating Activated T Cell Counts", x = "Age in Days", y = YlabelD)+
  theme(panel.background = element_rect(fill = "white", colour = "black"),
       legend.position = "none",
        axis.title.x = element_text(colour="black", size=xAxisTextSize),
        axis.title.y = element_text( colour = "black", size = yAxisTextSize),
        plot.title = element_text(lineheight=.8,  size = titleAxisTextSize),
        #axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20),
       panel.border = element_rect(color = "black",
                                   fill = "NA",
                                   size = panelBorder))+
  scale_y_continuous(limits=c(-235980, 4400000), breaks = c(0, 1400642, 2801284, 4201926), 
                     labels = c(0.0, 1.4, 2.8, 4.2))+
  scale_x_continuous(breaks = c(0,5,10,15,18), limits=c(0,18.8))+
  scale_color_manual(values = c(KOColor, WTColor))+
  guides(color = guide_legend("Legend"))

# max(LongNonProlActivatedCT$value)
# seq(0, 4201926, length.out = 4)
# 0 - (4600000*0.0513)
#=============================================================================================#
#------------------- Figure 1E - Proliferating Activated T Cells Percentage ------------------#
#=============================================================================================#
#Count of CD44+CD62L-KI-67+

WTProl$ActivatedProlRatioWT = WTProl$ActivatedProlRatio * 100
KOProl$ActivatedProlRatio = KOProl$ActivatedProlRatio * 100

#Setting up Data
ActivatedProlRatioWT = subset(WTProl, select = c("ActivatedProlRatioWT", "Age"))
LongActivatedProlRatioWT = gather(ActivatedProlRatioWT, variable, value, -Age)

ActivatedProlRatioKO = subset(KOProl, select = c("ActivatedProlRatio", "Age"))
LongActivatedProlRatioKO = gather(ActivatedProlRatioKO, variable, value, -Age)
LongActivatedProlRatio = rbind(LongActivatedProlRatioWT, LongActivatedProlRatioKO)

LongActivatedProlRatio$variable = factor(LongActivatedProlRatio$variable, 
                                            levels = c("ActivatedProlRatio", "ActivatedProlRatioWT"), 
                                            labels = c("KO", "WT"))

ProlActT_pct =
ggplot(LongActivatedProlRatio, aes(x = Age, y = value, color = variable, shape = variable)) + 
  geom_point(position = position_dodge(1), size = dotSize)+
  stat_summary(aes(group=variable, color = variable), fun=mean, geom="line", lwd = 1.3)+
  labs(titles = "Proliferating Activated T Cells Percentage", x = "Age in Days", y = YlabelE)+
  theme(panel.background = element_rect(fill = "white", colour = "black"),
       legend.position = "none",
        axis.title.x = element_text(colour="black", size=xAxisTextSize),
        axis.title.y = element_text( colour = "black", size = yAxisTextSize),
        plot.title = element_text(lineheight=.8,  size = titleAxisTextSize),
        #axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20),
       panel.border = element_rect(color = "black",
                                   fill = "NA",
                                   size = panelBorder))+
  scale_y_continuous(breaks = c(0, 20, 40, 60), limits=c(-3.078, 65))+
  scale_x_continuous(breaks = c(0,5,10,15,18), limits=c(0,18.8))+
  scale_color_manual(values = c(KOColor, WTColor))+
  guides(color = guide_legend("Legend"))

# 0 - (60*0.0513)
#=============================================================================================#
#----------------------- Figure 1F - Proliferating Activated T Cells Count -------------------#
#=============================================================================================#
WTProl$ActivatedProlCTWT = WTProl$ActivatedProlCT

#Setting up Data
ActivatedProlCTWT = subset(WTProl, select = c("ActivatedProlCTWT", "Age"))
LongActivatedProlCTWT = gather(ActivatedProlCTWT, variable, value, -Age)

ActivatedProlCTKO = subset(KOProl, select = c("ActivatedProlCT", "Age"))
LongActivatedProlCTKO = gather(ActivatedProlCTKO, variable, value, -Age)
LongActivatedProlCT = rbind(LongActivatedProlCTWT, LongActivatedProlCTKO)

LongActivatedProlCT$variable = factor(LongActivatedProlCT$variable, levels = c("ActivatedProlCT", "ActivatedProlCTWT"), labels = c("KO", "WT"))

ProlActT_CT =
ggplot(LongActivatedProlCT, aes(x = Age, y = value, color = variable, shape = variable)) + 
  geom_point(position = position_dodge(1), size = dotSize)+
  stat_summary(aes(group=variable, color = variable), fun=mean, geom="line", lwd = 1.3)+
  labs(titles = "Proliferating Activated T Cell Counts", x = "Age in Days", y = YlabelF)+
  theme(panel.background = element_rect(fill = "white", colour = "black"),
       legend.position = "none",
        axis.title.x = element_text(colour="black", size=xAxisTextSize),
        axis.title.y = element_text( colour = "black", size = yAxisTextSize),
        plot.title = element_text(lineheight=.8,  size = titleAxisTextSize),
        #axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20),
       panel.border = element_rect(color = "black",
                                   fill = "NA",
                                   size = panelBorder))+
  scale_y_continuous(limits=c(-76900.01, 1500000), breaks = c( 0, 500000, 1000000, 1500000), 
                     labels = c(0, 0.5, 1.0, 1.5))+
  scale_x_continuous(breaks = c(0,5,10,15,18), limits=c(0,18.8))+
  scale_color_manual(values = c(KOColor, WTColor))+
  guides(color = guide_legend("Legend"))

# 0 - (1500000*0.0513)

#=============================================================================================#
#--------------------------------- Figure 1G - Treg Percentage -------------------------------#
#=============================================================================================#
ActivatedWTSpleen$X4TregRatio = ActivatedWTSpleen$X4TregRatio * 100
ActivatedKOSpleen$X4TregRatio = ActivatedKOSpleen$X4TregRatio * 100


ActivatedWTSpleen$X4TregRatioWT = ActivatedWTSpleen$X4TregRatio  
#Setting up Data
X4TregRatioWT = subset(ActivatedWTSpleen, select = c("X4TregRatioWT", "Age"))
LongX4TregRatioWT = gather(X4TregRatioWT, variable, value, -Age)

X4TregRatioKO = subset(ActivatedKOSpleen, select = c("X4TregRatio", "Age"))
LongX4TregRatioKO = gather(X4TregRatioKO, variable, value, -Age)
LongX4TregRatio = rbind(LongX4TregRatioWT, LongX4TregRatioKO)

LongX4TregRatio$variable = factor(LongX4TregRatio$variable, levels = c("X4TregRatio", "X4TregRatioWT"),
                                  labels = c("KO", "WT"))

Treg_pct =
ggplot(LongX4TregRatio, aes(x = Age, y = value, color = variable, shape = variable)) + 
  geom_point(position = position_dodge(1), size = dotSize)+
  stat_summary(aes(group=variable, color = variable), fun=mean, geom="line", lwd = 1.3)+
  labs(titles = "Percentage of Treg Cells", x = "Age in Days", y = YlabelG)+
  theme(panel.background = element_rect(fill = "white", colour = "black"),
       legend.position = "none",
        axis.title.x = element_text(colour="black", size=xAxisTextSize),
        axis.title.y = element_text( colour = "black", size = yAxisTextSize),
        plot.title = element_text(lineheight=.8,  size = titleAxisTextSize),
        #axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20),
       panel.border = element_rect(color = "black",
                                   fill = "NA",
                                   size = panelBorder))+
  scale_y_continuous(limits=c(0, 18), breaks = c(0, 6, 12, 18))+
  scale_x_continuous(breaks = c(0,5,10,15,18), limits=c(0,18.8))+
  scale_color_manual(values = c(KOColor, WTColor))+
  guides(color = guide_legend("Legend"))

# 1.079 - (16*0.0513)
# seq(0, 18, length.out = 4)

#=============================================================================================#
#----------------------------------- Figure 2H - Treg Count ----------------------------------#
#=============================================================================================#

ActivatedWTSpleen$X4TregCTWT = ActivatedWTSpleen$X4TregCT  
#Setting up Data
X4TregCTWT = subset(ActivatedWTSpleen, select = c("X4TregCTWT", "Age"))
LongX4TregCTWT = gather(X4TregCTWT, variable, value, -Age)

X4TregCTKO = subset(ActivatedKOSpleen, select = c("X4TregCT", "Age"))
LongX4TregCTKO = gather(X4TregCTKO, variable, value, -Age)
LongX4TregCT = rbind(LongX4TregCTWT, LongX4TregCTKO)

LongX4TregCT$variable = factor(LongX4TregCT$variable, levels = c( "X4TregCT", "X4TregCTWT"), labels = c("KO", "WT"))

Treg_CT =
ggplot(LongX4TregCT, aes(x = Age, y = value, color = variable, shape = variable)) + 
  geom_point(position = position_dodge(1), size = dotSize)+
  stat_summary(aes(group=variable, color = variable), fun=mean, geom="line", lwd = 1.3)+
  labs(titles = "Treg Cell Count", x = "Age in Days", y = YlabelH)+
  theme(panel.background = element_rect(fill = "white", colour = "black"),
        legend.position = "none",
        axis.title.x = element_text(colour="black", size=xAxisTextSize),
        axis.title.y = element_text( colour = "black", size = yAxisTextSize),
        plot.title = element_text(lineheight=.8,  size = titleAxisTextSize),
        #axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20),
        panel.border = element_rect(color = "black",
                                    fill = "NA",
                                    size = panelBorder))+
  # scale_y_continuous(breaks = seq(0,3880000, length.out = 5))+
  scale_y_continuous(limits=c(-61560, 1200000), breaks = c(0, 400000, 800000, 1200000), 
                     labels = c(0, 0.4, 0.8, 1.2))+
  scale_x_continuous(breaks = c(0,5,10,15,18), limits=c(0,18.8))+
  scale_color_manual(values = c(KOColor, WTColor))+
  guides(color = guide_legend(guide_legend(title = "Genotype")))


# 0-(1200000*0.0513)

#-----------------------------------------------------------------------------------------------#
#---------------------------------- Final Figure arrangement------------------------------------#
#-----------------------------------------------------------------------------------------------#

a = ggarrange(CD4CD69, EarlyActivated_CT, NonProlActT_pct, NonProlActT_CT, ProlActT_pct, ProlActT_CT,Treg_pct,Treg_CT,
              labels = c("A", "B", "C", "D", "E", "F", "G", "H"),
              ncol = 2, nrow = 4, widths = c(1, 1), align = "v")
# height - 1559 width = 837
ggsave(file = "C:/Laptop Backups/HomestaticExpansionProject/Figures/ForPaper/Figure 1 - Wt vs KO/Figure1_V4_018nodata.pdf", a,
       height = 11,
       width = 8)




#------------------#
# For the Legned
#------------------#
# 
# ggplot(LongActivatedProlCT, aes(x = Age, y = value, color = variable)) +
#   geom_point(position = position_dodge(1), size = dotSize)+
#   stat_summary(aes(group=variable, color = variable), fun=mean, geom="line")+
#   labs(titles = "Proliferating Activated T Cells", x = "Age in Days", y = YlabelDF)+
#   theme(panel.background = element_rect(fill = "white", colour = "black"),
#         legend.key = element_rect(fill = "white", colour = "black"),
#         legend.background = (element_rect(colour= "black", fill = "white")),
#         axis.title.x = element_text( colour="black", size=20),
#         axis.title.y = element_text( colour = "black", size = yAxisTextSize),
#         plot.title = element_text(lineheight=.8,  size = titleAxisTextSize),
#         #axis.ticks.length=unit(.25, "cm"),
#         text = element_text(size=20))+
#   # scale_y_continuous(breaks =seq(0,2138000, length.out = 5 ))+
#   scale_y_continuous(limits=c(0, 7072000), breaks = c(0, 1768000, 3536000, 5304000, 7072000), labels = c(0, 1.7, 3.5, 5.3, 7.0))+
#   scale_x_continuous(breaks = c(0,5,10,15,18), limits=c(0,18.8))+
#   scale_color_manual(labels = c("WT", "IL-2 KO"), values = c(KOColor, WTColor))+
#   guides(color = guide_legend(guide_legend(title = "Genotype")))
# 
# ggsave(file = "~/my.work/PhD/HomestaticExpansionProject/Figures/ForPaper/Figure2/legend.pdf", JustForLegend,
#        height = 8,
#        width = 15)

