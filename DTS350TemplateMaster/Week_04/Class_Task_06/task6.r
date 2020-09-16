library(scales)
library(dplyr)
library(directlabels)
library(tidyverse)
library(ggrepel)


#devtools::install_github("drsimonj/ourworldindata")

decline = read_csv("economic-decline-in-the-second-quarter-of-2020.csv")
names(decline)[3] = "Growth"

filterlist=c('China','NAFTA','OECD - Total','EU','G7')

for (place in filterlist){
  print(place)
  decline = filter(decline,Entity != place)
}

decline = decline %>% arrange(Growth) %>%transform(Entity = paste(Entity," ",round(Growth,digits=1),"% ",sep=""),gradient=Growth)

titletext = "Economic decline in the second quarter of 2020"
subtext ="The percentage decline of GDP relative to the same quarter in 2019. It is adjusted for inflation."
captiontext = "Source: Eurostat,OECD and individual national statistics agencies."

bottomColor = rgb(247,239,71,maxColorValue = 255)
topColor = rgb(49,45,123,maxColorValue = 255)

#Graphing
Economy = ggplot(data=decline,aes(x=reorder(Entity,Growth),y=Growth)) +
  geom_col(aes(fill=gradient)) +
  scale_y_continuous() +
  coord_flip() +
  labs(title=titletext,subtitle=subtext,caption=captiontext) +
  geom_text(aes(y=Growth,hjust="right",label=reorder(Entity,Growth))) +
  theme_minimal() + 
  theme(
    panel.grid.minor=element_line(linetype = "dashed"),
    panel.grid.major=element_line(linetype = "dashed"),
    panel.grid.minor.y=element_blank(),
    panel.grid.major.y=element_blank(),
    axis.text.y = element_blank(),
    axis.title.y = element_blank(),
    axis.title.x = element_blank(),
    legend.position = "none")+
  scale_fill_gradient(low=bottomColor,high=topColor)


df2 = ourworldindata::child_mortality
mort2015 = df2 %>% filter(year == 2015) %>% arrange(child_mort) %>% filter(is.na(continent)==FALSE) %>% filter(is.na(child_mort)==FALSE)

top20names = head(mort2015,20)
bottom20names = tail(mort2015,10)

top20 = df2 %>% filter(country %in% top20names$country)
bottom20 = df2 %>% filter(country %in% bottom20names$country)

mortality = ggplot(data=top20,mapping=aes(x=year,y=child_mort)) + 
  geom_smooth(aes(group=country),color="orange") + geom_smooth(data=bottom20,aes(group=country),color='blue') +
  xlab("Year") + ylab("Child Mortality (log scale)") + ggtitle("Historical Child mortality in 10 highest and lowest states, as of 2015") +
  xlim(1800,2020) +
  ylim(0,750) + scale_y_log10() + theme_bw()
