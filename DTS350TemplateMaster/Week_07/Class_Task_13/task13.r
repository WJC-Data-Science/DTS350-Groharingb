library(tidyverse)
library(readr)
library(haven) #rds/dta files
library(readxl)
library(downloader)
library(dplyr)

#.rds
df_rds = read_rds(url("https://github.com/WJC-Data-Science/DTS350/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.RDS"))

#.csv
download(url="https://github.com/WJC-Data-Science/DTS350/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.csv",
         "df_csv.csv",mode="wb")
df_csv = read_csv("df_csv.csv")

#.dta
df_dta = read_dta("https://github.com/WJC-Data-Science/DTS350/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.dta")

#.sav
df_sav = read_sav("https://github.com/WJC-Data-Science/DTS350/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.sav")

#.xlsx
download(url="https://github.com/WJC-Data-Science/DTS350/raw/master/Dart_Expert_Dow_6month_anova/Dart_Expert_Dow_6month_anova.xlsx",
         "df_xlsx.xlsx",mode="wb")
df_xlsx = read_xlsx("df_xlsx.xlsx")

df_rds
df_csv
df_dta
df_sav
df_xlsx


#comparing
?all_equal
all_equal(df_rds,df_csv) #TRUE
all_equal(df_rds,df_dta,convert=TRUE) #TRUE
all_equal(df_rds,df_sav,convert=TRUE) #TRUE
all_equal(df_rds,df_xlsx,convert=TRUE) #TRUE


#Basic plot of returns by stock
averages = df_rds %>% group_by(variable) %>% summarise(value = mean(value))

returns_by_stock = ggplot(data=df_rds) + 
  geom_boxplot(aes(x=variable,y=value,fill=variable),alpha=0.3,outlier.alpha=1) +
  geom_jitter(aes(x=variable,y=value),alpha=0.1) +
  geom_point(data=averages,aes(x=variable,y=value),color="#5555FF",size=4,shape=18) +
  xlab("\n") +
  ylab("6 Month Returns") +
  ggtitle("6 Month Returns by Stock Selection",subtitle) +
  geom_text(data=head(averages,1),aes(x=.8,y=-61,label="Stock"),size=3.5,hjust=1) +
  geom_text(data=head(averages,1),aes(x=.8,y=-67,label=bar_x),size=3.5,hjust=1) +
  geom_text(data=averages,aes(x=variable,y=-67,label=value),color="#5555FF") +
  coord_cartesian(ylim=c(-50,75),clip='off') +
  theme_bw() +
  theme(
    legend.position = "none",
    plot.subtitle = element_text(color="#5555FF"),
    plot.margin = unit(c(.1,.1,.2,.1),"lines")
  )

#Tidying contest_period
df_tidy = df_rds %>% 
  separate(contest_period,into=c("month_start","end"),sep="-") %>%
  separate(end,into=c("month_end","year_end"),sep=-4)

saveRDS(df_tidy,file="df_tidy.rds")

#six-month returns by year

yearly_averages = df_tidy %>% group_by(year_end) %>% summarise(value=mean(value))

returns = ggplot() + #geom_line(data=yearly_averages,aes(x=year_end,y=value,group=1),size=1) + 
  geom_boxplot(data=df_tidy,aes(x=year_end,y=value,fill=variable),alpha=0.3) + #,alpha=0.7,fill="#E6E6E6",color="#777777") +
  facet_wrap(~variable,ncol=1) +
  ylab("6 Month Return") + xlab("Collection Year") + ggtitle("Six Month Returns by Year of Collection") +
  theme_bw() +
  theme(legend.position = 'none')
  
#DJIA spread table

DJIA = df_tidy %>% 
  filter(variable=="DJIA") %>%
  select(month_end,year_end,variable,value) %>%
  pivot_wider(names_from=year_end,values_from=value) %>%
  head(12) #not the nicest solution...

DJIA$month_end = factor(DJIA$month_end,
                levels=c(
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December"))

DJIA = arrange(DJIA,month_end)

DJIA
