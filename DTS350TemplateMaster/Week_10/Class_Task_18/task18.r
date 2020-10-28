library(tidyverse)
library(dplyr)
library(lubridate)
library(riem)

?lubridate

df = read_delim("https://github.com/WJC-Data-Science/DTS350/raw/master/carwash.csv",delim=",")
df = df %>% mutate(hour=ceiling_date(time,"hour"))

sales_hourly = df %>% group_by(hour) %>% summarise(total=sum(amount)) %>% arrange(total)


#Read in temperatures
min_date = summarise(df,min(hour))[[1]] %>% floor_date("day")
max_date = summarise(df,max(hour))[[1]] %>% floor_date("day")

temps = riem_measures(station = "RXE",  date_start  = min_date,  date_end  =  max_date)
temps = temps %>% mutate(hour=floor_date(ymd_hms(valid),"hour"))

temps_hourly = temps %>% filter(is.na(tmpf)==FALSE) %>% group_by(hour) %>% summarise(mean_temp=mean(tmpf))

#merge
hourly = left_join(sales_hourly,temps_hourly,c("hour"="hour"))

#Add column for mountain time
hourly = hourly %>% mutate(utc=hour,mt_time = with_tz(hour,"MST")) %>% select(utc,mt_time,total,mean_temp)

#Combine the days, so data is just by hour
hourly = hourly %>% filter(is.na(mean_temp)==FALSE) %>% mutate(hour=format(mt_time,"%H:%M")) %>% group_by(hour) %>% summarise(mean_temp=mean(mean_temp),mean_total_sales=mean(total))

\
#graph
p = ggplot(data=hourly,aes(x=hour,y=mean_total_sales)) + 
  geom_point(aes(color=mean_temp),size=5) + theme_bw() +
  geom_text(aes(label=str_c(round(mean_temp,1),"°F")),nudge_y=6) +
  ylab("Mean Hourly Sales") + xlab("Hour (Mountain Time)") + 
  ggtitle("SplashandDash Average Hourly Sales vs Average Temperature by Hour") +
  labs(color="Temp") +
  scale_color_distiller(palette="Oranges",direction=1)

p

ggsave("hourly.png",device=png(),width=7,height=5,units="in)
