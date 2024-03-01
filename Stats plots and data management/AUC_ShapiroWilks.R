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


#-----------------------------------------------#
#                 Testing Power
#-----------------------------------------------#
install.packages("pwr")
library(pwr)

effect_size <- 0.2
n <- 3
sig_level <- 0.05

# Calculate the power
pwr_result <- pwr.t.test(n = n, d = effect_size, sig.level = sig_level, type = "two.sample", alternative = "two.sided")

# Print the power
print(pwr_result$power)


#






