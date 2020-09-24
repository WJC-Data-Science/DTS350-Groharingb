library(tidyverse)
library(dplyr)

getwd()


###########################################
# What global trends can be observed in carbon emissions by country?
###########################################
#Dataset: OurWorldInData Climate Change dataset

cc_df = read_csv("co2-data-master/owid-co2-data.csv")
view(cc_df)

cc_df

get_all_vars(cc_df)

#Identifications of missing data
naDF = cc_df %>% filter(is.na(consumption_co2)) %>% filter(as.numeric(year) > 1990) %>% group_by(country) %>% summarise(na_count = n()) %>% arrange(desc(na_count))
naDf = filter(naDF,na_count > 10)
ggplot(naDF,aes(x=country,y=na_count),order=count) + geom_col()

ggplot(naDF,aes(x=country,y=na_count),order=count) + geom_col() + ggtitle("Years without data since 1990")
ggplot(head(naDF,10),aes(x=country,y=na_count),order=count) + geom_col() + ggtitle("Years without data since 1990")

#Top emitting countries
by_country = cc_df %>% filter(country != "World") %>% arrange(desc(share_global_co2)) %>% filter(is.na(iso_code)==FALSE) %>% filter(year==2018)

ggplot(head(by_country,20),aes(x=country,y=share_global_co2,order=share_global_co2)) + geom_col() + theme_bw()

#Challenges:
  #Significant numbers of not-answered cells (could cut down by limiting time span)
  #There are going to be diverse factors at play in different countries; it would be nice to have some measurement of
    #industrialization, economy size (besides GDP), government investment in climate science, etc.
  #I might need to learn how to make map visualizations, unless I want lots of tables.

#############################
# How are civilian complaints distributed in ProPublica's NYPD allegations database?
#Or: what insights can be gained from the release of Propublica's allegations database?
#############################

#ProPublica New York police data
df = read_csv("CCRB-Complaint-Data_202007271729/allegations_202007271729.csv")

View(df %>% group_by(unique_mos_id) %>% summarise(count=n()) %>% arrange(desc(count)))
#There are 109 types of allegation listed, with at least 1000 cases per top 10 reason.
#So these categorizations aren't so specific as to be useless. 
  #(if anything, the lack of specficity is frustrating)

get_all_vars(df)

df %>% group_by(shield_no) %>% summarise(count=n()) %>% arrange(desc(count))
df %>% group_by(shield_no,last_name,first_name) %>% summarise(count=n()) %>% arrange(desc(count))
df %>% group_by(shield_no,last_name,first_name,command_now) %>% summarise(count=n()) %>% arrange(desc(count))


#How to sort by officer?
  #Some officers don't have their badges # entered, and a fair number have '0' listed as their badge
  #The nypd is certainly large enough for meaningful numbers of duplicate names to appear.
  #Each of the following gives a different number of rows. 

df %>% group_by(shield_no) %>% summarise(count=n()) %>% arrange(desc(count))
df %>% group_by(shield_no,last_name,first_name) %>% summarise(count=n()) %>% arrange(desc(count))
df %>% group_by(shield_no,last_name,first_name,precinct) %>% summarise(count=n()) %>% arrange(desc(count)) #huge increase. people move- who knew?
df %>% group_by(shield_no,last_name,first_name,command_now) %>% summarise(count=n()) %>% arrange(desc(count))

#Solution: Wait, there's a unique_mos_id in the dataset already. Still, worth having the above logic 
  #in my notes, lest I forget and naively try a badge sort. That sounds like me.
#unique_mos_id also provides a very easy means of lightly anonymizing the data. Whether that's appropriate or not...

by_officer = df %>% group_by(unique_mos_id) %>% summarise(count=n()) %>% arrange(desc(count))

#All officers, just giving them each a unique x effectively
  #this graph is not terribly good, but it works for exploration.
  #While there are definitely some high-complaint officers, there are a substantial number with 10-20 complaints.
  #That sounds high to me, but I don't have much context for these numbers.
ggplot(by_officer,aes(x=-as.numeric(row.names(by_officer)),y=count))+
  geom_point() + xlab("") + ylab("Complaints") + ggtitle("Complaints by Officer") +
  theme_bw() + theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank()
  )


Limitations:
  -Propublica chose not to include any allegations that were found to be totally unfounded (not to be confused with 'unsubstantiated').
  That information could be useful in putting the other numbers in context. At the very least, it would tell us how many yearly complaints
  the NYPD receives.
    "There were about 3,200 allegations listed as unfounded in the data we were provided, about 9% of the total."
  -The allegations themselves are not especially descriptive. Thats fine for providing summaries, but you have to assume the underlying
  database had more specifics.
  -Police brutality touches on a lot of subjects beyond the scope of a little DTS project. So I would need to put some real thought into
  what I can and can't assert with the tools I'm actually using, and how I go about presenting that.
  
  
[ ] Find 3-5 potential data sources (that are free) and document some information about the source.
[ ] Build an R script that reads in, formats, and visualizes the data using the principles of exploratory analysis.
[ ] Write a short summary in your .Rmd file of the read in process and some coding secrets you learned.
[ ] Include 2-3 quick visualizations in your .Rmd file that you used to check the quality of your data.
[ ] Summarize the limitations of your final compiled data in addressing your original question.

  
  
#####################
# What jurisdictions in the United States experienced major shifts in crime in recent years (positive or negative)?
#####################
  
#Dataset: National Bureau of Justice Statistics' "Personal Victimization Surveys", 2015-2019

bjs_df = read_csv("NCVS_PERSONAL_VICTIMIZATION_2015-2019.csv")
  
bjs_df

get_all_vars(bjs_df)

#Problem- I need to cross reference a ton of numbers. I have yet to learn how to do this.