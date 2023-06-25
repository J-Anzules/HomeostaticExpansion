library("ggplot2")
WTevery = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ModelOutputEverythingWT.csv")
KOevery = read.csv("C:/Laptop Backups/HomestaticExpansionProject/Code/Modeling/Matlab/Data/ModelOutputEverythingKO.csv")
WTevery$hour = 1:nrow(WTevery)/24
KOevery$hour = 1:nrow(KOevery)/24


lineWT = 2
lineKO = 2
panelSize = 2
xAxisSize = 20
yAxisSize = 30
TitleSize = 30
tixkSize = 30


ggplot() +
  geom_line(data=WTevery, aes(x=hour, y=TregLoss), lwd = lineWT)+
  geom_line(data=KOevery, aes(x = hour, y=TregLoss), linetype = "dashed", colour = "black", lwd = lineKO)+
  # scale_y_continuous(limits = c(0,30))
  theme(panel.background = element_rect(fill = "white", colour = "black", size = panelSize),
        # legend.key = element_rect(fill = "white", colour = "black"),
        # legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=xAxisSize),
        axis.title.y = element_text( colour = "black", size = yAxisSize),
        plot.title = element_text(lineheight=.8,  size = TitleSize),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=tixkSize))+
  labs(titles = "Treg death rate", x = "Age in days", y = "Cell Counts")+
  scale_y_continuous(trans = "log10")
  # scale_color_manual(name = "Y series", values = c("Y1" = "darkblue", "Y2" = "red"))
  # scale_y_continuous(limits = c(0,2200000))



# ggplot(data=WTevery, aes(x=hour, y=TregLoss)) +
#   geom_line(lwd = lineWT)+
#   geom_line(data = KOevery, aes(x = hour, y=TregLoss), linetype = "dashed", colour = "black", lwd = lineKO)+
#   # scale_y_continuous(limits = c(0,30))
#   theme(panel.background = element_rect(fill = "white", colour = "black", size = panelSize),
#         legend.key = element_rect(fill = "white", colour = "black"),
#         legend.background = (element_rect(colour= "black", fill = "white")),
#         axis.title.x = element_text( colour="black", size=xAxisSize),
#         axis.title.y = element_text( colour = "black", size = yAxisSize),
#         plot.title = element_text(lineheight=.8,  size = TitleSize),
#         axis.ticks.length=unit(.25, "cm"),
#         text = element_text(size=tixkSize))+
# labs(titles = "Zoomed in Treg death rate ", x = "Age in days", y = "Cell Counts")+
# scale_x_continuous(limits = c(0,7))+
# scale_y_continuous(limits = c(0, 15))

#------------------------------------------------------------------------
#                             Proliferation
#------------------------------------------------------------------------

YlabelProl =  expression("Cell Counts"~(10^5))
ggplot(data=WTevery, aes(x=hour, y=ProlTregs)) +
  geom_line(lwd = lineWT)+
  geom_line(data = KOevery, aes(x = hour, y=ProlTregs), linetype = "dashed", colour = "black", lwd = lineKO)+
  # scale_y_continuous(limits = c(0,30))
  theme(panel.background = element_rect(fill = "white", colour = "black", size = panelSize),
        legend.key = element_rect(fill = "white", colour = "black"),
        legend.background = (element_rect(colour= "black", fill = "white")),
        axis.title.x = element_text( colour="black", size=xAxisSize),
        axis.title.y = element_text( colour = "black", size = yAxisSize),
        plot.title = element_text(lineheight=.8,  size = TitleSize),
        axis.ticks.length=unit(.25, "cm"),
        text = element_text(size=tixkSize))+
  labs(titles = "Proliferating Tregs", x = "Age in days", y = YlabelProl)+
  scale_y_continuous(trans = "log10")
# scale_y_continuous(limits=c(0, 100000), breaks = c(0, 50000, 100000), label = c(0.0, 0.5, 1.0))
max(WTevery$ProlTregs)
# scale_y_continuous(limits = c(0,2200000))

#Zoomed in
# ggplot(data=WTevery, aes(x=hour, y=ProlTregs)) +
#   geom_line(lwd = lineWT)+
#   geom_line(data = KOevery, aes(x = hour, y=ProlTregs), linetype = "dashed", colour = "black", lwd = lineKO)+
#   # scale_y_continuous(limits = c(0,30))
#   theme(panel.background = element_rect(fill = "white", colour = "black", size = panelSize),
#         legend.key = element_rect(fill = "white", colour = "black"),
#         legend.background = (element_rect(colour= "black", fill = "white")),
#         axis.title.x = element_text( colour="black", size=xAxisSize),
#         axis.title.y = element_text( colour = "black", size = yAxisSize),
#         plot.title = element_text(lineheight=.8,  size = TitleSize),
#         axis.ticks.length=unit(.25, "cm"),
#         text = element_text(size=tixkSize))+
#   labs(titles = "Zoomed in proliferatin Tregs ", x = "Age in days", y = "Cell Counts")+
#   scale_x_continuous(limits = c(0,7))+
#   scale_y_continuous(limits = c(0, 2000))

