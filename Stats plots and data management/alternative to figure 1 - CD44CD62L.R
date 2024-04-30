
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
# YlabelA =  expression("%"~CD4^"+"~CD69^"+")
# YlabelB =  expression(~CD4^"+"~CD69^"+"~"Cells"~(10^6))
YlabelC_alt = expression("%"~CD4^"+"~CD44^"+"~CD62L^"-")
YlabelD_alt = expression(~CD4^"+"~CD44^"+"~CD62L^"-"~"Cells"~(10^6))
# YlabelE = expression("%"~CD44^"+"~CD62L^"-"~kI67^"+")
# YlabelF = expression(~CD44^"+"~CD62L^"-"~kI67^"+"~"Cells"~(10^6))
# YlabelG = expression("%"~CD4^"+"~Foxp3^"+")
# YlabelH = expression(CD4^"+"~Foxp3^"+"~"Cells"~(10^6))


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


#=============================================================================================#
#--------------------------------- Figure 1C_alt - CD44+CD62L- -------------------------------#
#=============================================================================================#

ActT = read.csv('C:/Laptop Backups/HomestaticExpansionProject/ModelData/TCellActivationSummary_filled.csv')

ActT$Genotype[ActT$Genotype == "IL-2-KO"] = "KO"
ActT$Genotype[ActT$Genotype == "IL-2-HET"] = "WT"
ActT$Genotype[ActT$Genotype == "CD25-KO"] = "KO"

ActT[ActT$Genotype != "",]
ActT = ActT[!(ActT$Genotype == ""),]
ActT = subset(ActT, Age <= 18 & Age > 0)

ActT = ActT[ActT$Age != 16, ]

CD4CD44CD62L =
  ggplot(ActT, aes(Age, pct_CD4_CD44_pos_CD62L_neg, color = Genotype, shape = Genotype))+
  scale_color_manual(values = c(KOColor, WTColor))+
  geom_point(position = position_dodge(1), size = dotSize)+
  # scale_x_continuous(breaks = c(0,5,10,15,18), limits=c(0,18.8))+
  labs(titles = "Activated CD4 T cell Percentage", x = "Age in Days", y =YlabelC_alt)+
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
  stat_summary(aes(group=Genotype, color = Genotype), fun=mean, geom="line", lwd = 1.3)+
  scale_y_continuous(breaks = c(0, 25, 50, 75), 
                     limits=c(-3.711, 75))

# max(ActT$pct_CD4_CD44_pos_CD62L_neg, na.rm = TRUE)
# lowlim = 0 - (72.34*0.0513)
# 1.079 - (16*0.0513)
# seq(0, 72.34, length.out = 4)

#=============================================================================================#
#----------------------------- Figure 2D_alt - CD44+CD62 Count -------------------------------#
#=============================================================================================#

ActivatedWTSpleen$ActivatedCD4CTWT = ActivatedWTSpleen$ActivatedCD4CT  
#Setting up Data
ActivatedCD4CTWT = subset(ActivatedWTSpleen, select = c("ActivatedCD4CTWT", "Age"))
LongActivatedCD4CTWT = gather(ActivatedCD4CTWT, variable, value, -Age)

ActivatedCD4CTKO = subset(ActivatedKOSpleen, select = c("ActivatedCD4CT", "Age"))
LongActivatedCD4CTKO = gather(ActivatedCD4CTKO, variable, value, -Age)
LongActivatedCD4CT = rbind(LongActivatedCD4CTWT, LongActivatedCD4CTKO)

LongActivatedCD4CT$variable = factor(LongActivatedCD4CT$variable, levels = c( "ActivatedCD4CT", "ActivatedCD4CTWT"), 
                                     labels = c("KO", "WT"))

CD4CD44CD62L_CT =
  ggplot(LongActivatedCD4CT, aes(x = Age, y = value, color = variable, shape = variable)) + 
  geom_point(position = position_dodge(1), size = dotSize)+
  stat_summary(aes(group=variable, color = variable), fun=mean, geom="line", lwd = 1.3)+
  labs(titles = "Activated Cd4 T cell count", x = "Age in Days", y = YlabelD_alt)+
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
  scale_y_continuous(limits = c(-272951.2, 5400000), 
                     breaks = c(0, 1773562 , 3547124 , 5320686), 
                     labels = c("0", "1.8M", "3.5M", "5.3M"))+
  scale_x_continuous(breaks = c(0,5,10,15,18), limits=c(0,18.8))+
  scale_color_manual(values = c(KOColor, WTColor))+
  guides(color = guide_legend(guide_legend(title = "Genotype")))

# max(LongActivatedCD4CT$value, na.rm = TRUE)
# 0 - (5320686*0.0513)
# seq(0, 5320686, length.out = 4)


#--------------------------------------------------------------------------#
#                               Saving
#--------------------------------------------------------------------------#

cd44_plot = ggarrange(CD4CD44CD62L, CD4CD44CD62L_CT,
              labels = c("C", "D"),
              ncol = 2, nrow = 1, widths = c(1, 1), align = "v")
# height - 1559 width = 837
ggsave(file = "C:/Users/jonan/Documents/HomeostaticExpansion/Manuscript/Figures/Figure 1 - Wt vs KO/cd44_alt_plot.pdf", cd44_plot,
       height = 3,
       width = 9)
  
  