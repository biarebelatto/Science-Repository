#=====================================#
# PCA Hyperspectral Indices  by Years #
#                                     #
# Eduardo Q Marques 05-10-2020        #
#=====================================#


library(stats)
library(tidyverse)
library(reshape2)
library(FactoMineR)
library(factoextra)

#Data =============================================================================================
setwd("C:/Users/Eduardo Q Marques/Documents/My Jobs/Doutorado/Banco de Dados Tanguro/Dados para analise cap1")

df = read.csv("Hyperion_indexs_all_xy.csv", sep = ',')

#Transform data for analysis ======================================================================
df2 = df[c(5,7)]
#df2$value = log(df2$value)

#Transpor variables in columns
transp = function(x){
  z = df2 %>% 
    filter(index == x)
  z = as.data.frame(z[,c(2)])
}

ari = transp("ari");colnames(ari) = c("ari")
evi = transp("evi2");colnames(evi) = c("evi")
ndvi = transp("ndvi");colnames(ndvi) = c("ndvi")
vari = transp("vari");colnames(vari) = c("vari")
vig = transp("vig");colnames(vig) = c("vig")
lwvi2 = transp("lwvi2");colnames(lwvi2) = c("lwvi2")
msi = transp("msi");colnames(msi) = c("msi")
ndii = transp("ndii");colnames(ndii) = c("ndii")
ndwi = transp("ndwi");colnames(ndwi) = c("ndwi")
pssr = transp("pssr");colnames(pssr) = c("pssr")
psri = transp("psri");colnames(psri) = c("psri")
sipi = transp("sipi");colnames(sipi) = c("sipi")
wbi = transp("wbi");colnames(wbi) = c("wbi")
pri = transp("pri");colnames(pri) = c("pri")
rendvi = transp("rendvi");colnames(rendvi) = c("rendvi")
nirv = transp("nirv"); colnames(nirv) = c("nirv")

#Stract treatmant name
treat = df[c(1:11781),]; treat = treat[,c(6,7,8)]

#Join everything
df3 = cbind(treat$parcela,treat$year,evi,ndvi,vari,vig,msi,ndii,ndwi,pssr,psri,sipi,wbi,pri,rendvi,nirv)
colnames(df3)[1] = "Parcela"; colnames(df3)[2] = "year"

#Make data frame by year ==========================================================================
getyear = function(x){
  df3 %>% 
  na.omit() %>% 
  filter(year == x)
}

p2004 = getyear(2004)
p2005 = getyear(2005)
p2006 = getyear(2006)
p2008 = getyear(2008)
p2010 = getyear(2010)
p2011 = getyear(2011)
p2012 = getyear(2012)

#PCA Analysis =====================================================================================
pcax = function(x){
  y1 = c(x[2,2])
  y2 = c("Hyperspectral Indices")
  name = paste(y2, y1, sep = " ", collapse = NULL)
  z = x[,c(-1,-2)]
  pcaz = PCA(z, graph = F)
  grp = as.factor(x[,c(1)])
  fviz_pca_biplot(pcaz, habillage = grp,
                  col.var = "black",
                  geom.ind = c("point"),
                  title = name)
  
}


pcax(p2004)
pcax(p2005)
pcax(p2006)
pcax(p2008)
pcax(p2010)
pcax(p2011)
pcax(p2012)






