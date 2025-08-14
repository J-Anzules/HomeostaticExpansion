#SavingData for modeling

WTProl = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl_D0_2.csv')
KOProl = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl_D0_2.csv')
ActivatedWTSpleen = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen_D0_2.csv')
ActivatedKOSpleen = read.csv('C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen_D0_2.csv')

age_test = 0

wtprol0 = subset(WTProl, Age == age_test)
koprol0 = subset(KOProl, Age == age_test)
activatedwtspleen0 = subset(ActivatedWTSpleen, Age == age_test)
activatedkospleen0 = subset(ActivatedKOSpleen, Age == age_test)

mean(activatedwtspleen0$NaiveCT)
mean(activatedwtspleen0$ActivatedCD4CT)
mean(activatedwtspleen0$X4TregCT)

mean(activatedwtspleen0$ThymicNaive)
mean(activatedwtspleen0$ActivatedNaiveCT)
mean(activatedwtspleen0$ThymicDerivedTregsCT)
mean(activatedwtspleen0$NaiveDerivedTregsCT)

mean(wtprol0$NaiveProlCT)
mean(wtprol0$ActivatedProlCT)
mean(wtprol0$X4TregProlCT)

## Knock out

mean(activatedkospleen0$NaiveCT)
mean(activatedkospleen0$ActivatedCD4CT)
mean(activatedkospleen0$X4TregCT)

mean(activatedkospleen0$ThymicNaive)
mean(activatedkospleen0$ActivatedNaiveCT)
mean(activatedkospleen0$ThymicDerivedTregsCT)
mean(activatedkospleen0$NaiveDerivedTregsCT)

mean(koprol0$NaiveProlCT)
mean(koprol0$ActivatedProlCT)
mean(koprol0$X4TregProlCT)


## Combined

combinedprol0 <- rbind(wtprol0, koprol0)
combined0 <- rbind(activatedwtspleen0, activatedkospleen0)

mean(combined0$NaiveCT)
mean(combined0$ThymicNaive)
mean(combinedprol0$NaiveProlCT)
mean(combined0$ThymicNaive) + mean(combinedprol0$NaiveProlCT)

mean(combined0$ActivatedCD4CT)
mean(combined0$ActivatedNaiveCT)
mean(combinedprol0$ActivatedProlCT)
mean(combined0$ActivatedNaiveCT) + mean(combinedprol0$ActivatedProlCT)

mean(combined0$X4TregCT)
mean(combined0$ThymicDerivedTregsCT)
mean(combined0$NaiveDerivedTregsCT)
mean(combined0$X4TregProlCT)
mean(combined0$ThymicDerivedTregsCT) + mean(combined0$NaiveDerivedTregsCT) + mean(combinedprol0$X4TregProlCT)

# --- Counts for model
mean(combined0$NaiveCT)
mean(combined0$ActivatedCD4CT)
mean(combined0$X4TregCT)

mean(combined0$ThymicNaive)
mean(combined0$ActivatedNaiveCT)
mean(combined0$ThymicDerivedTregsCT)
mean(combined0$NaiveDerivedTregsCT)

mean(combinedprol0$NaiveProlCT)
mean(combinedprol0$ActivatedProlCT)
mean(combined0$X4TregProlCT)

(345 + 557) * 0.1
