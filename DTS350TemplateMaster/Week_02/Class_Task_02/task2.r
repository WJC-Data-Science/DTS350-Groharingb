1 / 200 * 30
(59 + 73 + 2) / 3
sin(pi / 2)

x <- 3 * 4
x

this_is_a_really_long_name = 2.5
this_is_a_really_long_name = 3.5

r_rocks <- 2 ^ 3
r_rock
R_rocks

seq(1, 10)

x <- "hello world"
x <- "hello"

(y <- seq(1, 10, length.out = 5))

#Excercise 1: typo in my_variable

library(tidyverse)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8) #this runs fine
filter(diamonds, carat > 3)
#alt-shift-k for keyboard shortcuts



#ch. 4
library(nycflights13)
library(dplyr)
library(knitr)

flights

View(flights)
glimpse(flights)
kable(flights)

glimpse(flights)

flights$carrier

airlines$name


#What did I learn?
#I learned how to generate sequences in the first chapter.
#In the second one, I learned a bunch of different methods for looking at a dataset in R.