install.packages("tidyverse")
library(tidyverse)
library(ggplot2)

source('~/my.work/PhD/Data/Work with Thad/Code/popCount_V2.R')
StatsPop = pop[which(pop$intage >= 9 & pop$intage < 30),]
# StatsPop = pop
fit <- glm(formula = StatsPop$CD4CT ~ intage * Genotype, data = StatsPop)

summary(fit)

ggplot(StatsPop, aes(x=intage, y=CD4CT)) +
  geom_point() +
  stat_summary(fun.y=mean, geom="point", shape=18, size = 3, color = "red")+
  geom_smooth(method="glm")



#save predictions of the model in the new data frame together with variable you want to plot against
#lm2 = glm(formula=difference-individual*trial, data=data.plot2)

predicted_df <- data.frame(age=StatsPop$intage, cd4Predicted=predict(fit, StatsPop), genotype=StatsPop$Genotype)

#this is the predicted line of multiple linear regression
ggplot(data=StatsPop, aes(x=intage, y=CD4CT)) +
  geom_point(position = position_dodge(width = 0.8), aes(color = Genotype)) +
  #geom_line(color='blue', data=predicted_df, aes(x=individual, y=difference_pred))
  geom_point(size = 3, shape=1, data=predicted_df, aes(x=age, y=cd4Predicted, color=genotype))+
  stat_summary(fun.y=mean, geom="point", shape=18, size=3, color="red")




####Play with this after you have done some T tests
table(pop$intage)
#0 4 7 9 12 14 18 56

ageTtest = function(age, column){
  age = c(0,4,7,9,12,14,18,56)
  
  for i in age{
    wt = subset(pop, intage == age & Genotype == "WT", select = column)
    ko = subset(pop, intage == age & Genotype == "KO", select = column)
    trresult = t.test(wt, ko, alternative = "two.sided", var.equal = FALSE)
    
  }
  return(trresult$p.value)
}

pop
ageTtest(0)
ageTtest(4)
ageTtest(7)
ageTtest(9)
ageTtest(12)
ageTtest(14)
ageTtest(18)

WT9 = pop[which(pop$intage >= age & pop$Genotype == "WT"),]

#means of the pairwise differences, comparing to the assumption of the means being 0
t.test(meanspwdifference, mu=0)



wt = subset(pop, intage == 9 & Genotype == "WT", select = CD4CT)
ko = subset(pop, intage == 9 & Genotype == "KO", select = CD4CT)
trresult = t.test(wt, ko, alternative = "two.sided", var.equal = FALSE)
trresult$p.value
