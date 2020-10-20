library(tidyverse)
library(dplyr)
library(downloader)
library(stringr)

download.file("https://github.com/WJC-Data-Science/DTS350/raw/master/StarWars/survey_multiresponse_questions.csv","multiresponse.csv")
download.file("https://raw.githubusercontent.com/WJC-Data-Science/DTS350/master/StarWars/survey_oneresponse_questions.csv","oneresponse.csv")

multi = read_csv('multiresponse.csv')
one = read_csv('oneresponse.csv')


#Which 'Star Wars' Movies Have you seen?

seen_n = multi %>% filter(question=="which_seen") %>%
  group_by(respondentid) %>%
  filter(is.na(answer)==FALSE) %>%
  summarise(n()) %>% summarise(count=n())

seen_n = seen_n[[1]]

seendf = multi %>% filter(question=="which_seen") %>%
  group_by(answer) %>% summarise(n(),pct=n()/seen_n)

ggplot(data=seendf) + geom_col(aes(y=pct,x=answer),fill="#008fd5") +
  labs(title="Which \'Star Wars\' Movies Have You Seen?",subtitle=str_c("Of ",seen_n," respondents who have seen any film"),fill="#505050") +
  geom_text(aes(y=0,x=answer,label=str_remove(answer,"(Star Wars: Episode)(.){2}(\\s+)")),hjust=1) +
  scale_y_continuous(breaks=c(),lim=c(-1,1)) +
  scale_x_discrete(breaks=c()) +
  xlab("") + ylab("") +
  coord_flip() +
  theme_minimal() +
  theme(
    plot.background = element_rect(color="#f0f0f0")
  )

scale=1.6
ggsave("WhichMovies.png",device="png",width=10/scale,height=4/scale,units="in")


#Who shot first?
resp_n = (one %>% filter(is.na(shot_first)==FALSE) %>% summarise(n()))[[1]] #I'm 6 short compared to 538. Hmmmm

whoShotFirst = one %>% filter(is.na(shot_first)==FALSE) %>% group_by(shot_first) %>% summarise(count=n(),pct=n()/resp_n*100)

whoShotFirst$shot_first = c("Greedo","Han","I don't understand\nthis question")

whoShotFirst %>% ?arrange()

ggplot(data=whoShotFirst) + geom_col(aes(y=pct,x=shot_first),fill="#008fd5") +
  labs(title="Who Shot First?",subtitle=str_c("According to ",resp_n," respondents"),fill="#505050") +
  geom_text(aes(y=0,x=shot_first,label=shot_first),hjust=1) +
  geom_text(aes(y=pct,x=shot_first,label=round(pct)),hjust=0) +
  scale_y_continuous(breaks=c(),lim=c(-10,40)) +
  scale_x_discrete(breaks=c()) +
  xlab("") + ylab("") +
  coord_flip() +
  theme_minimal() +
  theme(
    plot.background = element_rect(color="#f0f0f0")
  )

scale=1.6
ggsave("WhoShotFirst.png",device="png",width=10/scale,height=4/scale,units="in")

#Respondents who prefer one of the prequel movies


npreq = multi %>% filter(question=='rank_1f6w') %>% filter(answer==1) %>% summarise(n())
npreq = npreq[[1]]

trilogy = multi %>% filter(question=='rank_1f6w') %>% filter(answer==1) %>% group_by(choice) %>%
  summarise(count=n()) %>% cbind(answer=c("Prequels","Prequels","Prequels","Original","Original","Original")) %>%
  group_by(answer) %>% summarise(count=sum(count)) %>% mutate(pct=count/npreq)

ggplot(data=trilogy) + geom_col(aes(y=pct,x=answer),fill="#008fd5") +
  labs(title="Which \'Star Wars\' Trilogy Do You Prefer?",subtitle=str_c("Based on the favorite movie of ",npreq," respondents.")) +
  geom_text(aes(y=0,x=answer,label=str_remove(answer,"(Star Wars: Episode)(.){2}(\\s+)")),hjust=1) +
  geom_text(aes(y=pct,x=answer,label=round(pct*100)),hjust=0) +
  scale_y_continuous(breaks=c(),lim=c(-.1,1)) +
  scale_x_discrete(breaks=c()) +
  xlab("") + ylab("") +
  coord_flip() +
  theme_minimal() +
  theme(
    plot.background = element_rect(color="#f0f0f0")
  )

scale=1.6
ggsave("Trilogy.png",device="png",width=10/scale,height=4/scale,units="in")
