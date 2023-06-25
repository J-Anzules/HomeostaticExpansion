WTData = read.csv("~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen.csv")
ProlWTData = read.csv("~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl.csv")
KOData = read.csv("~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen.csv")
ProlKOData = read.csv("~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl.csv")
pop = read.csv("/home/jon/my.work/PhD/HomestaticExpansionProject/ModelData/AfterCalculations.csv")

WTData$hours



# Mu - Thymic naive
ThymicNaive = summary(lm(data=WTData, ThymicNaive~hours))$coefficients[2]

# z - Self replication
NaiveProlCT = summary(lm(data=ProlWTData, NaiveProlCT~hours))$coefficients[2]

# alpha - Thymic naive
ThymicDerivedTregsCT = summary(lm(data=WTData, ThymicDerivedTregsCT~hours))$coefficients[2]

# c - Naive Dervied Tregs
NaiveDerivedTregsCT = summary(lm(data=WTData, NaiveDerivedTregsCT~hours))$coefficients[2]

# epsilon - self replicating Tregs
X4TregProlCT = summary(lm(data=ProlWTData, X4TregProlCT~hours))$coefficients[2]

# beta - activation rate of naive t cells
ActivatedNaiveCT = summary(lm(data=WTData, ActivatedNaiveCT~hours))$coefficients[2]

# a - self replication rate of activated T cells
ActivatedProlCT = summary(lm(data=ProlWTData, ActivatedProlCT~hours))$coefficients[2]

parameters = c("\\mu$", "$z$", "$\\alpha$", "$c$", "$\\epsilon$", "$\\beta$", 
               "$a$")
rates = c(ThymicNaive, NaiveProlCT, ThymicDerivedTregsCT, NaiveDerivedTregsCT,X4TregProlCT,
          ActivatedNaiveCT, ActivatedProlCT)

Rates.data = data.frame(parameters, rates)

write.csv(Rates.data, "~/my.work/PhD/HomestaticExpansionProject/ModelData/LinearRegressionRates.csv")

# # rK - Carrying capacity for Tregs
# popday56 = subset(pop, intage > 40)
# Tregs_rK = mean(popday56$X4TregCT) * 10**6

#-----------------------------------------------------------------------------------------------------------#
#                                               IL-2 KO
#-----------------------------------------------------------------------------------------------------------#

# Mu - Thymic naive
ThymicNaive = summary(lm(data=KOData, ThymicNaive~hours))$coefficients[2]

# z - Self replication
NaiveProlCT = summary(lm(data=ProlKOData, NaiveProlCT~hours))$coefficients[2]

# alpha - Thymic naive
ThymicDerivedTregsCT = summary(lm(data=KOData, ThymicDerivedTregsCT~hours))$coefficients[2]

# c - Naive Dervied Tregs
NaiveDerivedTregsCT = summary(lm(data=KOData, NaiveDerivedTregsCT~hours))$coefficients[2]

# epsilon - self replicating Tregs
X4TregProlCT = summary(lm(data=ProlKOData, X4TregProlCT~hours))$coefficients[2]

# beta - activation rate of naive t cells
ActivatedNaiveCT = summary(lm(data=KOData, ActivatedNaiveCT~hours))$coefficients[2]

# a - self replication rate of activated T cells
ActivatedProlCT = summary(lm(data=ProlKOData, ActivatedProlCT~hours))$coefficients[2]

parameters = c("\\mu$", "$z$", "$\\alpha$", "$c$", "$\\epsilon$", "$\\beta$", 
               "$a$")
rates = c(ThymicNaive, NaiveProlCT, ThymicDerivedTregsCT, NaiveDerivedTregsCT,X4TregProlCT,
          ActivatedNaiveCT, ActivatedProlCT)

Rates.dataKO = data.frame(parameters, rates)

write.csv(Rates.dataKO, "~/my.work/PhD/HomestaticExpansionProject/ModelData/LinearRegressionRatesKO.csv")
