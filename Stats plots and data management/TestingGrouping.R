require(plyr)
popa = read.csv('~/my.work/PhD/HomestaticExpansionProject/DELETE4.csv', 
                header = T, blank.lines.skip = TRUE)


library(dplyr)
library("Rmisc")
library("reshape2")
popa$Genotype = as.character(popa$Genotype)
popa$Age = as.factor(popa$Age)#This made plotting categories possible

popa = popa %>%
  group_by(CageNumber, Age ) %>% 
  mutate(ActivatedProlRatio = CD4ProlRatio - CD4ProlRatio[Genotype == 'WT'])

popa$ActivatedProlRatio[popa$ActivatedProlRatio < 0] <- 0 

popaWT = subset(popa, Genotype == "WT")
popaKO = subset(popa, Genotype == "KO")

popaKO$NaiveProlRatio = popaKO$CD4ProlRatio - popaKO$ActivatedProlRatio
popaKO$NaiveProlCT = popaK #Can't complete yet
popaKO$ActivatedProlCT = popaK #Can't complete yet


