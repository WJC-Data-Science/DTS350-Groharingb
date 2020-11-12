library(tidyverse) 
library(dplyr)
library(lubridate)
library(ggrepel)
library(stringr)

df = read_csv("Palmer_family_height.csv")

heights = df %>% mutate(date=mdy(date)) %>%
  mutate(birthday = case_when(
    name == "Kaylene" ~ "1982-11-05",
    name == "Kent" ~ "2004-03-10",
    name == "Mary" ~ "2006-04-01",
    name == "Melody" ~ "2008-11-23",
    name == "Ryan" ~ "2011-10-31",
    name == "Tyson" ~ "2013-10-31"
  )) %>%
  mutate(birthday=ymd(birthday)) %>%
  mutate(age = date-birthday) %>%
  mutate(age_years = as.double.difftime(age)/365)

labelpos = heights %>% group_by(name) %>% summarise(age_years=max(age_years),height=max(height))

p1 = ggplot() + 
  geom_line(data=heights,aes(x=age_years,y=height,group=name,color=name)) +
  geom_point(data=heights,aes(x=age_years,y=height,group=name,color=name),alpha=0.2) +
  geom_text_repel(data=labelpos,aes(x=age_years,y=height,label=name,color=name),hjust=0) +
  guides(color=FALSE) +
  labs(y="Height (inches)",x="Age (yrs)",title="Palmer Family Height by Age") +
  theme_bw()


#Question 2: When do they tend to take these measurements?
df2 = df %>% mutate(date = mdy(date)) %>%
  mutate(month=month(date),day=day(date),yearday=yday(date))

yeardistr = df2 %>% group_by(yearday,name) %>% summarise(n=n())

yeardays = c()
for (i in (1:12)){
  date = mdy(str_c(i,"-1-19")) 
  yeardays = append(yearday,yday(date))
}

month_names = c("Jan","Feb","Mar","Apr", "May", "Jun", "July", 'Aug', "Sept", "Oct", "Nov", "Dec","dec")
month_titles = data.frame(yeardays,month_names) %>% head(12)


p2 = ggplot() +
  geom_col(data=yeardistr,aes(x=yearday,y=n)) +
  scale_x_continuous(breaks=yeardays) +
  scale_y_continuous(breaks=(0:3)*2,minor_breaks = (0:0)) +
  geom_text(data=month_titles,aes(x=yeardays,y=-.4,label=month_names)) +
  labs(title="Dates of measurement throughout the year",subtitle='Combined data, 1984-2019',x="",y="Counts") +
  theme_minimal()

#The Palmer family tends to measure heights around the turning of the month.

ggsave("Height-By-Age.png",plot=p1,device="png",width=7,height=5,units="in")
ggsave("Measurement-Timing.png",plot=p2,device="png",width=7,height=5,units="in")
