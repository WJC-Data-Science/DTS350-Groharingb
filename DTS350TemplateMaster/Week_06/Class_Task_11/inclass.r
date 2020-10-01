library(tidyverse)
library(dplyr)
library(hexbin)

ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25,color="white") +
  xlab("Duration of Eruption (minutes)") +
  ylab("Number of Observations") + theme_bw()

fwait = faithful %>% mutate(
  waitcat = case_when(
    waiting >= 67 ~ ">= 67",
    waiting < 67 ~ "< 67"
))

ggplot(data = fwait, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.15,color="white",mapping=aes(fill=waitcat)) +
  xlab("Duration of Eruption (minutes)") +
  ylab("Number of Observations") +
  labs(fill="Duration of Wait") +
  scale_fill_manual(
    values = c("#1ff063","#8c5ee9")
  ) + theme_bw() +
  theme(
    legend.position = "bottom"
  )

ggplot(data = fwait, mapping = aes(x = eruptions,y=waiting)) + 
  geom_hex() + 
  xlab("Duration of Eruption (minutes)") +
  ylab("Number of Observations") +
    labs(fill="Number of\nobservations") + #Is auto wrapping a thing?
  theme_bw()
