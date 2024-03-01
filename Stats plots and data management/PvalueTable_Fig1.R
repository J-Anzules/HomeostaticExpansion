#####################################################################
# Started: Feb, 8, 2023
# Purpose: Create a table of p-values for the figure 1 data
# Author: Jonathan Anzules
# Email: jonanzule@gmail.com
# 
#####################################################################


#####
#----------------------------------------------------------------#
#------------------------ Preparing data ------------------------#
#----------------------------------------------------------------#


WTProl = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl.csv')
KOProl = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl.csv')
ActivatedWTSpleen = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen.csv')
ActivatedKOSpleen = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen.csv')

ShaWilks.test = read.csv("C:/Users/jonan/Documents/HomeostaticExpansion/Manuscript/Figures/P-value Table/Shapiro_Wilk_Test.csv")
# preparing T cell summary

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

#Preparing final dataframe
all_results_df <- data.frame(age=integer(),
                         comparison_type=character(),
                         p_value=numeric(),
                         test=character(),
                         hypothesis=character(),
                         stringsAsFactors=FALSE)


# Based on Shapiro_Wilk_Normal_columns.csv results
nor_dist_reference <- c(c(4, "X4TregRatio"), c(4, "ActivatedProlRatio"),
                        c(4, "NonProlActivatedRatio"), c(4, "ActivatedProlRatio"),
                        c(18, "X4TregRatio"))


#####
#-----------------------------------------------#
#         Testing normality Total cell counts
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


#####
#----------------------------------------------------------------#
#---------------------- Generating P-vales ----------------------#
#------------------------       From     ------------------------#
#------------------------      CD69 %    ------------------------#
#----------------------------------------------------------------#


ActT_columns <- c("pct_CD4_CD44_pos_CD62L_neg", "pct_CD4_CD69_pos") 

#Gathering unique ages
ages <- unique(ActT$Age)

# Initialize an empty dataframe to store results
ActT_results_df <- data.frame(column_of_interest=character(),
                         age=integer(),
                         p_value=numeric(),
                         test=character(),
                         hypothesis=character(),
                         n_values=character(),
                         stringsAsFactors=FALSE)

for (column_of_interest in ActT_columns) {
  
  # Loop through each age and testing
  for (age in ages) {
    # print(age)
    # Subset the data for the current age
    data_subset <- subset(ActT, Age == age)
    
    # Separate data into "wt" and "ko" groups
    wt_data <- data_subset[data_subset$Genotype == "WT", column_of_interest]
    ko_data <- data_subset[data_subset$Genotype == "KO", column_of_interest]
    
    # Decide which test to use based on the day
    test_to_use <- ifelse(age == 9, "t.test", "wilcox")
    
    # Conduct the chosen test
    if (test_to_use == "t.test") {
      test_result <- t.test(ko_data, wt_data, alternative="greater")
    } else {
      test_result <- wilcox.test(ko_data, wt_data, alternative="greater", exact = FALSE)
    }
    
    # Number of values for WT and KO groups
    n_values_wt <- length(wt_data)
    n_values_ko <- length(ko_data)
    
    # Check if p-value is < 0.05 and append the results to the dataframe
    if (test_result$p.value <= 0.05) {
      ActT_results_df <- rbind(ActT_results_df, data.frame(column_of_interest=column_of_interest,
                                                           age=age,
                                                           p_value=test_result$p.value,
                                                           test=test_to_use,
                                                           hypothesis="greater",
                                                           n_values=paste(n_values_wt, n_values_ko, sep=", ")))
    }
  }
}

print(ActT_results_df)

#####
#----------------------------------------------------------------#
#---------------------     T.test results  ----------------------#
#------------------------       All      ------------------------#
#----------------------------------------------------------------#

perform_custom_test <- function(dataset_type, columns_of_interest, default_comparison_type = "greater") {
  # Initialize an empty dataframe to store all results
  all_results_df <- data.frame(column_of_interest=character(),
                               age=integer(),
                               p_value=numeric(),
                               test=character(),
                               hypothesis=character(),
                               n_values=character(),
                               stringsAsFactors=FALSE)
  
  # Columns requiring 'less' comparison
  columns_less_comparison <- c("X4TregCT", "X4TregRatio")
  
  # Columns requiring a t-test
  data_ttest <- c("NonProlActivatedRatio", "ActivatedProlRatio", "X4TregRatio")
  
  # Iterate over each column of interest
  for (column_of_interest in columns_of_interest) {
    # Determine the comparison type based on the column
    comparison_type <- ifelse(column_of_interest %in% columns_less_comparison, "less", default_comparison_type)
    
    # Select appropriate datasets based on dataset_type
    if (dataset_type == "prol") {
      WT_data <- WTProl
      KO_data <- KOProl
    } else if (dataset_type == "activated spleen") {
      WT_data <- ActivatedWTSpleen
      KO_data <- ActivatedKOSpleen
    } else {
      stop("Invalid dataset type provided.")
    }
    
    # Get all unique ages from both datasets
    all_ages <- unique(c(WT_data$Age, KO_data$Age))
    
    # Loop through each age
    for (age in all_ages) {
      # Subset the data for the current age
      wt_age_data <- subset(WT_data, Age == age)[, column_of_interest, drop=FALSE]
      ko_age_data <- subset(KO_data, Age == age)[, column_of_interest, drop=FALSE]
      
      # Check if both subsets have data
      if (nrow(wt_age_data) > 0 & nrow(ko_age_data) > 0) {
        
        # Determine the test based on the day
        test_type <- ifelse(age == 9, "t.test", "wilcox")
        
        if (test_type == "t.test") {
          test_result <- t.test(ko_age_data[[1]], wt_age_data[[1]], alternative=comparison_type)
        } else {
          test_result <- wilcox.test(ko_age_data[[1]], wt_age_data[[1]], alternative=comparison_type, exact = FALSE)
        }
        
        # Number of values for WT and KO
        n_values_wt <- nrow(wt_age_data)
        n_values_ko <- nrow(ko_age_data)
        
        # Append to all_results_df if p-value <= 0.05
        if (test_result$p.value <= 0.05) {
          all_results_df <- rbind(all_results_df, data.frame(column_of_interest=column_of_interest,
                                                             age=age,
                                                             p_value=test_result$p.value,
                                                             test=test_type,
                                                             hypothesis=comparison_type,
                                                             n_values=paste(n_values_wt, n_values_ko, sep=", ")))
        }
      }
    }
  }
  
  return(all_results_df)
}

prol_columns <- c("NonProlActivatedRatio", "NonProlActivatedCT", "ActivatedProlRatio",
                  "ActivatedProlCT" )

actSpln_columns <-  c("EarlyActivatedCD4CT", "X4TregRatio", "X4TregCT", "ActivatedCD4CT" )

# # Example usage
# default_comparison_type <- "greater" # Default comparison type
# Perform analysis for 'prol' and 'activated spleen' dataset columns with the updated function
results_prol <- perform_custom_test("prol", prol_columns)

results_activated_spleen <- perform_custom_test("activated spleen", actSpln_columns)
# results_activated_spleen


all_results_df <- rbind(ActT_results_df, results_prol, results_activated_spleen)


file_path <- "C:/Users/jonan/Documents/HomeostaticExpansion/Manuscript/Figures/P-value Table/pvalueTable2.csv"
write.csv(all_results_df, file_path,row.names = FALSE)




######
#----------------------------------------------------------------#
#---------------------     T.test results  ----------------------#
#------------------------       one      ------------------------#
#----------------------------------------------------------------#



perform_t_test_for_column <- function(WT_dataset, KO_dataset, column_of_interest, comparison_type="greater") {
  # Initialize an empty dataframe to store results
  results_df <- data.frame(age=integer(),
                           comparison_type=character(),
                           p_value=numeric(),
                           stringsAsFactors=FALSE)
  
  # Get all unique ages from both datasets
  all_ages <- unique(c(WT_dataset$Age, KO_dataset$Age))
  
  # Loop through each age
  for (age in all_ages) {
    # Subset the data for the current age
    wt_age_data <- subset(WT_dataset, Age == age)[, column_of_interest, drop=FALSE]
    ko_age_data <- subset(KO_dataset, Age == age)[, column_of_interest, drop=FALSE]
    
    # Perform t-test if both subsets have data
    if (length(wt_age_data) > 0 & length(ko_age_data) > 0) {
      t_test_result <- t.test(ko_age_data[[1]], wt_age_data[[1]], alternative=comparison_type)
      
      # Append to results_df regardless of the p-value
      results_df <- rbind(results_df, data.frame(age=age,
                                                 comparison_type=comparison_type,
                                                 p_value=t_test_result$p.value))
    }
  }
  
  # Return the results dataframe
  return(results_df)
}

prol_columns <- c("NonProlActivatedRatio", "NonProlActivatedCT", "ActivatedProlRatio",
                  "ActivatedProlCT" )
actSpln_columns <-  c("EarlyActivatedCD4CT", "X4TregRatio", "X4TregCT", "ActivatedCD4CT",  )

# Example usage
column_of_interest <- "YourColumnNameHere"
comparison_type <- "greater" # or "less", depending on your hypothesis


perform_t_test_for_column(WTProl, KOProl, "ActivatedProlCT")






#####
#-----------------------------------------------------------------------#
#                               Older
#-----------------------------------------------------------------------#





#####
















