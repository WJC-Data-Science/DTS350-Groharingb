library(tidyverse)

##############
#   Parsing  # 
##############

#Example 1:
money <- c("4,554,25", "$45", "8025.33cents", "288f45")
as.numeric(money)
#na na na na
#batman

parse_number(money)
#Properly interprets the above numbers.
#This stops reading when it hits a non-numeric character, except for .
#     ex 288f45->288.00


#Example 2:

#This code gives NAs for non-ints; parse_integer can't round automatically

my_string <- c("123", ".", "3a", "5.4")
(parsed = parse_integer(my_string, na = "."))
problems(parsed)



#Example 3:
challenge <-  read_csv(readr_example("challenge.csv")) #From tidyverse

#This reads first 1000 rows to predict each column data type.

problems(challenge)
head(challenge)
tail(challenge)

#Challenge.csv changes types at row 1001, which causes an error on read.


challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)

challenge

##################
#   Data Import  # 
##################

getwd()

download.file("https://educationdata.urban.org/csv/ipeds/colleges_ipeds_completers.csv",
              "colleges_ipeds_completers.csv", mode = "wb")

ipeds <- read_csv("colleges_ipeds_completers.csv")

ipeds_2011 <- ipeds %>%
  filter(year == 2011)

write_csv(ipeds_2011, "colleges_ipeds_completers_2011.csv")

#Excercise:
filter(ipeds,fips==6 & year > 2014)
write_csv("ipeds_completers_ca.csv")


#Readxl
install.packages("readxl")
library(readxl)

#Example
download.file("https://www.hud.gov/sites/dfiles/Housing/documents/FHA_SFSnapshot_Apr2019.xlsx",
              "sfsnap.xlsx", mode = "wb")

excel_sheets("sfsnap.xlsx")

purchases <- read_excel("sfsnap.xlsx", sheet = "Purchase Data April 2019")

#Exercise
refinances = read_excel("sfsnap.xlsx", sheet = "Refinance Data April 2019")


##############
#   ggplot2  # 
##############

library(directlabels)

p <- ggplot(data = iris, mapping = aes(x=Sepal.Width, 
                                       y = Sepal.Length, 
                                       color = Species,
                                       shape = Species),
            size = 5) +
  geom_point() +
  scale_color_brewer(palette = "Set1") 

p %>%  direct.label()

# or
p + geom_dl(method = "smart.grid", mapping = aes(label = Species)) + theme(legend.position = "none") 

?geom_dl()

library(ggrepel)

#Example 4:
(best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(cty)) == 1))

  #This code orders types of car by their city gas mileage, in descending order.


ggplot(mpg, aes(displ, cty)) +
  geom_point(aes(colour = class)) +
  geom_label(aes(label = model), data = best_in_class, nudge_y = 2, alpha = 0.5) 

ggplot(mpg, aes(displ, cty)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class, nudge_x = 1.5, nudge_y = 1) 

#The ggrepel code added a white background behind the labels and moved them away from the data.
#The nudge values offset the labels.

#[] Remove the border around the car labels by changing geom_label_repel to geom_text_repel
#[] Make the labels color coded, according to the color of the class of car
#[] Bonus: move the best in class labels so they don’t cover up data points

ggplot(mpg, aes(displ, cty)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_text_repel(aes(label = model,color=class), data = best_in_class, nudge_x = 1.5, nudge_y = 3) 

?ggrepel

#Altering Non-Data Elements of the chart
p

p + theme(
  legend.position = "bottom",
  panel.grid.major.x = element_blank(), 
  panel.grid.minor.x = element_blank(),
  axis.ticks.length = unit(6, "pt"))

#Example 5:
# Alter the code above so that:
# [] the legend is at the top of the chart.
# [] the y minor gridlines are removed.

p + theme(
  legend.position = "top",
  panel.grid.major.x = element_blank(), 
  panel.grid.minor.x = element_blank(),
  panel.grid.minor.y = element_blank(),
  axis.ticks.length = unit(6, "pt"))

#Example 6:
# [] Make the title font larger using size = rel(2) inside the element_text function.
# [] Make the title right justified.

p +
  labs(title = "Comparing 3 Species of Iris") +
  theme(plot.title = element_text(hjust = 1,size=rel(2)),
        axis.text.x = element_text(angle = 35))
