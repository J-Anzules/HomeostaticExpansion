#####################################################################
# Started: Feb, 8, 2023
# Purpose: Create a table of p-values for the figure 1 data
# Script for generating fig 1: Figure1_V4_018nodata.R
# Author: Jonathan Anzules
# Email: jonanzule@gmail.com
# 
#####################################################################


#####
#----------------------------------------------------------------#
#------------------------ Preparing data ------------------------#
#------------------------       and      ------------------------#
#------------------------    Function    ------------------------#
#----------------------------------------------------------------#


WTProl = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl.csv')
KOProl = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl.csv')
ActivatedWTSpleen = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen.csv')
ActivatedKOSpleen = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen.csv')

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
    
    # Perform t-test (assuming independent samples)
    # Note: Set alternative="greater" as hypothesis is "ko" data is greater than "wt" data
    t_test_result <- t.test(ko_data, wt_data, alternative="greater")
    # t_test_result <- wilcox.test(ko_data, wt_data, alternative="greater")
    
    # Check if p-value is < 0.05 and append the results to the dataframe
    if (t_test_result$p.value <= 0.05) {
      ActT_results_df <- rbind(ActT_results_df, data.frame(column_of_interest=column_of_interest,
                                                 age=age,
                                                 p_value=t_test_result$p.value,
                                                 test="t.test",
                                                 hypothesis="greater"))
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
                               comparison_type=character(),
                               p_value=numeric(),
                               test=character(),
                               hypothesis=character(),
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
        # Determine the test based on the column
        if (column_of_interest %in% data_ttest) {
          test_result <- t.test(ko_age_data[[1]], wt_age_data[[1]], alternative=comparison_type)
          test_type = "t.test"
          
        } else {
          test_result <- wilcox.test(ko_age_data[[1]], wt_age_data[[1]], alternative=comparison_type)
          test_type = "wilcox.test"
        }
        
        # Append to all_results_df if p-value <= 0.05
        if (test_result$p.value <= 0.05) {
          all_results_df <- rbind(all_results_df, data.frame(column_of_interest=column_of_interest,
                                                             age=age,
                                                             p_value=test_result$p.value,
                                                             test=test_type,
                                                             hypothesis=comparison_type))
        }
      }
    }
  }
  
  return(all_results_df)
}

data_ttest <- c("NonProlActivatedRatio", "ActivatedProlRatio", "X4TregRatio")

prol_columns <- c("NonProlActivatedRatio", "NonProlActivatedCT", "ActivatedProlRatio",
                  "ActivatedProlCT" )

actSpln_columns <-  c("EarlyActivatedCD4CT", "X4TregRatio", "X4TregCT", "ActivatedCD4CT" )

# # Example usage
# default_comparison_type <- "greater" # Default comparison type
# Perform analysis for 'prol' and 'activated spleen' dataset columns with the updated function
results_prol <- perform_custom_test("prol", prol_columns)
results_prol

results_activated_spleen <- perform_custom_test("activated spleen", actSpln_columns)
results_activated_spleen


all_results_df <- rbind(ActT_results_df, results_prol, results_activated_spleen)


file_path <- "C:/Users/jonan/Documents/HomeostaticExpansion/Manuscript/Figures/P-value Table/pvalueTable.csv"
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


perform_t_test_for_column()







#-----------------------------------------------------------------------#
#                               Older
#-----------------------------------------------------------------------#














perform_t_test_multiple_columns <- function(dataset_type, columns_of_interest, default_comparison_type = "greater") {
  # Initialize an empty dataframe to store all results
  all_results_df <- data.frame(column_of_interest=character(),
                               age=integer(),
                               comparison_type=character(),
                               p_value=numeric(),
                               stringsAsFactors=FALSE)
  
  # Columns requiring 'less' comparison
  columns_less_comparison <- c("X4TregCT", "X4TregRatio")
  
  # Iterate over each column of interest
  for (column_of_interest in columns_of_interest) {
    # Determine the comparison type based on the column
    comparison_type <- ifelse(column_of_interest %in% columns_less_comparison, "less", default_comparison_type)
    print(column_of_interest)
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
      print(age)
      # print(dim(WT_data))
      # Subset the data for the current age
      wt_age_data <- subset(WT_data, Age == age)[, column_of_interest, drop=FALSE]
      ko_age_data <- subset(KO_data, Age == age)[, column_of_interest, drop=FALSE]
      
      # Perform t-test if both subsets have data
      if (nrow(wt_age_data) > 0 & nrow(ko_age_data) > 0) {
        # t_test_result <- t.test(ko_age_data[[1]], wt_age_data[[1]], alternative=comparison_type)
        t_test_result <- wilcox.test(ko_age_data[[1]], wt_age_data[[1]], alternative=comparison_type)
        # Append to all_results_df if p-value <= 0.05
        if (t_test_result$p.value <= 0.05) {
          all_results_df <- rbind(all_results_df, data.frame(column_of_interest=column_of_interest,
                                                             age=age,
                                                             comparison_type=comparison_type,
                                                             p_value=t_test_result$p.value))
        }
      }
    }
  }
  
  # Return the aggregated results dataframe
  return(all_results_df)
}

data_ttest <- c("NonProlActivatedRatio", "ActivatedProlRatio", "X4TregRatio")

prol_columns <- c("NonProlActivatedRatio", "NonProlActivatedCT", "ActivatedProlRatio",
                  "ActivatedProlCT" )

actSpln_columns <-  c("EarlyActivatedCD4CT", "X4TregRatio", "X4TregCT", "ActivatedCD4CT" )

# # Example usage
# default_comparison_type <- "greater" # Default comparison type
# Perform analysis for 'prol' and 'activated spleen' dataset columns with the updated function
results_prol <- perform_t_test_multiple_columns("prol", prol_columns)
results_prol

results_activated_spleen <- perform_t_test_multiple_columns("activated spleen", actSpln_columns)
results_activated_spleen




#---------------------   Tregs  ----------------------#
results_Tregratio <- perform_t_test_for_column(ActivatedWTSpleen, ActivatedKOSpleen, "X4TregRatio", "less")
print(results_Tregratio)

results_TregCT <- perform_t_test_for_column(ActivatedWTSpleen, ActivatedKOSpleen, "X4TregCT", "less")
results_TregCT


#---------------------   CD44CD62L  ----------------------#

results_acT_fraction <- perform_t_test_for_column(ActivatedWTSpleen, ActivatedKOSpleen, "ActivatedCD4CT")
results_acT_fraction

#---------------------   CD44CD62L  ----------------------#







#####
# Testing stuff out

WTprol_12 <- subset(WTProl, Age == 12)
KOprol_12 <- subset(KOProl, Age == 12)

wilcox.test(KOprol_12$NonProlActivatedCT, WTprol_12$NonProlActivatedCT, alternative = "greater")






