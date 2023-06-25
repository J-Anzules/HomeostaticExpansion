#SavingData for modeling
WTProl = read.csv('~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/WTProl.csv')
KOProl = read.csv('~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/KOProl.csv')
ActivatedWTSpleen = read.csv('~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedWTSpleen.csv')
ActivatedKOSpleen = read.csv('~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/RawData/ActivatedKOSpleen.csv')


wtprol0 = subset(WTProl, Age == 0 )
koprol0 = subset(KOProl, Age == 0)
activatedwtspleen0 = subset(ActivatedWTSpleen, Age == 0)
activatedkospleen0 = subset(ActivatedKOSpleen, Age == 0)

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
