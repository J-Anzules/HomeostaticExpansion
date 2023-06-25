pop = read.csv("C:/Laptop Backups/HomestaticExpansionProject/ModelData/AfterCalculations.csv")
popthym = subset(pop, Organ == "Thymus")
#lm(formula = response ~ explanatory)

summary(lm(formula = OrganWeight ~ Age + Genotype, data = popthym))

#Thymus weight
summary(lm(formula = OrganWeight ~ Age + Genotype, data = popthym))

#cd8 thym
summary(lm(formula = pop$CD8ct ~ Age + Genotype, data = popthym))

#Ancova cnnot be pursued, because there are variable length differences in the data
