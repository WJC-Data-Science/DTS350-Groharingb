library(tidyverse)
library(USAboundaries)
library(geofacet)


#Load in data
df = read_csv(url("https://github.com/WJC-Data-Science/DTS350/raw/master/permits.csv"))


#Adding county coordinates
bounds = us_counties() %>% mutate(countyfp = as.integer(countyfp))

permits = left_join(df,bounds,by=c("StateAbbr" = "state_abbr","county"="countyfp"))

  #Verifying proper combination
  length(df$X1)==length(permits$X1) #good
  permits %>% filter(is.na(geometry)) #good



#Visualizing single-family permits in Missouri
  #The permit counts are normalized, so that the change can be seen
  #in smaller counties.
mo = permits %>% filter(StateAbbr=="MO")
mo_sf = mo %>% filter(variable=="Single Family")

mo_sf_normal = mo_sf %>% filter(year>=2000) %>% 
  group_by(county) %>% mutate(peakPermits=max(value),pctOfPeak=value/max(value))


p_mo = ggplot(data=mo_sf_normal) + 
  ggtitle("MO Single-Family Permits Issued, by county (2000-2010)",
          "Permits are expressed as a percentage of the peak in each county, over the given period.") +
  geom_sf(aes(geometry=geometry,fill=pctOfPeak*100)) +
  #geom_sf_text(aes(label=value,geometry=geometry)) +
  labs(fill="%") +
  facet_wrap(~year) +
  theme_minimal()

p_mo


#Creating state level totals by year, and graphing them over time.
  #This shows in absolute terms which states invested most heavily 
  #in single family residential construction.
  
totals = permits %>% 
  group_by(StateAbbr,year,variable) %>%
  summarise(permits=sum(value))

p_us_absolute = ggplot(data=filter(totals,variable=="Single Family")) +
  geom_line(aes(x=year,y=permits)) +
  geom_rect(fill="black",alpha=0.01,xmin=2007,xmax=Inf,ymin=-Inf,ymax=Inf) +
  facet_geo(~StateAbbr) +
  ggtitle("Single-Family Permits Issued by State,1980-2000"," ") +
  xlab("Year (1980-2010)") + ylab("Single Family Permits") +
  theme_bw() +
  theme(
    axis.text.x=element_text(angle=-90,hjust=1),
    panel.grid = element_line(color="light grey")
  )

p_us_absolute

#To get a better sense of trends within each state, it helps to
#normalize the y-axis, so all scales run from 0 to 100% of their
#maximum.
totals_sf = totals %>% 
  filter(variable=="Single Family") %>%
  group_by(StateAbbr) %>%
  summarise(year,SF_permits=permits,peak=max(permits),normalized=permits/max(permits))

ggplot(data=totals_sf) +
  geom_line(aes(x=year,y=normalized)) +
  facet_geo(~StateAbbr)


#I then grouped the states based off of some apparent geographic
#trends. These are somewhat subjective.

east80sPeak = c("NY","MA","NH","NJ","PA","CT","MD","VA","RI")

east80sAndCrisis = c("VT","ME","DE")

seCrisisPeak = c("MS","AL","GA","SC","NC","FL")

south80sCrisisPeak = c("OK","LA","TX")

midAndWest = c(
  "ID","NV","OR","UT","NE","MO","IA","SD",
  "MN","IL","WI","MI","OH","IN","KY","WV","TN","AR","KS",
  "WA"
)

westCluster = c("ND","MT","WY","CO","NM","AZ","UT")

#Assigning colors
c = totals_sf %>% 
  mutate(color = case_when(
    StateAbbr %in% westCluster ~ "forestgreen",
    StateAbbr %in% east80sPeak ~ "lightsteelblue3",
    StateAbbr %in% east80sAndCrisis ~ "blue",
    StateAbbr %in% south80sCrisisPeak ~"red",
    StateAbbr %in% seCrisisPeak ~ "orange",
    StateAbbr %in% midAndWest ~ "gold",
    StateAbbr == "CA" ~ "lightseagreen",
    TRUE ~ "light grey"
  )
  )

#Formatted plot of regional sf permit trends, 1980-2010
p_us_regional = ggplot(data=c) +
  ggtitle("Residential Construction 1980-2010, Single-Family",
          "Scales are normalized, to emphasize trends over time.") +
  xlab("Year (1980-2010)") + ylab("Single Family Permits (normalized)") +
  geom_rect(aes(fill=color),alpha=0.01,xmin=-Inf,xmax=Inf,ymin=0-Inf,ymax=Inf) +
  geom_line(aes(x=year,y=normalized)) +
  geom_rect(fill="black",alpha=0.01,xmin=2007,xmax=Inf,ymin=-Inf,ymax=Inf) +
  facet_geo(~StateAbbr,grid="us_state_grid1") +
  scale_fill_identity() +
  scale_y_continuous(minor_breaks=(0:4)/4,breaks=c(0,1)) +
  theme_bw() +
  theme(
    axis.text.x=element_text(angle=-90,hjust=1),
    panel.grid = element_line(color="light grey")
  )

p_us_regional

#If you zoom in on just the 2000s, you can see that all states had at least somewhat of a decline in SF permits 
#in the direct leadup to the prices. In most cases, this followed several years of increase, although a few states
#were relatively stagnant in this regard.
  #D.C. again proves to be an exception.

p_us_2000s = ggplot(data=filter(totals_sf,year>=2000)) +
  ggtitle("Residential Construction in the 2000s, Single-Family"," ") +
  xlab("Year") + ylab("Single Family Permits") +
  geom_line(aes(x=year,y=normalized)) +
  geom_rect(fill="black",alpha=0.01,xmin=2007,xmax=Inf,ymin=-Inf,ymax=Inf) +
  facet_geo(~StateAbbr,grid="us_state_grid1") +
  scale_x_continuous(minor_breaks=(2000:2010),breaks=c(0:5)*2+2000) +
  scale_y_continuous(breaks=(0:1),minor_breaks=(0:4)/4) +
  theme_bw() +
  theme(
    axis.text.x=element_text(hjust=0,vjust=.5,angle=-90)#angle=-90,hjust=-1),
  )

p_us_2000s


#Saving copies of each plot
ggsave("plot1.png",plot=p_mo,device="png",width=12,height=8,units="in")
ggsave("plot2.png",plot=p_us_absolute,device="png",width=10,height=7,units="in")
ggsave("plot3.png",plot=p_us_regional,device="png",width=10,height=7,units="in")
ggsave("plot4.png",plot=p_us_2000s,device="png",width=10,height=7,units="in")
