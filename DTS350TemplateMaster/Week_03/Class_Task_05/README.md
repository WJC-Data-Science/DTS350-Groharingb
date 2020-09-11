TASK 5 NOTES (from R for Data Science)
 
Ch.3- Data Visualization
--------------------------------------------
  ggplot2 is part of tidyverse
  graphs are built by adding together layers, ex:
    ggplot(data = ) +
      geom_point(aes(x=,y=)) +
      facet_wrap() + 
      theme()
      
  Statistical transformations:
    geom_bar()
    stat_count()
    stat_summary()
  


Ch. 28- Graphics for Communications
--------------------------------------------
Graphs should be as self-explanatory as possible. ex:
  ggrepel::geom_label_repel()


Instead of loading whole library, use :: notation


ggrepel- automatic labels

  ggplot(mpg, aes(displ, hwy, colour = class)) +
  ggrepel::geom_label_repel(aes(label = class),
    data = class_avg,
    size = 6,
    label.size = 0,
    segment.color = NA
  ) +
  geom_point() +
  theme(legend.position = "none")


  

add lines w/  geom_hline(), geom_vline()
  also geom_rect(), geom_segment() (arrows)

scales:
scale_x_continuous()
scale_y_continuous()

legends can be repositioned in theme, ex
  theme(legend.position='left') or 'none'
scale_colour_discrete()  

install.packages() for installing packages


sviridis- includes color brewer scales
https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3



Ch. 6- Workflow: scripts
--------------------------------------------
the script editor exists.

It's rude to install.packages(), setwd() on code you share with others
fair enough.


Ch. 11- Data import
--------------------------------------------

readr package (under tidyverse)
read_csv()
read_csv2()   semicolon delimited
read_tsv()    tabs
read_delim()  whatever you want

read_fwf() fixed width files
read_table()


read_csv("path",col_names=bool,na="nachar")
  will happily read a string with commas in it:
    read_csv(
    "a,b,c
    1,2,3
    4,5,6")
  returns a tibble; great for testing

  col_names can take a list of strings instead of TRUE/FALSE, for easy renaming
  ex col_names = c("colname1","colnametwo","yay")

note: base R's read.csv() isn't as flexible


read_csv() parses different variable types different ways

parse_number()- ignores %,$, chops off .1234

strings- default to UTF-8, but can take other encodings.

factors- categorical variables w/ known set of posible values (levels).

Time:
parse_datetime(), parse_date(), parse_time()

readxl() for reading excel