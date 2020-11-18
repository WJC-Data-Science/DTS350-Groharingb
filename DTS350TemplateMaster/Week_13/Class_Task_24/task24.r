library(tidyverse)
library(leaflet)
library(USAboundaries)
library(USAboundariesData)
library(sf)

states = us_states()$stusps
cities = us_cities(states=states)

top3 = cities %>% 
  filter(!state_name %in% c("Alaska","Hawaii","Puerto Rico")) %>%
  group_by(state_name) %>%
  slice_max(order_by=population,n=3) %>%
    mutate(rank=case_when(
    population==max(population) ~ 1,
    population==min(population) ~ 3,
    TRUE ~ 2
  )) %>%
  group_by(state_name,city) %>%
  mutate(long=geometry[[1]][1],lat=geometry[[1]][2])


dots = top3 %>% 
  select(city,state_name,population) %>%
  mutate(
    dot_size = (population-min(top3$population)) / (max(top3$population)-min(top3$population))
  ) %>%
  mutate(dot_size = (dot_size * 9)+1)


colors=top3 %>% mutate(color=case_when(
  rank==1~"#104e8b",
  rank==2~"#1e90ff",
  rank==3~"#bfefff"
))

state_lines = us_states() %>% filter(!state_name %in% c("Alaska","Hawaii","Puerto Rico"))
idaho_lines = us_counties() %>% filter(state_name=="Idaho")
lines = rbind(select(state_lines,geometry),
              select(idaho_lines,geometry))


######################
#   Plotting
######################

leaflet(data=lines) %>%
  addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
  addProviderTiles(providers$CartoDB.Positron,group="Map Labels") %>%
  addPolygons(stroke = TRUE,fill=TRUE,fillOpacity=0,
              opacity=1,color="#595959",weight=1,
              highlightOptions = highlightOptions(color="#00008b",weight=2.5)) %>%
  addCircleMarkers(
    lng=top3$long,
    lat=top3$lat,
    label=str_c(top3$city,", ",top3$state_abbr),
    popup=str_c("<b><font color='00008b'>",top3$city,", ",top3$state_name,
                "</font></b><br>Population ",formatC(top3$population,big.mark=","),
                "<br><em>Source: ",top3$city_source,"</em>"),
    popupOptions(),
    opacity=1,
    fillOpacity=1,
    radius=dots$dot_size,
    color=colors$color,
    labelOptions = labelOptions(
      noHide = F,
      direction = "bottom",
      style=list(
        "color"="#00008b",
        "border=color"="#00008b")
    )
  ) %>%
  addLayersControl(
    overlayGroups = c("Map Labels"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>% hideGroup("Map Labels")
