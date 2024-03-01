#####
#-----------------------------------------------#
#         Looking at Individual columns
#-----------------------------------------------#

library(plyr)

WTData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen.csv")
ProlWTData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl.csv")
KOData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen.csv")
ProlKOData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl.csv")


# Combine the datasets
combinedDataset <- rbind.fill(WTData, ProlWTData, KOData, ProlKOData)


cd69_data <- c("pct_CD4_CD44_pos_CD62L_neg", "pct_CD4_CD44_pos_CD62L_neg")

columns_to_test <- c("X4TregRatio", "ActivatedProlRatio", "NonProlActivatedRatio",
                     "ActivatedProlRatio")