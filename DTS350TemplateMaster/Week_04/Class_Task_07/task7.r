library(nycflights13)
library(tidyverse)

getwd()

#######################################################
#Finding a relationship
#######################################################
#Getting a feel for dataset
flights
head(flights)
tail(flights) #lots of NAs to be weary of
colnames(flights)

#Looking at levels within caegorical variables.
flights %>% group_by(tailnum) %>% summarise(n()) # n=4034
flights %>% group_by(carrier) %>% summarise(n()) # n=16
flights %>% group_by(origin) %>% summarise(n=n()) #n=3
flights %>% group_by(dest) %>% summarise(n()) # n=95
flights %>% group_by(month) %>% summarise(n()) # n=12

#SBuilding exploratory graphs, to see if I can find any relationships:
avgdelays = flights %>% group_by(arr_time) %>% summarise(avg_delay=mean(arr_delay,na.rm=TRUE))
avgdelays = avgdelays %>% filter(is.nan(avg_delay)==FALSE)
ggplot(avgdelays,aes(arr_time,avg_delay)) + geom_point()
    #Note the periodic gaps in arr_times, roughly 1/hour. I'm guessing this has to do with the spacing of
    #scheduled landing times?
#This doesn't otherwise look promising.

#Here's an idea: We have both flight duration and distance columns. I could divide these to get a rough "speed" for each flight.
#flights has 356k rows. For test geom_point() plots, I'm limiting that with head() (minimizes loading time and computer melting).

ggplot(head(flights,20000),aes(y=distance/air_time*60,x=carrier)) + geom_point()
#Looks like each carrier has its own distribution of "speeds"; I could rank them, get the best and worst,
  #compare variance, etc.

ggplot(head(flights,20000),aes(y=distance/air_time*60,x=dest)) + geom_point()
#Likewise with destination. There's probably too many distributions for one plot, though. 

ggplot(flights[sample((1:300000),10000),],aes(y=distance/air_time*60,x=month)) + geom_point()
ggplot(flights[sample((1:300000),10000),],aes(y=distance/air_time*60,x=day)) + geom_point()
#Distributions look fairly consistent throughout the week and month to month... 
  #Was cool to figure out random sampling, though:
      flights[c(1:4),] # [row,col]
      flights[c(1,8,300000),]
      flights[sample((1:300000),10000),]

#speed vs departure time. Are pilots speeding up to compensate for late departure times?
ggplot(flights[sample((1:300000),10000),],aes(x=dep_delay,y=distance/air_time*60)) + geom_point() + xlim(0,100)

#######################################################
#Distributional Summary: "Trip Speed"
#######################################################

basep = ggplot(flights,aes(x=distance/air_time*60))

#Comparing graphic type.
basep + geom_density()
basep + geom_histogram(binwidth=30)

  #Overall shape is easier to read on a density plot at a glance, but the y axis is unintuitive.
  #I could easily tell you that this data peaks to the right of 400 mph, but I couldn't relate that to actual flight counts.
  #So, histogram wins.

binw = 24
distrPlot = basep + geom_histogram(binwidth=binw,fill="#395C7C") + coord_flip() + 
  xlab("Miles per Hour") + ylab("Total Flights") + ggtitle("Distribution of Trip Speed Across Flights",subtitle="\'Trip Speed\' = Miles Traveled / Flight Duration") +
  scale_y_continuous(breaks=(0:4)*15000,minor_breaks=(0:8)*7500,expand=c(.03,.03)) + 
  scale_x_continuous(breaks=(0:6)*100,expand=c(0,0),limits=c(0,700)) +
  theme_bw()

#######################################################
# Bivariate summary: Departure Time versus "Trip Speed"
#######################################################

meanDelay = flights %>% mutate(speed=distance/air_time*60) %>% group_by(dep_delay) %>% summarise(speed = mean(speed,na.rm=TRUE))

  #For quicker testing, swap this out:
  #  flights[sample((1:300000),10000),]
bivariate = ggplot(flights,aes(x=dep_delay,y=distance/air_time*60)) +
  geom_point(color="#CBCBCB") + 
  ggtitle("Departure vs Trip Speed") +
  xlab("Departure Delay (minutes)") + ylab("Trip Speed (mph)") +
  geom_point(data=meanDelay,aes(x=dep_delay,y=speed),alpha=0.7,size=1.4) +
  scale_y_continuous(limits=c(100,600),expand=c(0,0),breaks=(1:6)*100) +
  scale_x_continuous(limits=c(0,500),expand=c(0,0)) +
  theme_bw()

distrPlot
bivariate

"The distribution graphic is a histogram of all flights in the dataset, binned based on their trip speed (miles traveled
divided by flight duration). I chose a histogram over a density or violin plot, since 'counted flights' is more tangible
to the reader than 'density.' Having the flight counts also gives you a general sense of how large the dataset is. The downside is that the shape of the distribution is a little less
obvious on a histogram, but I'm ok with that tradeoff.

The bivariate graphic plots trip speed against departure time. The raw flight counts are plotted in the background, while average
speed by minute is emphasized in the foreground. Interestingly, trip speed does not appear to increase with departure delay, meaning 
late pilots are generally not flying faster to compensate for delays. That's probably for the best.
"

#Quote from the reading:
"If the data set is really big, I usually take a carefully chosen random subsample to make it possible to do my exploration interactively like @richardclegg"
      #This turned out to be pretty relevant when trying to plot the plane data.
      

ggsave("DistributionalSummary.png",distrPlot,device=png(),width=7,height=5,units="in")
ggsave("Bivariate.png",bivariate,device=png(),width=7,height=5,units="in")
