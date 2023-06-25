#Setting things up
source("~/my.work/PhD/Homestatic Expansion Project/Code/Rscripts/popCount_V2.R")
#For Data extraction
library(dplyr)

#Extracting Columns of interest
kat = pop[,c("FileID", "Organ","Age", "Genotype", "TotalLiveCountInMillions",
             "CD4Ratio","CD4CT", "CD4ProlRatio", 
             "CD8Ratio",  "CD8ct", "CD8ProlRatio",
             "X4TregRatio", "X4TregProlRatio")]

#Sorting the data
kat = kat[with(kat, order(Organ, Age)),]
#Spliting files by WT and KO
katWT = subset(kat, Genotype == "WT")
katKO = subset(kat, Genotype == "KO")
#Transposing the data for graphpad
katWT = t(katWT)
katKO = t(katKO)

#Exporting the file
write.csv(katWT, file = "~/my.work/PhD/Homestatic Expansion Project/ModelData/WT_CD4CD8DataForGraphPad.csv")
write.csv(katKO, file = "~/my.work/PhD/Homestatic Expansion Project/ModelData/KO_CD4CD8DataForGraphPad.csv")