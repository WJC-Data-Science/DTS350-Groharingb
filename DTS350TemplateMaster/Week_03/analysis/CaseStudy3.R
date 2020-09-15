library(tidyverse)
library(dplyr)

getwd()

#download.file("https://moodle.jewell.edu/mod/resource/view.php?id=158951","CensusAtSchool.csv")
#Downloading files in code off of Moodle seems hit or miss.
#On a failure, this will save a copy of the login page and try to read it like a csv...

df= read_csv("CensusAtSchool.csv")
tail(df) #two weird rows, probably some kind of formatting? Neither has "region"
(df = filter(df,is.na(Region) == FALSE)) #So, easy to filter out

df_inch = transform(df,
          Height=Height/2.54,
          Foot_Length=Foot_Length/2.54,
          Arm_Span=Arm_Span/2.54
          )

df_environment = filter(df,
                        Importance_reducing_pollution>750 | 
                        Importance_recycling_rubbish>750 |
                          Importance_conserving_water>750 |
                          Importance_saving_enery>750 |
                          Importance_owning_computer>750 |
                          Importance_Internet_access > 750,
                        na.rm=TRUE) %>% arrange(Ageyears)

df_extra = select(df,Country:Favourite_physical_activity)

df_numbers = group_by(df,Country) %>% 
  summarise(
    mean_importance_reducing_pollution = mean(Importance_reducing_pollution,na.rm=TRUE),
    mean_importance_recycling_rubbish = mean(Importance_recycling_rubbish,na.rm=TRUE),
    mean_importance_conserving_water = mean(Importance_conserving_water,na.rm=TRUE),
    mean_importance_saving_enery = mean(Importance_saving_enery,na.rm=TRUE),
    mean_importance_owning_computer = mean(Importance_owning_computer,na.rm=TRUE),
    mean_importance_Internet_access = mean(Importance_Internet_access,na.rm=TRUE),
  )

dfM = filter(df,Gender == "M") %>% group_by(Country) %>% summarise(nMales=n())
dfF = filter(df,Gender == "F") %>% group_by(Country) %>% summarise(nFemales=n())
df_numbers$nFemales = dfF$nFemales
df_numbers$nMales = dfM$nMales
df_numbers %>% select(Country,nFemales,nMales,everything())

df_gender = group_by(df,Country,Gender) %>% 
  summarise(
    mean_importance_reducing_pollution = mean(Importance_reducing_pollution,na.rm=TRUE),
    standdev_importance_reducing_pollution = sd(Importance_reducing_pollution,na.rm=TRUE),
    mean_importance_recycling_rubbish = mean(Importance_recycling_rubbish,na.rm=TRUE),
    standdev_importance_recycling_rubbish = sd(Importance_recycling_rubbish,na.rm=TRUE),
    mean_importance_conserving_water = mean(Importance_conserving_water,na.rm=TRUE),
    standdev_importance_conserving_water = sd(Importance_conserving_water,na.rm=TRUE),
    mean_importance_saving_enery = mean(Importance_saving_enery,na.rm=TRUE),
    standdev_importance_saving_enery = sd(Importance_saving_enery,na.rm=TRUE),
    mean_importance_owning_computer = mean(Importance_owning_computer,na.rm=TRUE),
    standdev_importance_owning_computer = sd(Importance_owning_computer,na.rm=TRUE),
    mean_importance_Internet_access = mean(Importance_Internet_access,na.rm=TRUE),
    standdev_importance_Internet_access = sd(Importance_Internet_access,na.rm=TRUE)
  ) #NAs in mean cols are groups with literally no responses for that variable

df_region = group_by(df,Country,Region) %>% 
  summarise(
    mean_importance_reducing_pollution = mean(Importance_reducing_pollution,na.rm=TRUE),
    mean_importance_recycling_rubbish = mean(Importance_recycling_rubbish,na.rm=TRUE),
    mean_importance_conserving_water = mean(Importance_conserving_water,na.rm=TRUE),
    mean_importance_saving_enery = mean(Importance_saving_enery,na.rm=TRUE),
    mean_importance_owning_computer = mean(Importance_owning_computer,na.rm=TRUE),
    mean_importance_Internet_access = mean(Importance_Internet_access,na.rm=TRUE),
  )
df_region %>% 
  transform(net_opinion = sum(mean_importance_reducing_pollution,mean_importance_recycling_rubbish,mean_importance_conserving_water,mean_importance_saving_enery,mean_importance_owning_computer,mean_importance_Internet_access)/6) %>%
  arrange(desc(net_opinion))

group_by(df_region,desc(net_opinion))

df_histogram = rbind(
  transform(df,Country,Importance = Importance_reducing_pollution,Goal="Reducing Pollution") %>% select(Country,Importance,Goal),
  transform(df,Country,Importance = Importance_recycling_rubbish,Goal="Recycling Trash") %>% select(Country,Importance,Goal),
  transform(df,Country,Importance = Importance_conserving_water,Goal="Conserving Water") %>% select(Country,Importance,Goal),  
  transform(df,Country,Importance = Importance_saving_enery,Goal="Saving Energy") %>% select(Country,Importance,Goal),
  transform(df,Country,Importance = Importance_owning_computer,Goal="Owning a Computer") %>% select(Country,Importance,Goal),
  transform(df,Country,Importance = Importance_Internet_access,Goal="Internet Access") %>% select(Country,Importance,Goal)
)


#-------------------
# Generating Plots
#-------------------

#df_histogram = filter(df_histogram,Goal == "Conserving Water")

opinionHist = ggplot(df_histogram,aes(x=Importance,group=Goal,color=Goal)) + 
  geom_freqpoly(aes()) + xlim(0,1000) + facet_wrap(~Goal) +
  ggtitle("Opinion Distribution by Issue") +
  ylab("Number of Respondents") +
  xlab("Importance") + 
  theme_bw() + theme(legend.position="none")

ggsave("histogram.png",
         plot=opinionHist,
         device="png",
         width=15,height=5,
         units="in")



