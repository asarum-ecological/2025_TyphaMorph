#Triangle Plot 
library(HIest) # you have to do this manually now 
library(ggplot2)
library(ggrepel)
library(dplyr)
G.csv<-read.csv("HIest_Formatted_G.csv")
P.csv<-read.csv("HIest_Formatted_P.csv")
G<-as.data.frame(G.csv)
P<-as.data.frame(P.csv)
G$Sample<-NULL
HIclass<-HIclass(G,P, type="codominant")
HIest<-HIest(G, P, "codominant", method = "SANN")
HIest
HIest$species<-c("AF1","AF2","AF3","AF4","AF5","AI1","AI2","AI3","AI4","AI5","AS1","AS2","AS3","AS4","AS5",
                 "GF1","GF2","GF3","GF4","GF5","GI1","GI2","GI3","GI4","GI5","GS1","GS2","GS3","GS4","GS5",
                 "LF1","LF2","LF3","LF4","LF5","LI1","LI2","LI3","LI4","LI5","LS1","LS2","LS3","LS4","LS5","LS6")
rownames(HIest)<-HIest[,4]
HIest$Taxa<-c("ANG","ANG","ANG","ANG","ANG","ANG","ANG","ANG","ANG","ANG","ANG","ANG","ANG","ANG","ANG",
              "GLA","GLA","GLA","GLA","GLA","GLA","GLA","GLA","GLA","GLA","GLA","GLA","GLA","GLA","GLA",
              "LAT","LAT","LAT","LAT","LAT","LAT","LAT","LAT","LAT","LAT","LAT","LAT","LAT","LAT","LAT","LAT")
Plot<-ggplot(HIest,aes(x=S,y=H))+
  geom_point(aes(color=Taxa))+
  xlab("Ancestry (S)")+
  ylab("Heterozygosity (H)")+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"), 
        legend.position = "bottom", 
        legend.title=element_blank(),
        legend.text=element_text(size=12),
        legend.key = element_rect(fill = "white"), 
        axis.text = element_text(size = 12), 
        axis.title = element_text(size = 12))+
  coord_cartesian(xlim=c(0,1),ylim=c(0,1))+
  geom_segment(aes(x=0,y=0,xend=0.5,yend=1),linewidth=0.05)+
  geom_segment(aes(x=0.5,y=1,xend=1,yend=0),linewidth=0.05)+
  geom_segment(aes(x=0,y=0,xend=1,yend=0),linewidth=0.05)+
  geom_text_repel(label=rownames(HIest), aes(color=Taxa), show.legend = FALSE, max.overlaps=Inf)+
  scale_color_manual(values=c("#D55E00", "#009E73", "#0072B2"), 
                     labels=c("T. angustifolia", "T. x glauca", "T. latifolia"))+
  guides(colour = guide_legend(override.aes = list(size=5)))
Plot
