library(pracma)

#####
# Data

ModeldataWT = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Stats plots and data management/ModelOutputWT2.csv")
ModeldataKO = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Stats plots and data management/ModelOutputKO2.csv")

colnames(ModeldataWT) = c("NaiveCT", "ActTCT", "TregCT", "ThyNaive", "ActTNaive", "ThyTregs",
                          "TregNaive", "ProlNaive", "ProlActT", "ProlTreg", "IL-2", "ThymWeigth")
colnames(ModeldataKO) = c("NaiveCT", "ActTCT", "TregCT", "ThyNaive", "ActTNaive", "ThyTregs",
                          "TregNaive", "ProlNaive", "ProlActT", "ProlTreg", "IL-2", "ThymWeigth")

ModeldataWT$time = 0:431
ModeldataKO$time = 0:431
ModeldataWT$time = ModeldataWT$time / 24
ModeldataKO$time = ModeldataKO$time / 24


#####
#-----------------------------------------------#
#                   AUC - Total Tregs
#-----------------------------------------------#

auc_wt <- trapz(ModeldataWT$time, ModeldataWT$TregCT)
auc_ko <- trapz(ModeldataKO$time, ModeldataKO$TregCT)

#
test_result <- wilcox.test(ModeldataWT$TregNaive, ModeldataKO$TregNaive)

# Output the AUC values and test results
list(AUC_WT = auc_wt, AUC_KO = auc_ko, Test_Result = test_result)

auc_wt - auc_ko

#####
#-----------------------------------------------#
#                   AUC - Naive Tregs
#-----------------------------------------------#

auc_wt <- trapz(ModeldataWT$time, ModeldataWT$TregNaive)
auc_ko <- trapz(ModeldataKO$time, ModeldataKO$TregNaive)

#
test_result <- wilcox.test(ModeldataWT$TregNaive, ModeldataKO$TregNaive)

# Output the AUC values and test results
list(AUC_WT = auc_wt, AUC_KO = auc_ko, Test_Result = test_result)

#


#####
#-----------------------------------------------#
#             Looking at percentage
#-----------------------------------------------#
ModeldataWT$pct_Treg =  ModeldataWT$TregCT / (ModeldataWT$NaiveCT + ModeldataWT$ActTCT + ModeldataWT$TregCT)

plot(ModeldataWT$time, ModeldataWT$pct_Treg)



#####
#-----------------------------------------------#
#         Looking at Total cell counts
#-----------------------------------------------#

library(ggplot2)

WTData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen.csv")
ProlWTData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl.csv")
KOData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen.csv")
ProlKOData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl.csv")

# Subset only the columns of interest from each dataset
WTData_sub <- WTData[, c("Age", "TotalLiveCountInMillions")]
ProlWTData_sub <- ProlWTData[, c("Age", "TotalLiveCountInMillions")]
KOData_sub <- KOData[, c("Age", "TotalLiveCountInMillions")]
ProlKOData_sub <- ProlKOData[, c("Age", "TotalLiveCountInMillions")]

# Combine the datasets by genotype
WTdataset <- rbind(WTData_sub, ProlWTData_sub)
KODataset <- rbind(KOData_sub, ProlKOData_sub)

# Adding the genoptype to the datasets
WTdataset$Genotype <- 'WT'
KODataset$Genotype <- 'KO'

# Combine the datasets into one
combinedDataset <- rbind(WTdataset, KODataset)

# Create the ggplot
ggplot(combinedDataset, aes(x = Age, y = TotalLiveCountInMillions, color = Genotype)) +
  geom_point() + # Add points
  labs(x = "Age", y = "Total Live Count In Millions", title = "Total Live Count by Age and Genotype") +
  theme_minimal() + # Use a minimal theme
  scale_color_manual(values = c("WT" = "blue", "KO" = "red")) # Custom colors for genotypes


#-----------------------------------------------#
#         Testing for normality
#-----------------------------------------------#

# Filter the dataset for WT genotype and day 18
KO_day18 <- combinedDataset[combinedDataset$Genotype == 'KO' & combinedDataset$Age == 18, ]

# Perform the Shapiro-Wilk test for normality on the TotalLiveCountInMillions column
shapiro_test <- shapiro.test(KO_day18$TotalLiveCountInMillions)

# Print the result
print(shapiro_test)























