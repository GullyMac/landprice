###EDA

###패키지
library(RColorBrewer)
library(maptools)
library(foreign)
library(ggplot2)
library(dplyr)
library(gdata)
library(gridExtra)
library(readr)
library(readAny)

Seoul_school_location <- read.any("Seoul_school_location.csv", head = TRUE)
danran <- read.any("combined_activate.csv", head = TRUE)


guname <- matrix(nrow =25, ncol = 3)
guname <- as.data.frame(guname)
names(guname) <- c("name", "schoolnum","danrannum")
guname[,1] <- c("도봉구","동대문구","동작구","은평구","강동구","강북구","강남구","강서구","금천구","구로구","관악구","광진구","종로구","중구","중랑구","마포구","노원구","서초구","서대문구","성북구","성동구","송파구","양천구","영등포구","용산구")

### 학교수 세기
for (i in 1:25){
  guname[i,2] <- length(grep(guname[i,1], Seoul_school_location$소재지지번주소))
}

### 단란주점, 유흥업소

#결측치 보충
for (i in 1:length(danran$소재지도로명)){
  if(danran$소재지도로명[i] == ""){
    danran$소재지도로명[i] <- danran$소재지지번[i]
  }
}

for (i in 1:25){
  guname[i,3] <-length(grep(guname[i,1],danran$소재지도로명))
}

### 지도 그리기 출처 http://bads.tistory.com/17 
seoul<-read.dbf("v시군구_TM.dbf")
seoul<-filter(seoul,광역시명 == "서울특별")
seoul$시군구명 <- as.character(seoul$시군구명)
seoulmap<-readShapePoly("v시군구_TM.shp")
seoulmap<-seoulmap[which(seoulmap@data$광역시명 == "서울특별"),]
seoulmap <- fortify(seoulmap)

for (i in  1:25){
  j <- i - 1
  eval(parse(text = paste0("seoulmap$id[seoulmap$id == ",j,"]<-seoul$시군구명[",i,"]")))
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

newdata<- left_join(seoulmap,guname,by = c("id" = "name"))
RdPu <- brewer.pal(7,"RdPu")

## 학교 분포
seoulschool<-ggplot(data = newdata, aes(x =long, y = lat, group = id, fill = schoolnum)) + geom_polygon(colour = "white") + theme_clean() + scale_fill_gradient2(low = RdPu[1], mid = RdPu[3] ,high = RdPu[7]) + ggtitle("서울시 학교 분포도") + theme(plot.title = element_text(size = rel(1.5), lineheight = .9)) + labs(fill = "학교 수")
seoulschool

##단란 유흥 분포
seouldanran<-ggplot(data = newdata, aes(x =long, y = lat, group = id, fill = danrannum)) + geom_polygon(colour = "white") + theme_clean() + scale_fill_gradient2(low = RdPu[1], mid = RdPu[3] ,high = RdPu[7]) + ggtitle("서울시 유흥업소 분포도") + theme(plot.title = element_text(size = rel(1.5), lineheight = .9)) + labs(fill = "업소 수")
seouldanran