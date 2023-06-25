ActivData = read.csv("~/my.work/PhD/HomestaticExpansionProject/ModelData/TCellActivationSummary_filled.csv")

#Now removing the rows that have empty data under the CD4_pct column
completeFun <- function(data, desiredCols) {
  completeVec <- complete.cases(data[, desiredCols])
  return(data[completeVec, ])
}


#Fixing up some syntax stuff
ActivData = completeFun(ActivData, "Page")
ActivData$Genotype = as.character(ActivData$Genotype)
ActivData$Genotype[ActivData$Genotype == "IL-2-HET"] = "WT"
ActivData$Genotype[ActivData$Genotype == "IL-2-KO"] = "KO"
#Making anything day 18 and above day 18
ActivData$Age[ActivData$Age > 18] = 18

#Removing unnecessary rows 
ActivData <- subset(ActivData, Genotype != "CD25-KO" )
ActivData <- subset(ActivData, Age != 15 ) #Don't need day 15
ActivData <- subset(ActivData, Age != 0 ) #Removing day 0's
ActivData = ActivData[!is.na(ActivData$pct_CD4_CD44_pos_CD62L_neg), ]

write.csv(ActivData, "~/my.work/PhD/HomestaticExpansionProject/ModelData/TCellActivationSummary_EdittedinR.csv")
ActivData = read.csv("~/my.work/PhD/HomestaticExpansionProject/ModelData/TCellActivationSummary_EdittedinR.csv")

library(ggplot2)
library(scales)
ActivData$pct_CD4_CD44_pos_CD62L_neg = ActivData$pct_CD4_CD44_pos_CD62L_neg/100
ggplot(ActivData, aes(Age, pct_CD4_CD44_pos_CD62L_neg, shape = Genotype)) + 
  geom_point(position = position_dodge(1), size = 4)+
  scale_x_continuous(breaks = c(0,5,10,15,18))+
  scale_y_continuous(breaks = seq(0,max(ActivData$pct_CD4_CD44_pos_CD62L_neg, na.rm = TRUE),
                                  length.out =5),
                     labels = label_percent())+
  labs(titles = "CD44+CD62- Percentage", x = "Age in Days", y = "CD4CD44CD62L+ Percentage")+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text(face="bold", colour="black", size=20),
        axis.title.y = element_text(face = "bold", colour = "black", size = 20),
        plot.title = element_text(lineheight=.8, face="bold", size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  stat_summary(aes(group=Genotype, color = Genotype), fun=mean, geom="line")



ActivData$pct_CD4_CD62L_pos = ActivData$pct_CD4_CD62L_pos/100
ggplot(ActivData, aes(Age, pct_CD4_CD62L_pos, shape = Genotype)) + 
  geom_point(position = position_dodge(1), size = 4)+
  scale_x_continuous(breaks = c(0,5,10,15,18))+
  scale_y_continuous(breaks = seq(0,max(ActivData$pct_CD4_CD62L_pos, na.rm = TRUE),
                                  length.out =5),
                     labels = label_percent())+
  labs(titles = "CD44-CD62+ Percentage", x = "Age in Days", y = "CD4CD44CD62L+ Percentage")+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text(face="bold", colour="black", size=20),
        axis.title.y = element_text(face = "bold", colour = "black", size = 20),
        plot.title = element_text(lineheight=.8, face="bold", size = 20),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=20))+
  stat_summary(aes(group=Genotype, color = Genotype), fun=mean, geom="line")



