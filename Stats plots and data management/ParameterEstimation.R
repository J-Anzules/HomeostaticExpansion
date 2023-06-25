Minimized = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ParameterSearch_mu_0.39_0.42.csv")

hist(Minimized$Error, breaks = 30)
plot(Minimized$Error, breaks = 30)



hist(Minimized$Error)
#Removing outliers
length(Minimized$Error)



High_Plus = subset(Minimized, Error >= 154000)
###Histograms of all
for (col in 2:ncol(High_Plus)) {
  hist(Minimized[,col],
       main = colnames(Minimized)[col], breaks= 40)
}
 a = quantile(Minimized$a)#There is a way to calculate the lowest percentages
typeof(a)
?prop.test
prop.test(x = c(380, 168),  n= c(4991, 5326), alternative = "greater")

## Individual Plots
MiniMinimized = subset(Minimized, Error < 2.0e+14)
plot(MiniMinimized$EntryNumber, MiniMinimized$Error, type = "l",
     main = "Plot of all the Errors", 
     xlab = "Experiment Number",
     ylab = "Error Value")
#Summaries
summary(Minimized$alpha)
summary(Minimized$a)
summary(Minimized$kA)
summary(Minimized$e_T)
summary(Minimized$e_R)
summary(Minimized$g)
summary(Minimized$b_T)
summary(Minimized$b_R)

#For Katrina Lab Meeting
hist(Minimized$alpha, breaks = 40, cex.main=3, cex.lab = 2, cex.axis = 1.5,
     main = "alpha: Production Rate of Tregs from Thymus",
     xlab = "Parameter Value")
hist(Minimized$a, breaks = 40, cex.main=3, cex.lab = 2, cex.axis = 1.5,
     main = "a: Self Replication Rate",
     xlab = "Parameter Value")
hist(Minimized$kA, breaks = 40, cex.main=3, cex.lab = 2, cex.axis = 1.5,
     main = "kA: Suppression Strength of Tregs",
     xlab = "Parameter Value")
hist(Minimized$e_T, cex.main=3, cex.lab = 2, cex.axis = 1.5,
     main = "e_T: IL-2 Consumption Rate by AcT",
     xlab = "Parameter Value",
     breaks = 30)
hist(Minimized$e_R, cex.main=3, cex.lab = 2, cex.axis = 1.5,
     main = "e_R: IL-2 Consumption Rate by Treg",
     xlab = "Parameter Value",
     breaks = 30)
hist(Minimized$g, breaks = 40, cex.main=3, cex.lab = 2, cex.axis = 1.5,
     main = "g: Death Rate of Naive T Cells",
     xlab = "Parameter Values")
hist(Minimized$b_T, breaks = 40, cex.main=3, cex.lab = 2, cex.axis = 1.5,
     main = "b_T: Death Rates of Activ. T",
     xlab = "Parameter Value")
hist(Minimized$b_R, breaks = 40, cex.main=3, cex.lab = 2, cex.axis = 1.5,
     main = "b_R: Death Rate of Tregs",
     xlab = "Parameter Value")



##Minimized = read.csv("~/my.work/PhD/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ParameterRanges8.csv")

#Removing obvious outliers
Minimized = subset(Minimized, Error < 1.12e+14)

LowError = subset(Minimized, Error < 1.10e+14)
HighError = subset(Minimized, Error >= 1.10e+14)

c1 <- rgb(173,216,230,max = 255, alpha = 80, names = "lt.blue")
c2 <- rgb(255,192,203, max = 255, alpha = 80, names = "lt.pink")

asct = hist(associates$Adj.NetW.11, plot = FALSE)
Bch = hist(bachelors$Adj.NetW.11, plot = FALSE)

plot(Bch, col = c2, main = "idk", xlab = "stuff")
plot(asct, col = c1 , add = TRUE)

#Setting up a loop for histograms
c1 <- rgb(173,216,230,max = 255, alpha = 80, names = "lt.blue")
c2 <- rgb(255,192,203, max = 255, alpha = 80, names = "lt.pink")
Minimized = subset(Minimized, Error < 1.12e+14)
LowError = subset(Minimized, Error < 1.10e+14)
HighError = subset(Minimized, Error >= 1.10e+14)

for (col in 8:ncol(Minimized)) {
  LowHist = hist(LowError[,col], breaks = 40, plot = FALSE)
  HighHist = hist(HighError[,col], breaks = 40, plot = FALSE)
  
  plot(HighHist, col = c2, main = colnames(Minimized)[col],
       xlab = "Parameter Values", plot= FALSE)
  plot(LowHist, col = c1, add = TRUE)
  hist(Minimized[,col],
      main = colnames(Minimized)[col], breaks= 40)
}


LowError = subset(Minimized, Error < 22000)
HighError = subset(Minimized, Error >= 22000 & Error < 133000)

for (col in 8:ncol(Minimized)) {
  LowHist = hist(LowError[,col], breaks = 40, plot = FALSE)
  HighHist = hist(HighError[,col], breaks = 40, plot = FALSE)
  
  plot(HighHist, col = c2, main = colnames(Minimized)[col],
       xlab = "Parameter Values", plot= FALSE)
  plot(LowHist, col = c1, add = TRUE)
  hist(Minimized[,col],
       main = colnames(Minimized)[col], breaks= 40)
}
