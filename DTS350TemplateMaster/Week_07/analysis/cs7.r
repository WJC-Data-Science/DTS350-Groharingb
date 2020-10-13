library(haven)
library(readr)
library(readxl)
library(tidyverse)
library(foreign) #I couldn't find a function for reading .dbf files in the others...


#World Data
height = read_xlsx("imported/height.xlsx",range = cell_rows(3:309))

header_codes = c(150,155,154,39,151,19,21,419,29,13,5,9,53,54,57,61,142,34,30,35,145,143,2,15,11,17,18,14)

world = height %>% 
  mutate(isHeader = Code %in% header_codes) %>% #select(Code,isHeader) %>%
  filter(isHeader == FALSE) %>%
  select(-isHeader) %>%  
  filter(is.na(Code) == FALSE) #this filters out Kosovo, Tibet, and Indonesia. Consider adding them back in.

colnames(world)[2] = "Country"

world = world %>% pivot_longer(cols=-c("Code","Country"),names_to="year",values_to="height.cm")

world = world %>% mutate(year_decade=as.integer(year)) %>% 
  separate(year,c("century","decade","year"),sep=c(2,3)) %>% 
  mutate(height.in = height.cm/2.54) %>%
  filter(is.na(height.cm)=="FALSE")

#Other datasets
#Bavarian Conscripts
conscripts = read_dta(url("https://github.com/WJC-Data-Science/DTS350/raw/master/germanconscr.dta")) #Bavarian male conscrips

conscripts = conscripts %>%
  mutate( height.in = height/2.54,study_id = "bavarian_conscripts") %>%
  select(birth_year = bdec,height.cm=height,height.in,study_id)


#German Prisoners
prison = read_dta(url("https://github.com/WJC-Data-Science/DTS350/raw/master/germanprison.dta")) #German prison data

prison = prison %>% mutate(height.in=height/2.54) %>%
  select(birth_year=bdec,height.cm=height,height.in) %>%
  mutate(study_id="german_prisoners")


#18th century Southeast/western German Soldiers
soldiers = read.dbf("imported/B6090.DBF")

soldiers = soldiers %>% 
  mutate(height.in=CMETER/2.54) %>% #Easier than messing with 12th inches
  mutate(study_id="German_Soldiers_1700s") %>% 
  select(birth_year=GEBJ,height.cm=CMETER,height.in,study_id)


#bls wage data
bls = read_csv("https://github.com/hadley/r4ds/raw/master/data/heights.csv")

bls = bls %>% mutate(height.cm=height*2.54,study_id="bls_wage_data",birth_year=1950) %>%
    select(birth_year,height.cm,height.in=height,study_id)


#2005 Wisconsin national survey data
wisconsin = read_sav("http://www.ssc.wisc.edu/nsfh/wave3/NSFH3%20Apr%202005%20release/main05022005.sav")

  #RT216F -  respondent height, feet
  #RT216I - and inches
  #doby - date of birth.... w/ code 1-70.

  wisconsin$DOBY %>% attr('labels')
  #I can't find any explanation of what these birth year codes correspond to. 
  #I've arbitrarily chosen to interpret this as years since 1914; that gives 
  #a range of possible respondent ages between 21 and 91.

  wisconsin = wisconsin %>% 
    filter(RT216F >= 0) %>%
    filter(RT216I <= 12 | RT216I>=0) %>% 
    filter(DOBY > 0) %>%
    mutate(birth_year=1914+as.integer(DOBY)) %>%
    mutate(height.in = RT216F*12+RT216I) %>%
    mutate(height.cm = height.in * 2.54,study_id = "wisconsin") %>%
    select(birth_year,height.cm,height.in,study_id)

  
#Combining them all
combined = rbind(conscripts,prison,soldiers,bls,wisconsin)


#Exporting the tidy data
write.csv(world,"tidied_world.csv")
write.csv(combined,"tidied_combined.csv")
combined


#Plot of country data, highlighting Germany
p1 = ggplot(data=world,aes(x=year_decade,y=height.in)) + 
  geom_point(alpha=0.13) +
  geom_line(alpha=0.03,aes(group=Country,color=Country)) +
  geom_line(data=filter(world,Country=="Germany"),aes(x=year_decade,y=height.in),size=1.2,alpha=0.2,color="blue") +
  geom_point(data=filter(world,Country=="Germany"),aes(x=year_decade,y=height.in),color="blue",size=5,alpha=0.3)+
  geom_text(data=head(world,1),aes(x=1959,y=60.2,label="— Germany"),color="blue",alpha=0.7,hjust=0,size=5) +
  scale_x_continuous(limits=c(1805,1985),breaks=(0:9)*20+1800,expand=c(0,0,0,0)) +
  xlab("Year") +
  ylab("Height (in)") + 
  labs(title="Average Male Height by Country") +
  theme_bw() +
  theme(
    legend.position = 'none',
    plot.margin = unit(c(1,10,1,10),"point")
  )

world_avgs = group_by(world,year_decade) %>% summarise(height.in=mean(height.in)) 

p1 = p1 + geom_line(alpha=0.03,aes(group=Country)) +
  geom_line(data=world_avgs,aes(x=year_decade,y=height.in),size=1.2,alpha=0.4) +
  geom_point(data=world_avgs,aes(x=year_decade,y=height.in),size=5,alpha=0.2) +
  geom_text(data=head(world,1),aes(x=1959,y=61.2,label="— World"),alpha=0.7,hjust=0,size=5)

p1


x = paste(knitr::asis_output("x\U0305"),"= ")
means = combined %>% group_by(study_id) %>% summarise(avg=mean(height.in)) %>% mutate(lbl=paste(x,round(avg,2)))





ggplot(data=combined) + geom_histogram(aes(x=height.in),binwidth=1) +
  facet_wrap(~study_id) + 
  geom_text(data=means,aes(x=125,y=725,label=lbl)) +
  xlab("Height (inches)") + ylab("Count of ") +
  theme_bw()


p2 = ggplot(data=combined) + geom_histogram(aes(x=height.in),binwidth=1) +
  facet_wrap(~study_id) + 
  geom_text(data=means,aes(x=125,y=725,label=lbl)) +
  xlab("Height (inches)") + ylab("Frequency") +
  theme_bw() +
  theme(legend.position='none')
  

p2