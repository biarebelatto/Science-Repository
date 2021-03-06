#==========================================================#
# PCA Hyperspectral Indices  by Years                      #
# and PCA Hyperspectral and Multispectral Indices Together #                                       
#                                                          #
# Eduardo Q Marques 17-11-2020                             #
#==========================================================#

#OBS: Almost like version 3, add PCAs for both sensor mult and hyper together

library(stats)
library(tidyverse)
library(reshape2)
library(FactoMineR)
library(factoextra)

#Data =============================================================================================
setwd("C:/Users/Eduardo Q Marques/Documents/My Jobs/Doutorado/Banco de Dados Tanguro/Dados para analise cap1")

hy = read.csv("Hyperion_indexs_all_xy.csv", sep = ',')

land = read.csv("Landsat_indexs_all_xy.csv", sep = ',')

#For Hyperpectral data ============================================================================
#Transform data for analysis
hy2 = hy[c(5,7)]
#hy2$value = log(hy2$value)

#Transpor variables in columns
transp = function(x){
  z = hy2 %>% 
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
treat = hy[c(1:11781),]; treat = treat[,c(6,7,8)]

#Join everything
hy3 = cbind(treat$parcela,treat$year,evi,ndvi,vari,vig,msi,ndii,ndwi,pssr,psri,sipi,wbi,pri,rendvi,nirv)
colnames(hy3)[1] = "Parcela"; colnames(hy3)[2] = "year"

#Make data frame by year
getyear = function(x){
  hy3 %>% 
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

#PCA Analysis
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

#PCA for all years together
hy4 = na.omit(hy3)
hy4b = hy4[,c(-1,-2)]
pcaz = PCA(hy4b, graph = F)
grp = as.factor(hy4[,c(1)])
fviz_pca_biplot(pcaz, habillage = grp,
                col.var = "black",
                geom.ind = c("point"),
                title = "Hyperspectral Indices All Years")



#For Landsat data ============================================================================
#Transform data for analysis
land2 = land[c(6,8)]

#Transpor variables in columns
transp = function(x){
  z = land2 %>% 
    filter(index == x)
  z = as.data.frame(z[,c(2)])
}

evi = transp("evi2");colnames(evi) = c("land_evi")
ndvi = transp("ndvi");colnames(ndvi) = c("land_ndvi")
vig = transp("vig");colnames(vig) = c("land_vig")
ndii = transp("ndii");colnames(ndii) = c("land_ndii")

#Stract treatmant name
treat = land[c(1:116688),]; treat = treat[,c(7,8,9)]

#Join everything
land3 = cbind(treat$treat,treat$year,evi,ndvi,vig,ndii)
colnames(land3)[1] = "Parcela"; colnames(land3)[2] = "year"

#PCA for all years together
land4 = na.omit(land3)
land4b = land4[,c(-1,-2)]
pcaz = PCA(land4b, graph = F)
grp = as.factor(land4[,c(1)])
fviz_pca_biplot(pcaz, habillage = grp,
                col.var = "black",
                geom.ind = c("point"),
                title = "Multispectral Indices All Years")

#Match Hyperion and Lansat data ===================================================================
#Match Landsat and Hyperion period
land3$year = substr(land3$year, 1, 4)

land5 = land3 %>% 
  filter(year %in% c(2004, 2005, 2006, 2008, 2010, 2011, 2012)) %>% 
  unite("id", Parcela, year, sep = "_")

hy5 = hy3 %>% 
  unite("id", Parcela, year, sep = "_")

df = full_join(hy5, land5, id = "id")
df2 = df %>% 
  na.omit() %>% 
  separate(id, c("Parcela", "year"), sep = "_")


#PCA for all Sensors

df3 = df2[,c(-1,-2)]
pcaz = PCA(df3, graph = F)
grp = as.factor(df2[,c(1)])
fviz_pca_biplot(pcaz, habillage = grp,
                col.var = "black",
                geom.ind = c("point"),
                title = "Mult and Hyper Indices (2004-2012)")




















