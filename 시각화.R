library(maptools)
library(foreign)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(grid)
library(gridExtra)

data_final<-read.csv("finaldataset_dong.csv")
data_final$dong<-as.character(data_final$dong)
data_set<-list()
for(i in 1:25){
  data_set[[i]]<-data_final[which(data_final$gu == levels(data_final$gu)[i]),]
}
names(data_set)<-levels(data_final$gu)

donginfo<-read.dbf("TL_SCCO_EMD.dbf")
donginfo<-donginfo[1:467,]
donginfo$EMD_CD<-as.integer(as.character(donginfo$EMD_CD))
donginfo$EMD_KOR_NM<-as.character(donginfo$EMD_KOR_NM)
grep("신사동",donginfo$EMD_KOR_NM)
donginfo$EMD_KOR_NM[298]<-"신사동(은평)"
donginfo$EMD_KOR_NM[437]<-"신사동(강남)"
grep("신정동",donginfo$EMD_KOR_NM)
donginfo$EMD_KOR_NM[337]<-"신정동(마포)"
donginfo$EMD_KOR_NM[347]<-"신정동(양천)"

dongmap<-readShapePoly("TM_SCCO_EMD.shp")
dongmap<-dongmap[which(dongmap@data$EMD_CD <= 20000000),]
dongmap<-fortify(dongmap)
for (i in  1:467){
  j <- i - 1
  eval(parse(text = paste0("dongmap$id[dongmap$id == ",j,"]<-donginfo$EMD_KOR_NM[",i,"]")))
}

for (i in 1:25){
  data_set[[i]]<-left_join(data_set[[i]],dongmap,by = c("dong" = "id"))
}

theme_clean<- function(base_size = 12){
  
  require(grid)
  theme_grey(base_size) %+replace%
    theme(
      axis.title = element_blank(), 
      axis.text = element_blank(), 
      panel.background = element_blank(), 
      panel.grid = element_blank(), 
      axis.ticks.length = unit(0, "cm"), 
      axis.ticks.margin = unit(0, "cm"), 
      panel.margin = unit(0, "lines"), 
      plot.margin = unit(c(0, 0, 0, 0), "lines"), 
      complete = TRUE )
}

PuRd <- brewer.pal(9, "PuRd")

school<-list()
for (i in 1:25){
  school[[i]]<-ggplot(data = data_set[[i]],aes(x=long,y=lat,group=dong,fill=school))+geom_polygon(colour="white")+theme_clean()+ggtitle(levels(data_final$gu)[i])+scale_fill_gradient2(low = PuRd[1], mid = PuRd[3] ,high = PuRd[5], midpoint = median(data_final$school))+theme(legend.position = "none")
}
grid.arrange(grobs = school,ncol = 5,top = "학교")

yuheung<-list()
for (i in 1:25){
  yuheung[[i]]<-ggplot(data = data_set[[i]],aes(x=long,y=lat,group=dong,fill=yuheung))+geom_polygon(colour="white")+theme_clean()+ggtitle(levels(data_final$gu)[i])+scale_fill_gradient2(low = PuRd[1], mid = PuRd[3] ,high = PuRd[5], midpoint = median(data_final$yuheung))+theme(legend.position = "none")
}
grid.arrange(grobs = yuheung,ncol = 5,top = "유흥업소")

sukbak<-list()
for (i in 1:25){
  sukbak[[i]]<-ggplot(data = data_set[[i]],aes(x=long,y=lat,group=dong,fill=sukbak))+geom_polygon(colour="white")+theme_clean()+ggtitle(levels(data_final$gu)[i])+scale_fill_gradient2(low = PuRd[1], mid = PuRd[3] ,high = PuRd[5], midpoint = median(data_final$sukbak))+theme(legend.position = "none")
}
grid.arrange(grobs = sukbak,ncol = 5,top = "숙박업소")

landvalue<-list()
for (i in 1:25){
  landvalue[[i]]<-ggplot(data = data_set[[i]],aes(x=long,y=lat,group=dong,fill=landvalue)+geom_polygon(colour="white")+theme_clean()+ggtitle(levels(data_final$gu)[i])+scale_fill_gradient2(low = PuRd[1], mid = PuRd[3] ,high = PuRd[5], midpoint = median(data_final$landvalue))+theme(legend.position = "none"))
}
grid.arrange(grobs = landvalue,ncol = 5,top = "지가")

