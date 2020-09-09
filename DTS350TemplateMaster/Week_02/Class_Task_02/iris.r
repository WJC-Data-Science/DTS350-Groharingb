library(tidyverse)
library(ggplot2)

head(iris)
View(iris)

?iris


ggplot(iris,aes(x=Petal.Width,y=Petal.Length,color=Species,shape=Species)) +
  geom_point(size=2) +
  ggtitle("Leaf Dimensions in Different Species") + theme_bw() +
  facet_wrap(~ Species) + labs(x="Petal Length",y="Petal Width")

#How do petal length and width vary between Iris species?
#This graphic helps by plotting both variables for all the plants, and plotting them side by side. This allows you to 
  #tell, visually, how each species is clustered in both dimensions.