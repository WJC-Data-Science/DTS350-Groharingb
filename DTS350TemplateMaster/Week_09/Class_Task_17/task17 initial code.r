library(tidyverse)
library(dplyr)
library(forcats)
library(stringr)

stocks=read_rds(url("https://github.com/WJC-Data-Science/DTS350-Groharingb/raw/master/DTS350TemplateMaster/Week_07/Class_Task_13/df_tidy.rds"))

#Add a month-year column and set its levels to the current order.
stocks = stocks %>% 
  mutate(monthyear = str_c(month_end," ", year_end)) %>%            #Create a combined month-year column
  mutate(monthyear=fct_inorder(monthyear)) %>%                      #Make it an ordered factor
  arrange(monthyear) %>%                                            #Rearrange the dataset by monthyear
  mutate(variable=factor(variable,levels=c("PROS","DARTS","DJIA"))) #Ensure DJIA will be last in the stock
  #Putting DJIA on the bottom emphasizes its contrast with the other two.

#To reduce visual clutter, I used abbreviations for months, and included
#the year only on January.
stocks = stocks %>% mutate(month_abbr=
  case_when(
    month_end == "June" ~ "Jun ",
    month_end == "July" ~ "Jul ",
    month_end == "August" ~ "Aug ",
    month_end == "September" ~ "Sept ",
    month_end == "October" ~ "Oct ",
    month_end == "November" ~ "Nov ",
    month_end == "December" ~ "Dec ",
    month_end == "January" ~ str_c("Jan ","",year_end),
    month_end == "February" ~ "Feb ",
    month_end == "March" ~ "Mar ",
    month_end == "April" ~ "Apr ",
    month_end == "May" ~ "May"
  )
)



#Putting the labels in a convenient vector
abbr=stocks %>% arrange(monthyear) %>% filter(variable=="PROS") %>% select(month_abbr)

#I want my labels, except january, to be a less distracting grey.
axiscolors = abbr %>% mutate(
  color=case_when(
    str_detect(month_abbr,"Jan.") ~ "#262626",
    TRUE ~ "#B3B3B3"
  )
) %>% select(color)

#Lastly, a list of x-values for Januaries, so I can add vertical lines between the years:
jan = stocks %>% filter(variable=="PROS") %>%
  filter(str_detect(monthyear,"Jan|June\\s1990")) %>%
  select(monthyear)

#Putting it all together:
ggplot(data=stocks,aes(x=monthyear,y=value)) +
  geom_point() +
  facet_wrap(~variable,nrow=3) +
  scale_x_discrete(labels=abbr[[1]],drop = FALSE) +
  geom_vline(alpha=0.4,xintercept = jan[[1]][2:length(jan[[1]])],linetype=2) +
  ggtitle("6 Month Returns by Stock Selection") +
  xlab("Month of Collection") + ylab("6-Month Return") +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle=-70,hjust=0,vjust=0,color=axiscolors[[1]])
  )

#Adding drop = FALSE to scale_x_discrete() doesn't affect anything/ If monthyear had unused levels,
#this would add extra ticks to my x-axis. I created monthyear and set its levels, so this isn't a problem
#in my graph.

#Saving to file
ggsave("Stocks.png",last_plot(),device="png",width=9.5,height=5,units="in")

