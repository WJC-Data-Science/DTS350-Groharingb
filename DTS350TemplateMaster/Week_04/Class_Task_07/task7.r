library(nycflights13)
library(tidyverse)
library(ggbeeswarm)

getwd()

#Getting a feel for the data
flights1
colnames(flights)

head(flights)
tail(flights) #lots of NAs to be weary of

#Getting a feel for the size of the dataset
flights %>% group_by(tailnum) %>% summarise(n()) #4034
flights %>% group_by(carrier) %>% summarise(n()) #16
orig = flights %>% group_by(origin) %>% summarise(n=n()) #3
flights %>% group_by(dest) %>% summarise(n()) #95f

#Trying some graphs, with little success

ggplot(flights,aes(x=year)) + geom_histogram()
#Ah, the data is not slanted towards a particular year.

avgdelays = flights %>% group_by(arr_time) %>% summarise(avg_delay=mean(arr_delay,na.rm=TRUE))
avgdelays = avgdelays %>% filter(is.nan(avg_delay)==FALSE)

ggplot(avgdelays,aes(arr_time,avg_delay)) + geom_point()
#The relationship between arrival time and avg_delay looks roughly linear after about 5:30.

ggplot(flights) + geom_histogram(aes(x=arr_delay)) + facet_wrap(~carrier)
ggplot(flights) + geom_point(aes(y=arr_delay,x=arr_time,color=carrier))


####Finally, something reasonably useful I can pretty up.
ggplot(flights,aes(x=reorder(carrier,distance/air_time),y=distance/air_time*60)) + 
  geom_boxplot(aes() ) + theme_bw()

mph = ggplot(flights,aes(x=reorder(carrier,distance/air_time),y=distance/air_time*60)) + 
  geom_boxplot(aes(fill=carrier)) +
  ggtitle("Mean Trip Speed (by carrier)") + xlab("Carrier") + ylab("Average Trip Speed (mph)") +
  theme_bw() + guides(fill=FALSE)

#Designing a distribution graphic
ggplot(flights,aes(x=distance/air_time))

ggsave = ggplot(flights,aes(y=arr_delay,x=air_time))

mph
 