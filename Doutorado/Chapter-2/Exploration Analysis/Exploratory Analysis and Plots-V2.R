#Exploratory Analysis and Plots V2
#Blowdown Data (AREA-1)
#Eduardo Q Marques 25-05-2020

library(tidyverse)
library(reshape2)
library(ggplot2)
library(fmsb)

#Load data
setwd('C:/Users/Eduardo Q Marques/Documents/My Jobs/Doutorado/Deposito/Banco de Dados Tanguro/Area1-plot/Campo vento')

df = read.csv("storm_data_full_C.csv", sep = ",")

#Resume data
df = df[,c(3,4,5,6,7,8,9,10,11,12)]
df$nt = 1
colnames(df) = c("Specie","Treatment","Line","Transect","Condition","Alt_Scar","Wind?","Direction","Damage","Alt_Broken","Number_of_Trees")


#Summary information
summary(df)

#Plot data
#Orverview ---------------------------------------------------------------------------------
#Damage by plot down on wind
ggplot(df, aes(x=Treatment))+
  geom_bar(position = "dodge", fill = "darkblue", alpha = 0.5)+
  ggtitle("Number of damage by plot down on wind")


#Kind of damage data
ggplot(df, aes(x=Damage, fill = Treatment))+
  geom_bar(position = "dodge", fill = "darkblue", alpha = 0.5)+
  ggtitle("Kind of damage data")

#Kind of damage by treatment
ggplot(df, aes(x=Damage))+
  geom_bar(position = "dodge", fill = "darkblue", alpha = 0.5)+
  facet_wrap(~Treatment)+
  ggtitle("Kind of damage by treatment")

#Fall direction
ggplot(df, aes(x=Direction))+
  geom_density(col = "black", fill = "darkblue", alpha = 0.5)+
  theme_minimal()+
  ggtitle("Direction the trees fell (Degrees)")

wind = df %>% 
  group_by(Direction) %>% 
  summarise(Number_of_Trees = sum(Number_of_Trees)) %>% 
  na.omit()
wind$Direction = as.factor(wind$Direction)

ggplot(wind, aes(x=Direction, y = Number_of_Trees, fill = Number_of_Trees))+
  geom_bar(stat="identity")+
  theme_minimal()+
  theme(
    axis.text.y = element_blank(),
    axis.title = element_blank())+
  coord_polar(start = 0)+
  ggtitle("Direction the trees fell (Degrees)")

library(plotly)

gg = ggplot(df, aes(x=Direction))+
  geom_density(col = "black", fill = "darkblue", alpha = 0.5)+
  theme_minimal()+
  coord_polar(start = 0)+
  ggtitle("Direction the trees fell (Degrees)")

ggplotly(gg)

#Popular trees was broken? -----------------------------------------------------------------
pop_tree = df %>% 
  group_by(Specie) %>% 
  summarise(Number_of_Trees = sum(Number_of_Trees)) %>% 
  filter(Number_of_Trees >= 10)

ggplot(pop_tree, aes(x=Specie, y=Number_of_Trees))+
  geom_bar(position = "dodge", stat = "identity",
           fill = "darkblue", alpha = 0.5)+
  theme_minimal()+
  theme(axis.text.x = element_text(angle=45))+
  ggtitle("Most damage trees (>=5)")

#By treatment
plot_tree = df %>% 
  group_by(Treatment, Specie) %>% 
  summarise(Number_of_Trees = sum(Number_of_Trees)) %>% 
  filter(Number_of_Trees >= 5)

ggplot(plot_tree, aes(x=Specie, y=Number_of_Trees))+
  geom_bar(position = "dodge", stat = "identity",
           fill = "darkblue", alpha = 0.5)+
  facet_wrap(~Treatment, scales = "free")+
  theme(axis.text.x = element_text(angle=45))+
  ggtitle("Most damage trees by treatment (>=5)")

#By kind of damage
brok_tree = df %>% 
  group_by(Damage, Specie) %>% 
  summarise(Number_of_Trees = sum(Number_of_Trees)) %>% 
  filter(Number_of_Trees >= 4)

ggplot(brok_tree, aes(x=Specie, y=Number_of_Trees))+
  geom_bar(position = "dodge", stat = "identity",
           fill = "darkblue", alpha = 0.5)+
  facet_wrap(~Damage, scales = "free")+
  theme(axis.text.x = element_text(angle=45))+
  ggtitle("Most damage trees by kind of damage (>=4)")

#Trees with fire scar (It is the old trees) ------------------------------------------------
#How much broken? (Number_of_Trees and percentege)
scar = df %>% 
  group_by(Condition, Treatment) %>% 
  summarise(Number_of_Trees = sum(Number_of_Trees))

scar$percent = c(57,62,99,43,38,1)

ggplot(scar, aes(x=Condition, y=Number_of_Trees, fill = Condition))+
  geom_bar(position = "dodge", stat = "identity")+
  geom_text(aes(x=Condition, y=percent, label = paste0(percent,"%"))) +
  facet_wrap(~Treatment)+
  ggtitle("Number of scarred trees")


#Have similar alt of broken and alt of scar?
scar2 = df %>% 
  filter(Condition == "Scar") %>% 
  filter(Damage == "Broken")

ggplot(scar2, aes(x=Alt_Broken, y=Alt_Scar))+
  geom_point()+
  stat_smooth(method = "gam")+
  theme_minimal()+
  ggtitle("Scar height X Break height")

#Similarity closer to 0 is better!
scar3 = scar2 %>%
  mutate(proximity = c(Alt_Broken - Alt_Scar))

ggplot(scar3, aes(x=proximity))+
  geom_density(col = "black", fill = "darkblue", alpha = 0.5)+
  theme_minimal()+
  ggtitle("Proximity of the break point with the scar")












