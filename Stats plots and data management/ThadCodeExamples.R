install.packages("tidyverse")
library(tidyverse)
library(ggplot2)

source('~/my.work/PhD/Data/Work with Thad/Code/popCount_V2.R')
StatsPop = pop[which(pop$intage >= 9 & pop$intage < 30),]
# StatsPop = pop
fit <- glm(formula = StatsPop$CD4Ratio ~ intage * Genotype, data = StatsPop)

summary(fit)

ggplot(StatsPop, aes(x=intage, y=CD4Ratio)) +
  geom_point() +
  stat_summary(fun.y=mean, geom="point", shape=18, size = 3, color = "red")+
  geom_smooth(method="glm")



#save predictions of the model in the new data frame together with variable you want to plot against
#lm2 = glm(formula=difference-individual*trial, data=data.plot2)

predicted_df <- data.frame(age=StatsPop$intage, cd4Predicted=predict(fit, StatsPop), genotype=StatsPop$Genotype)

#this is the predicted line of multiple linear regression
ggplot(data=StatsPop, aes(x=intage, y=CD4Ratio)) +
  geom_point(position = position_dodge(width = 0.8), aes(color = Genotype)) +
  #geom_line(color='blue', data=predicted_df, aes(x=individual, y=difference_pred))
  geom_point(size = 3, shape=1, data=predicted_df, aes(x=age, y=cd4Predicted, color=genotype))+
  stat_summary(fun.y=mean, geom="point", shape=18, size=3, color="red")




####Play with this after you have done some T tests
### Age ## P value



#means of the pairwise differences, comparing to the assumption of the means being 0
t.test(meanspwdifference, mu=0)


