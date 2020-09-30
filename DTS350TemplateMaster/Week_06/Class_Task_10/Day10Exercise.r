library(ggplot2)
library(dplyr)
library(nycflights13)

fl_bp <- flights %>%
  ggplot(aes(x = carrier, y = dep_delay))
fl_sc <- flights %>%
  filter(dep_time > 800, dep_time < 900) %>%
  ggplot(aes(x = dep_time, y = dep_delay))

fl_bp + geom_boxplot()
fl_sc + geom_point()

#Exercise 1

#Write the code to observe the first and last 10 rows of 
      #the data in flights.
head(flights,10)
tail(flights,10)

#How many rows are in our data?
flights
  #336,776 rows

#Are there any NAs in our data? If so, in which variables?
  #There has to be a more succinct way to do this...
  #filter() doesn't seem to work with strings of variable names, 
  #or I could just do a for loop through variable.names()

flights %>% filter(is.na(month))            #0
flights %>% filter(is.na(day))              #0
flights %>% filter(is.na(dep_time))         #8245
flights %>% filter(is.na(sched_dep_time))   #0
flights %>% filter(is.na(dep_delay))        #8245
flights %>% filter(is.na(arr_time))         #8703
flights %>% filter(is.na(sched_arr_time))   #0
flights %>% filter(is.na(arr_delay))        #9240
flights %>% filter(is.na(carrier))          #0
flights %>% filter(is.na(flight))           #0
flights %>% filter(is.na(tailnum))          #2502
flights %>% filter(is.na(origin))           #0
flights %>% filter(is.na(dest))             #0
flights %>% filter(is.na(air_time))         #9240
flights %>% filter(is.na(distance))         #0
flights %>% filter(is.na(hour))             #0
flights %>% filter(is.na(minute))           #0
flights %>% filter(is.na(time_hour))        #0

#Yes: dep_time, dep_delay, arr_time, arr_delay, tailnum, 
  #and air_time



#Excercise 2

fl_bp + geom_boxplot() + 
  labs(title="Departure Delay Boxplots by Carrier") + 
  xlab("Carrier Abbreviation") + 
  ylab("Departure Delay (minutes)")

fl_sc + geom_point() +
  labs(title="Departure Delay For Each Departure Time") + 
  xlab("Departure Time") + 
  ylab("Departure Delay (minutes)")



#Exercise 3

final_fl_bp = fl_bp + geom_boxplot() + 
  labs(title="Departure Delay Boxplots by Carrier") + 
  xlab("Carrier Abbreviation") + 
  ylab("Departure Delay (minutes)") +
  coord_cartesian(ylim=c(50,100)) +
  scale_y_continuous(breaks=(1:6)*15)
final_fl_bp


fl_sc + geom_point() +
  labs(title="Departure Delay For Each Departure Time") + 
  xlab("Departure Time") + 
  ylab("Departure Delay (minutes)") +
  coord_cartesian(ylim=c(50,100)) +
  scale_y_continuous(breaks=(1:6)*15) +
  scale_x_continuous(breaks=(1:(860/15))*15)



#Exercise 4
fl_sc + geom_point(aes(color=origin)) +
  labs(title="Departure Delay For Each Departure Time") + 
  xlab("Departure Time") + 
  ylab("Departure Delay (minutes)") +
  coord_cartesian(ylim=c(50,100)) +
  scale_y_continuous(breaks=(1:6)*15) +
  scale_x_continuous(breaks=(1:(860/15))*15) +
  scale_color_brewer(palette="Accent")

#Exercise 5:
final_fl_sc = fl_sc + geom_point(aes(color = origin)) +
  labs(title = "Departure Delay For Each Departure Time") + 
  xlab("Departure Time") + 
  ylab("Departure Delay (minutes)") +
  coord_cartesian(ylim=c(50,100)) +
  scale_y_continuous(breaks=(1:6)*15) +
  scale_x_continuous(breaks=(1:(860/15))*15) +
  scale_color_brewer(palette="Accent") + 
  theme_minimal() + theme(
    axis.text.x=element_text(angle=35)
  )

ggsave("fl_sc.png",final_fl_sc,width=7,height=5,units="in",device=png())
ggsave("fl_bp.png",final_fl_bp,width=7,height=5,units="in",device=png())

final_fl_bp

#Exercise 6

library(viridisLite)

best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)

empty = filter(best_in_class,TRUE==FALSE)

cargraph = ggplot(mpg, aes(displ, hwy,color=class)) +
  geom_point(aes(colour = class),size=4) +
  geom_point(size = 3, shape = 21, fill="white", data = best_in_class) +
  geom_point(data=empty,aes(displ, hwy,color=class),size=4) + #just for fixing the legend
  ggrepel::geom_text_repel(aes(label = model), data = best_in_class, force=10,box.padding = .7,seed=42) +
  xlab("Engine displacement") + ylab("Miles per gallon (highway)") +
  scale_color_viridis_d() +
  theme_bw()

ggsave("cars.png",cargraph,width=7,height=5,units="in",device=png())

