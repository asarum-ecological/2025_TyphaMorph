#Packages Needed
library(ggplot2)
library(randomForest)
library(poppr)
library(ggpubr)
library(cowplot)


#Data Import + RandomForest Analysis 
typhadata<-read.csv("Typha_Data_Mean.csv")
typhadata$EST_SPECIES<-as.factor(typhadata$EST_SPECIES)
rf<-randomForest(typhadata, ntree=1000, mtry=3, proximity=TRUE, keep.forest=TRUE) 

#Morphology
proximity<-(rf$proximity)
distance.matrix.unsup<-dist(1-rf$proximity)
mds.unsup<-cmdscale(distance.matrix.unsup, eig=TRUE, x.ret=TRUE)
mds.var.per.unsup<-round(mds.unsup$eig/sum(mds.unsup$eig)*100,1)
mds.values.unsup<-mds.unsup$points#Add the rownames here 
mds.values.unsup
rownames(mds.values.unsup)<-c("GF1","GF2","AF1","AF2","LF1","LF2","LF3","GF3","GF4","AF3","AF4","LF4","AF5","LF5","GF5",
                              "AS1","LS1","GS1","AS2","LS2","LS3","LS4","GS2","GS3","AS3","GS4","AS4","LS5","AS5","LS6",
                              "GS5","LI1","GI1","GI2","AI1","AI2","AI3","GI3","AI5","GI4","GI5","AI5","LI2","LI3","LI4","LI5")
mds.data.unsup<-data.frame(Sample=rownames(mds.values.unsup),
                           X=mds.values.unsup[,1],
                           Y=mds.values.unsup[,2],
                           Status=typhadata$EST_SPECIES)
#Plot
morph<-ggplot(data=mds.data.unsup, aes(x=X,y=Y,label=Sample)) + 
  geom_text(aes(color=Status), show.legend = FALSE) +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black"), 
        axis.text = element_text(size = 12), 
        axis.title = element_text(size = 12)) + 
  xlab(paste("MDS1 - ",mds.var.per.unsup[1],"%",sep="")) +
  ylab(paste("MDS2 - ",mds.var.per.unsup[2],"%",sep="")) +
  scale_color_manual(values=c("#D55E00", "#009E73", "#0072B2"))
#View plot
morph

#Import Microsat data
data<-read.genalex("GenAlExPoppr.csv")

#Run bruvo analysis on data 
bruvo<-bruvo.dist(data)
matrix<-as.matrix(dist(bruvo))
MDS<-cmdscale(matrix, eig=TRUE, x.ret=TRUE)
mds.var.per<-round(MDS$eig/sum(MDS$eig)*100,1)
mds.value<-MDS$points
rownames(mds.value)<-c("AF1","AF2","AF3","AF4","AF5","AI1","AI2","AI3","AI4","AI5","AS1","AS2","AS3","AS4","AS5",
                       "GF1","GF2","GF3","GF4","GF5","GI1","GI2","GI3","GI4","GI5","GS1","GS2","GS3","GS4","GS5",
                       "LF1","LF2","LF3","LF4","LF5","LI1","LI2","LI3","LI4","LI5","LS1","LS2","LS3","LS4","LS5","LS6")
mds.data<-data.frame(Sample=rownames(mds.value),
                     X=mds.value[,1],
                     Y=mds.value[,2],
                     Status=data$pop)
#Plot analysis 
microsat<-ggplot(data=mds.data, aes(x=X,y=Y,label=Sample)) + 
  geom_text(aes(color=Status), show.legend = FALSE ) +
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(), 
        axis.line = element_line(colour = "black"), 
        axis.text = element_text(size = 12), 
        axis.title = element_text(size = 12)) + 
  xlab(paste("MDS1 - ",mds.var.per[1],"%",sep="")) +
  ylab(paste("MDS2 - ",mds.var.per[2],"%",sep="")) +
  scale_color_manual(values=c("#D55E00", "#009E73", "#0072B2"))

#View plot 
microsat


#to combine but not needed: plot_grid(morph, microsat, labels=c("A", "B"), ncol=1) 
