#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
# Before continuing                                                                                            #
# Don't forget to run the python script that calculates activated T cell data                                  #
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

##############################
#                            #
# Prepping data for Modeling #
#                            #
##############################
# This was made for only CD69 data
# ActivationData = read.csv("~/my.work/PhD/HomestaticExpansionProject/ModelData/ActivatedCD4pop.csv")

#Made from the CD44 data
ActivationData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/ModelData/ActivatedCD4pop2.csv")

#Creating the naive T cells
ActivationData$NaiveCT = ActivationData$NoTregCD4CT - ActivationData$ActivatedCD4CT

#Deprecated, but keeping here just in case something comes up because I made this mistake
#ActivationData$AllTregs = ActivationData$NaiveDerivedTregsCT + ActivationData$X4TregFromThymusCT

# #Saving the data to Modeldata for plotting
# write.csv(ActivationData, "~/my.work/PhD/HomestaticExpansionProject/ModelData/ActivatedCD4pop.csv")

#Preparing data for fitting
ActivationData$NaiveDerivedTregsCT = ActivationData$NaiveDerivedTregsCT * 10**6
ActivationData$ThymicDerivedTregsCT = ActivationData$ThymicDerivedTregsCT * 10**6
ActivationData$NaiveCT = ActivationData$NaiveCT * 10**6
ActivationData$ActivatedCD4CT = ActivationData$ActivatedCD4CT * 10**6
ActivationData$X4TregCT = ActivationData$X4TregCT * 10**6
ActivationData$hours = ActivationData$intage * 24
ActivationData$hours[ActivationData$hours == 0] <- 1 #the 0 won't work with my matlab code
ActivationData$X4TregProlCT[ActivationData$X4TregProlCT == 0] <- 1 #Have to get rid of that divide by zero nonsense
ActivationData$NaiveDerivedTregsCT[ActivationData$NaiveDerivedTregsCT == 0] <- 1 #Have to get rid of that divide by zero nonsense
ActivationData$X4TregProlCT = ActivationData$X4TregProlCT * 10**6
ActivationData$CD4ProlCT =  ActivationData$CD4ProlCT * 10**6

#########################################################
#Estimating the Activated T Cells that are proliferating
#########################################################
library(dplyr)
library("Rmisc")

ActivationDataSpleen = subset(ActivationData, Organ == "Spleen")#Removing Thymus for the fitting process
Rowtoadd = subset(ActivationDataSpleen, FileID == "JA042618D7WTS_1") #Need to have even numbers for the grouping to work
ActivationDataSpleen = rbind(ActivationDataSpleen, Rowtoadd) #Adding row

#KO has more proliferation, we are assuming that the extra proliferation ratio is the activated T cells proliferating
ActivationDataSpleen = ActivationDataSpleen %>%
  group_by(CageNumber, Age ) %>% 
  mutate(ActivatedProlRatio = CD4ProlRatio - CD4ProlRatio[Genotype == 'WT'])

ActivationDataSpleen$ActivatedProlRatio[ActivationDataSpleen$ActivatedProlRatio < 0] <- 0 
ActivationDataSpleen$NonProlActivatedRatio = 1 - ActivationDataSpleen$ActivatedProlRatio 

ActivatedWTSpleen = subset(ActivationDataSpleen, Genotype == 'WT')
ActivatedKOSpleen = subset(ActivationDataSpleen, Genotype == 'KO')

#Setting up the Naive Counts in both WT and KO
ActivatedKOSpleen$NaiveProlRatio = ActivatedKOSpleen$CD4ProlRatio - ActivatedKOSpleen$ActivatedProlRatio

ActivatedKOSpleen$NaiveProlCT = ActivatedKOSpleen$NaiveCT * ActivatedKOSpleen$NaiveProlRatio
ActivatedWTSpleen$NaiveProlCT = ActivatedWTSpleen$NaiveCT * ActivatedWTSpleen$CD4ProlRatio

ActivatedKOSpleen$ThymicNaive = ActivatedKOSpleen$NaiveCT - ActivatedKOSpleen$NaiveProlCT
ActivatedWTSpleen$ThymicNaive = ActivatedWTSpleen$NaiveCT - ActivatedWTSpleen$NaiveProlCT

#Setting up Activated Proliferating Counts
#ActivatedWTSpleen$ActivatedProlRatio[ActivatedWTSpleen$ActivatedProlRatio > 0] <- 0 #Assuming no activation proliferation in the WT data

ActivatedKOSpleen$ActivatedProlCT = ActivatedKOSpleen$ActivatedProlRatio * ActivatedKOSpleen$ActivatedCD4CT
ActivatedWTSpleen$ActivatedProlCT = ActivatedWTSpleen$CD4ProlRatio * ActivatedWTSpleen$ActivatedCD4CT

ActivatedKOSpleen$NonProlActivatedCT = ActivatedKOSpleen$NonProlActivatedRatio * ActivatedKOSpleen$ActivatedCD4CT
ActivatedWTSpleen$NonProlActivatedCT = ActivatedWTSpleen$NonProlActivatedRatio * ActivatedWTSpleen$ActivatedCD4CT

ActivatedWTSpleen$ActivatedProlCT[ActivatedWTSpleen$ActivatedProlCT == 0 ] <- 1 #To avaid that divide by zero nonsense
ActivatedKOSpleen$ActivatedProlCT[ActivatedKOSpleen$ActivatedProlCT == 0 ] <- 1 #To avaid that divide by zero nonsense

#Setting up Naive derived Activated T cells in the KO
ActivatedKOSpleen$ActivatedNaiveCT = ActivatedKOSpleen$ActivatedCD4CT - ActivatedKOSpleen$ActivatedProlCT
ActivatedWTSpleen$ActivatedNaiveCT = ActivatedWTSpleen$ActivatedCD4CT

#Removing the datasets that have zero proliferation because we didn't use KI-67
WTProl <- subset(ActivatedWTSpleen, CD4ProlRatio != 0 )
KOProl <- subset(ActivatedKOSpleen, CD4ProlRatio != 0 )

#Selecting the columns that matter

MyColumns = c("FileID", "Organ", "Age", "Genotype", "intage", "NaiveCT", 
              "ActivatedCD4CT", "X4TregCT","ThymicDerivedTregsCT", 
              "X4TregProlCT", "NaiveDerivedTregsCT", "hours",
              "ActivatedProlCT", "NaiveProlCT", "ThymicNaive", 
              "ActivatedNaiveCT", "X4TregRatio", "NonProlActivatedRatio",
              "NonProlActivatedCT", "ActivatedNonProlCT", "EarlyActivatedCD4CT")

WTProl = WTProl[MyColumns]
KOProl = KOProl[MyColumns]
ActivatedWTSpleen = ActivatedWTSpleen[MyColumns]
ActivatedKOSpleen = ActivatedKOSpleen[MyColumns]


KOProl$NaiveProlCT[KOProl$NaiveProlCT == 0] = 1
KOProl$ActivatedProlCT[KOProl$ActivatedProlCT == 1] = 1
#SavingData for modeling
write.csv(WTProl, '~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl.csv')
write.csv(KOProl, '~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl.csv')
write.csv(ActivatedWTSpleen, '~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen.csv')
write.csv(ActivatedKOSpleen, '~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen.csv')


