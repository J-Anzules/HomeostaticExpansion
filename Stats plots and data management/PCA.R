################################################################################
# Script for Data Preparation and Analysis of Total Cell Counts
# Author: Jonathan Anzules
# Date of Creation: [03/01/24]
#

#
# Dependencies:
# Output:
################################################################################

library(plyr)
library(dplyr)
library(ggplot2)
library(stats)

#####
#-----------------------------------------------#
#         Combining Datasets
#-----------------------------------------------#

WTData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen.csv")
ProlWTData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl.csv")
KOData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen.csv")
ProlKOData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl.csv")


# Combine the datasets
combinedDataset <- rbind.fill(WTData, ProlWTData, KOData, ProlKOData)

# Removing columns with NA
combinedDataset <- combinedDataset %>%
  select(-X8TregProlRatio, -X8TregProlCT, -NaiveProlRatio)

# Selecting columns of interest
prol_columns <- c("NonProlActivatedRatio", "NonProlActivatedCT", "ActivatedProlRatio",
                  "ActivatedProlCT" )

actSpln_columns <-  c("EarlyActivatedCD4CT", "X4TregRatio", "X4TregCT", "ActivatedCD4CT" )

col_of_interest <- rbind(prol_columns, actSpln_columns)


#####
#-----------------------------------------------#
#         PCA
#-----------------------------------------------#
# Get indices of "Age" and "Genotype" columns
ageIndex <- which(names(combinedDataset) == "Age")
genotypeIndex <- which(names(combinedDataset) == "Genotype")

# Combine numeric range with specific column indices
columnsToKeep <- c(21:ncol(combinedDataset), ageIndex, genotypeIndex)

# Subset the data
dataForPCA <- combinedDataset[, columnsToKeep]

# Perform PCA excluding the last two columns (Age and Genotype)
pcaResults <- prcomp(dataForPCA[, 1:(ncol(dataForPCA)-2)], center = TRUE, scale. = TRUE)

# Extract PCA scores
pcaData <- data.frame(pcaResults$x)

# Add back Age and Genotype for labeling
pcaData$Age <- combinedDataset$Age
pcaData$Genotype <- combinedDataset$Genotype

# Plot with circles labeled by Age
ggplot(pcaData, aes(x = PC1, y = PC2)) +
  geom_point() +
  geom_text(aes(label = Age), hjust = 1.5, vjust = 1.5, check_overlap = TRUE) +
  theme_minimal() +
  labs(title = "PCA Plot Labeled by Age",
       x = "Principal Component 1",
       y = "Principal Component 2")

# Plot with circles colored based on Genotype
ggplot(pcaData, aes(x = PC1, y = PC2, color = Genotype)) +
  geom_point() +
  theme_minimal() +
  scale_color_manual(values = c("WT" = "blue", "KO" = "red")) +
  labs(title = "PCA Plot Colored by Genotype",
       x = "Principal Component 1",
       y = "Principal Component 2")


