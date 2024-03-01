################################################################################
# Script for Data Preparation and Analysis of Total Cell Counts
# Author: Jonathan Anzules
# Date of Creation: [02/25/24]
#
# This script takes the experimental data and does two main things with the total
# Cell Counts data from all experiments
# 1. Visualizing the combined data using ggplot2 to create scatter plots by genotype.
# 2. Generating a comprehensive table of Shapiro-Wilk test results across all ages
#    and genotypes, which is then saved as a CSV file.
#
# Dependencies: ggplot2, plyr (implicitly for certain operations)
# Output: Scatter plot in R's graphical device, Shapiro-Wilk test results table saved as CSV.
################################################################################


#####
#-----------------------------------------------#
#                 Preparing Data:
#                Total cell counts
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

#-----------------------------------------------#
#         Shapiro-Wilk Table generation
#-----------------------------------------------#

# First, we'll create an empty data frame to store the results
results <- data.frame(Age = integer(), 
                      P_Value = numeric(), 
                      Genotype = character(), 
                      stringsAsFactors = FALSE)

# Loop through each genotype
for(genotype in unique(combinedDataset$Genotype)) {
  
  # Filter the dataset for the current genotype
  genotypeData <- combinedDataset[combinedDataset$Genotype == genotype, ]
  
  # Loop through each unique age within the genotype
  for(age in unique(genotypeData$Age)) {
    
    # Filter the dataset for the current age
    ageData <- genotypeData[genotypeData$Age == age, ]
    
    # Perform the Shapiro-Wilk test
    shapiro_test <- shapiro.test(ageData$TotalLiveCountInMillions)
    
    # Append the results to the results dataframe
    results <- rbind(results, data.frame(Age = age, 
                                         P_Value = shapiro_test$p.value, 
                                         Genotype = genotype))
  }
}

# View the results
print(results)
write.csv(results, "C:/Users/jonan/Documents/HomeostaticExpansion/Manuscript/Figures/P-value Table/Shapiro_Wilk_Test.csv")


#####
#-----------------------------------------------#
#                 Preparing Data:
#                Columns of interest:
#"X4TregRatio", "ActivatedProlRatio", "NonProlActivatedRatio",
#               "ActivatedProlRatio"
#Purpose: Total cell counts are not normal, but what about percent spread?
#         I am performing a wilcox test on total cell counts that pass this test (p-value <= 0.05)
#         T.test on those that don't pass (p-value > 0.05)         
#-----------------------------------------------#


library(plyr)

WTData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen.csv")
ProlWTData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl.csv")
KOData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen.csv")
ProlKOData = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl.csv")


# Combine the datasets
combinedDataset <- rbind.fill(WTData, ProlWTData, KOData, ProlKOData)

# Columns of interest for normality testing
columns_to_test <- c("X4TregRatio", "ActivatedProlRatio", "NonProlActivatedRatio", "ActivatedProlRatio")


#####

#------------------------------------------------------------------------------#
#         Shapiro-Wilk Table generation for general dataset
#------------------------------------------------------------------------------#

# Assuming combinedDataset is already loaded and contains the necessary data



# Initialize an empty data frame to store the results
normality_test_pass <- data.frame(Age = integer(),
                                Genotype = character(),
                                Column = character(),
                                P_Value = numeric(),
                                W_Statistic = numeric(),
                                stringsAsFactors = FALSE)

normality_test_fail <- data.frame(Age = integer(),
                                  Genotype = character(),
                                  Column = character(),
                                  P_Value = numeric(),
                                  W_Statistic = numeric(),
                                  stringsAsFactors = FALSE)

# Loop through each column of interest
for (column in columns_to_test) {
  # Loop through each unique age
  for (age in unique(combinedDataset$Age)) {
    # Loop through each genotype
    for (genotype in unique(combinedDataset$Genotype)) {
      # Subset data for the current age and genotype
      subset_data <- combinedDataset[combinedDataset$Age == age & combinedDataset$Genotype == genotype, ]
      
      # Perform the Shapiro-Wilk test on the current subset for the column
      shapiro_test <- tryCatch({
        shapiro.test(subset_data[[column]])
      }, error = function(e) {
        return(list(p.value = NA, statistic = NA)) # Return NA values in case of an error (e.g., too few observations)
      })
      
      if (shapiro_test$p.value <= 0.05) {
        # Append the results to the normality_results dataframe
        normality_test_pass <- rbind(normality_test_pass, data.frame(Age = age,
                                                                 Genotype = genotype,
                                                                 Column = column,
                                                                 P_Value = shapiro_test$p.value,
                                                                 W_Statistic = shapiro_test$statistic,
                                                                 stringsAsFactors = FALSE))
        
      } else {
        normality_test_fail <- rbind(normality_test_fail, data.frame(Age = age,
                                                                   Genotype = genotype,
                                                                   Column = column,
                                                                   P_Value = shapiro_test$p.value,
                                                                   W_Statistic = shapiro_test$statistic,
                                                                   stringsAsFactors = FALSE))
      }
      
      
    
    }
  }
}

# View the results
print(normality_test_pass)
print(normality_test_fail)

shapiro_test$p.value
# Optionally, save the results to a CSV file
write.csv(normality_test_fail, "C:/Users/jonan/Documents/HomeostaticExpansion/Manuscript/Figures/P-value Table/Shapiro_Wilk_Normal_columns.csv", row.names = FALSE)


# nor_dist_reference <- c(c(4, "X4TregRatio"), c(4, "ActivatedProlRatio"),
#                         c(4, "NonProlActivatedRatio"), c(4, "ActivatedProlRatio"),
#                         c(18, "X4TregRatio"))
#####
#------------------------------------------------------------------------------#
#         Shapiro-Wilk Table generation for cd69 data
#------------------------------------------------------------------------------#

ActT = read.csv('C:/Laptop Backups/HomestaticExpansionProject/ModelData/TCellActivationSummary_filled.csv')

ActT$Genotype[ActT$Genotype == "IL-2-KO"] = "KO"
ActT$Genotype[ActT$Genotype == "IL-2-HET"] = "WT"
ActT$Genotype[ActT$Genotype == "CD25-KO"] = "KO"

ActT[ActT$Genotype != "",]
ActT = ActT[!(ActT$Genotype == ""),]
ActT$Age <- ifelse(ActT$Age >= 18, 18, ActT$Age)
ActT = subset(ActT, Age <= 18 & Age > 0)


#Removing age 16
ActT = ActT[ActT$Age != 16, ]
#Removing age 7
ActT = ActT[ActT$Age != 7, ]

ActT_columns <- c("pct_CD4_CD44_pos_CD62L_neg", "pct_CD4_CD69_pos") 


# Initialize an empty data frame to store the results
normalityActT_test_pass <- data.frame(Age = integer(),
                                  Genotype = character(),
                                  Column = character(),
                                  P_Value = numeric(),
                                  W_Statistic = numeric(),
                                  stringsAsFactors = FALSE)

normalityActT_test_fail <- data.frame(Age = integer(),
                                  Genotype = character(),
                                  Column = character(),
                                  P_Value = numeric(),
                                  W_Statistic = numeric(),
                                  stringsAsFactors = FALSE)

# Loop through each column of interest
for (column in ActT_columns) {
  # Loop through each unique age
  for (age in unique(ActT$Age)) {
    # Loop through each genotype
    for (genotype in unique(ActT$Genotype)) {
      # Subset data for the current age and genotype
      subset_data <- ActT[ActT$Age == age & ActT$Genotype == genotype, ]
      
      # Perform the Shapiro-Wilk test on the current subset for the column
      shapiro_test <- tryCatch({
        shapiro.test(subset_data[[column]])
      }, error = function(e) {
        return(list(p.value = NA, statistic = NA)) # Return NA values in case of an error (e.g., too few observations)
      })
      
      if (!is.na(shapiro_test$p.value) && shapiro_test$p.value <= 0.05) {
        # Append the results to the normalityActT_test_pass dataframe
        normalityActT_test_pass <- rbind(normalityActT_test_pass, data.frame(Age = age,
                                                                             Genotype = genotype,
                                                                             Column = column,
                                                                             P_Value = shapiro_test$p.value,
                                                                             W_Statistic = shapiro_test$statistic,
                                                                             stringsAsFactors = FALSE))
      } else if (!is.na(shapiro_test$p.value)) {
        # Append the results to the normalityActT_test_fail dataframe only if p.value is not NA
        normalityActT_test_fail <- rbind(normalityActT_test_fail, data.frame(Age = age,
                                                                             Genotype = genotype,
                                                                             Column = column,
                                                                             P_Value = shapiro_test$p.value,
                                                                             W_Statistic = shapiro_test$statistic,
                                                                             stringsAsFactors = FALSE))
      }
      
      
      
    }
  }
}


# View the results
print(normalityActT_test_pass)
print(normalityActT_test_fail)
write.csv(normalityActT_test_fail, 
          "C:/Users/jonan/Documents/HomeostaticExpansion/Manuscript/Figures/P-value Table/Shapiro_Wilk_ActT_Normal_columns.csv", row.names = FALSE)

nor_dist_reference <- c(c(4, "X4TregRatio"), c(4, "ActivatedProlRatio"),
                        c(4, "NonProlActivatedRatio"), c(4, "ActivatedProlRatio"),
                        c(4, "pct_CD4_CD44_pos_CD62L_neg"), c(4, "pct_CD4_CD69_pos"),
                        c(12, "pct_CD4_CD44_pos_CD62L_neg"), 
                        c(14, "pct_CD4_CD44_pos_CD62L_neg"), c(13, "pct_CD4_CD69_pos"),
                        c(18, "X4TregRatio"), c(18, "pct_CD4_CD69_pos"))







