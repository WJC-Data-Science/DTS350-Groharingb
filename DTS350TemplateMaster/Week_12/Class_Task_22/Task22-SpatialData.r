library(tidyverse) 
library(USAboundaries)
library(USAboundariesData)
library(ggrepel)
library(sf) 

#install packages if necessary
devtools::install_github("ropensci/USAboundaries")
devtools::install_github("ropensci/USAboundariesData")
install.packages("sf")


#Get states excluding Hawaii, Alaska, and Puerto Rico
states_continental = data.frame(name=us_states()$name) %>% 
  filter(name!="Hawaii",name!="Alaska",name!="Puerto Rico")

states_continental=((as.character(states_continental) %>% 
                       str_extract_all("[A-Z]([A-Z]|[a-z]|\\s)+")))[[1]]

#Get tibble containing 3 largest cities in each state
cities = us_cities() %>% group_by(state_name) %>% slice_max(order_by=population,n=3) %>%
  filter(state_name!="Hawaii",state_name!="Alaska",state_name!="Puerto Rico")
#Rank, for dot color
cities = cities %>% group_by(state_name) %>% mutate(rank=max(population)) %>%
  mutate(rank=case_when(
    population==max(population) ~ 1,
    population==min(population) ~ 3,
    TRUE ~ 2
  )
  ) %>% select(city,state_name,population,rank)

#Highest pop. city in each state, for the labels
top_cities = cities %>% slice_max(order_by = population)  %>%
  mutate(x=str_remove(str_extract(geometry[1],"(-)(\\S+)"),",")) %>%
  mutate(y=str_extract(geometry[1],"(?<=\\s)(.+)(?=[:punct:])")) %>%
  select(city,geometry,x,y) %>%
  mutate(x=as.double(x),y=as.double(y))


#Graphing
p=ggplot() + 
  geom_sf(data=us_states(states=states_continental),mapping=aes(),fill=NA,color="#595959") +
  geom_sf(data=us_counties(states="Idaho"),mapping=aes(),fill=NA,color="#595959") +
  geom_sf(data=cities,mapping=aes(size=population/1000,color=rank)) +
  geom_label_repel(data=top_cities,mapping=aes(x=x,y=y,label=city),color="#00008b") +
  labs(size="Population\n(1000)") +
  guides(color=FALSE) +
  theme_bw()

scale=2.7
ggsave("recreation.png",plot=p,device="png",width=42/scale,height=30/scale,units="in")



us_states()
?us_counties()
us_cities()
