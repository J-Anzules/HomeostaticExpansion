library(ggplot2)
Minimized = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ParameterSearch_mu_0.39_0.42.csv")
Minimized2 = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ParameterSearch_ALL.csv")

#removing outliers
Minimized = subset(Minimized, Error < 10000)



hist(Minimized$Error, xlim = c(4000,10000), breaks = 1000)


a = cor(Minimized)
b = cor(Minimized2)


max(Minimized$EntryNumber)
max(a, na.rm = TRUE)



#Trying to see wher eall the data lies.
#Here we find that the least R squared has found a good range for our mu parameter
# with no desire to shift from that range. This is fortunate because values outside that range 
plot(Minimized$mu, Minimized$Error,
     main = "mu")
# Great fit and the most important parameter because it is the most sensitive
plot(Minimized$epsilon, Minimized$Error,
     main = "Epsilon -Treg replication")
#low beta high tregs, high beta, everything dies.
#Lowered self treg replication results in lowered inhibition of activated T
#cells, leading to more activation early on and reducing the amount of available naive T cells for self replication
#reducing the overall population size. There is a lot of interesting dynamics that happen in this model
# that we are only scratching the surface of. 
# I should make a figure and look closely at the activation rate
# If I go higher than the range that I have found here then the self replicaiton of Tregs will be too great and suppress
# activation, reaching past the carrying capacity of Tregs 
plot(Minimized$beta, Minimized$Error,
     main = "Beta")
plot(Minimized$alpha, Minimized$Error,
     main = "alpha")
summary(Minimized$alpha)
#Alpha is staying this range, this is a good range, weird shit happens outside of that range
# Behavior past this point made it so the model tried to suppress the activated T cell population.
# Eh, not good story here.
# the alpha range was way too high
plot(Minimized$nK, Minimized$Error,
     main = "nK")
plot(Minimized$g, Minimized$Error,
     main = "d_N")
plot(Minimized$z, Minimized$Error,
     main = "z, Naive self replication")
#High values here, past the wall show unrealistic Treg growth.
#Lower values lowers the overall population size to something that is unrealistically biologically after a certain point






######################################################################
######################################################################
#Finding the error range
Minimized2 = subset(Minimized2, Error > 3000 & Error <7000)
summary(min2$Error)

minMedian = subset(min2, Error > 4100 & Error < 4300)
sort(minMedian$Error)
min2chosen = subset(minMedian, Error == 4207.627)

min2chosen$EntryNumber
plot(Minimized2$mu, Minimized2$Error,
     main = "mu - Thymic production of Naive T cell ", 
     ylim = c(3000, 7000),
     xlab = "Mu value",
     ylab = "Error")
cor(Minimized2$mu, Minimized2$Error)

plot(Minimized2$epsilon, Minimized2$Error,
     main = "Epsilon -Treg replication", ylim = c(3000, 7000))
cor(Minimized2$epsilon, Minimized2$Error,)

plot(Minimized2$beta, Minimized2$Error,
     main = "Beta", ylim = c(3000, 7000))
cor(Minimized2$beta, Minimized2$Error)

summary(Minimized2$Error)

plot(Minimized2$alpha, Minimized2$Error, xlim = c(0.000448759, 0.0007),
     main = "alpha - Thymic Treg production rate", 
     ylim = c(3000, 7000),
     xlab = "alpha value",
     ylab = "Error")
cor(Minimized2$alpha, Minimized2$Error)
summary(lm(Minimized2$Error ~ Minimized2$alpha))

summary(Minimized2$alpha)

plot(Minimized2$nK, Minimized2$Error,
     main = "nK - Naive T cell carrying capacity", 
     ylim = c(3000, 7000),
     xlab = "nK value",
     ylab = "Error"
     )
plot(Minimized2$g, Minimized2$Error,
     main = "d_N", ylim = c(3000, 7000))
plot(Minimized2$z, Minimized2$Error,
     main = "S_N, Naive self replication", 
     ylim = c(3000, 7000),
     xlab = "S_N value",
     ylab = "Error")

qqnorm(min2$Error)
#Test out b_R
#Check out acTT self replication


hist(Minimized$Error, breaks = 100)

plot(Minimized$Error, Minimized$beta)
plot(Minimized$Error, Minimized$alpha)

#Removing outliers
min

length(Minimized$Error)



summary(Minimized2$Error)
a = subset(Minimized2, Error < 4180 & Error > 4199)

#-------------------------------------------------------#
#             bR      
#-------------------------------------------------------#
MinbR = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ParameterSearch_bR.csv")

plot(MinbR$bR, MinbR$Error)
cor(MinbR$bR, MinbR$Error)

summary(MinbR$Error)


#-------------------------------------------------------#
#             bR2      
#-------------------------------------------------------#
MinbR2 = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ParameterSearch_bR_2.csv")

summary(MinbR2$Error)
plot(MinbR2$c, MinbR2$Error)

#-------------------------------------------------------#
#             a 3%      
#-------------------------------------------------------#
Min = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ParameterSearch_a3pct.csv")

plot(Min$a, Min$Error, xlim=c(0.0064, 0.0068))
summary(Min$Error)

#-------------------------------------------------------#
#             Open ALL      
#-------------------------------------------------------#
Min = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ParameterSearch_opnall5.csv")
dim(Min)
summary(Min$Error)
3431 - sd(Min$Error)
3431 + sd(Min$Error)

3677 - 2959


# How many are clustered on the wall 
muLow = subset(Min, mu < 0.4065)
muHigh = subset(Min, mu >= 0.4065)

nrow(muLow)/(nrow(muLow)+nrow(muHigh))
nrow(muHigh)

# Beta
betaLow = subset(Min, beta < 0.3005)
betaHigh = subset(Min, beta >= 0.3005)

nrow(betaLow)
nrow(betaHigh)

nrow(betaHigh) / (nrow(betaLow)+ nrow(betaHigh))

plot(Min$mu, Min$Error)
cor(Min$mu, Min$Error)
plot(Min$z, Min$Error)
plot(Min$g, Min$Error)
plot(Min$alpha, Min$Error)
plot(Min$c, Min$Error)
plot(Min$epsilon, Min$Error)
cor(Min$epsilon, Min$Error)
plot(Min$bR, Min$Error)
plot(Min$beta, Min$Error)
plot(Min$a, Min$Error)
plot(Min$bT, Min$Error)
cor(Min$bT, Min$Error)
plot(Min$kA, Min$Error)
plot(Min$j, Min$Error)
plot(Min$kB, Min$Error)
plot(Min$nK, Min$Error)
plot(Min$Ki, Min$Error)
plot(Min$Kj, Min$Error)
hist(Min$Error, breaks = 100, xlim = c(2100, 4500),
     xlab = "Relative Error Range",
     main = "Relative Error Counts",
     ylab = "Frequency Counts")

?hist
xAxisTextSize = 21
yAxisTextSize = 21
titleAxisTextSize =18
dotSize = 1.5
tickNumSize = 18

ggplot(Min, aes(x = z, y = Error)) + 
  geom_point(position = position_dodge(1), size = dotSize)+
  scale_x_continuous(limits=c(0.027, 0.032))+
  scale_y_continuous(limits = c(2500, 10000))+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.position = "none",
        axis.title.x = element_text(colour="black", size=xAxisTextSize),
        axis.title.y = element_text( colour = "black", size = yAxisTextSize),
        plot.title = element_text(lineheight=.8,  size = titleAxisTextSize),
        #axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=tickNumSize),
        panel.border = element_rect(color = "black",
                                    fill = "NA",
                                    size = 2))+
labs(titles = "Naive T cell proliferation rate", x = "Naive T cell proliferation rate", y = "Error value")

ggplot(Min, aes(x = epsilon, y = Error)) + 
  geom_point(position = position_dodge(1), size = dotSize)+
  scale_x_continuous(limits=c(0.001, 0.006))+
  scale_y_continuous(limits = c(2500, 10000))+
  theme(panel.background = element_rect(fill = "white", colour = "black", size = 2),
        legend.position = "none",
        axis.title.x = element_text(colour="black", size=xAxisTextSize),
        axis.title.y = element_text( colour = "black", size = yAxisTextSize),
        plot.title = element_text(lineheight=.8,  size = titleAxisTextSize),
        #axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=tickNumSize),
        panel.border = element_rect(color = "black",
                                    fill = "NA",
                                    size = 2))+
  labs(titles = "Treg proliferation rate", x = "Treg proliferation rate", y = "Error value")

cor(Min$epsilon, Min$Error)
cor(Min$z, Min$Error)
summary(Min$epsilon)  
# stat_summary( fun=mean, geom="line")+
  
  
  # scale_y_continuous(breaks = seq(0,3880000, length.out = 5))+
  #scale_y_continuous(limits=c(0, 7072000), breaks = c(0, 1768000, 3536000, 5304000, 7072000), labels = c(0, 1.7, 3.5, 5.3, 7.0))+
  

summary(Min$z)





#-------------------------------------------------------#
#             a 3%      
#-------------------------------------------------------#

MinOld = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ParameterSearch_ALL.csv")
Mulow = subset(MinOld,)

summary(MinOld$Error) #3622 of the parameter that I first chose.


plot(MinOld$mu, MinOld$Error)
plot(MinOld$z, MinOld$Error)
plot(MinOld$g, MinOld$Error)
plot(MinOld$alpha, MinOld$Error)
plot(MinOld$c, MinOld$Error)
plot(MinOld$epsilon, MinOld$Error)
plot(MinOld$bR, MinOld$Error)
plot(MinOld$beta, MinOld$Error)
plot(MinOld$a, MinOld$Error)
plot(MinOld$bT, MinOld$Error)
cor(MinOld$bT, MinOld$Error)
plot(MinOld$kA, MinOld$Error)
plot(MinOld$j, MinOld$Error)
plot(MinOld$kB, MinOld$Error)
plot(MinOld$nK, MinOld$Error)
plot(MinOld$Ki, MinOld$Error)
plot(MinOld$Kj, MinOld$Error)
hist(MinOld$Error, breaks = 40)

