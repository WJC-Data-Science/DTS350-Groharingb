library(tidyverse)

?iris

#1

ggplot(data = iris) +
  geom_point(mapping = aes(x=Sepal.Width, y = Sepal.Length))
#this doesn't change anything, because we only have 1 plot layer.
#keeping aes in ggplot() lets you set aesthetics for all layers at once, preventing lots of redundant code. The downside is this gives you less fine control over each layer.

#2

ggplot(data = iris, mapping = aes(x = Sepal.Width, 
                                  y = Sepal.Length, 
                                  color = Species)) +
  geom_point(shape = 8)

#3
ggplot(data = iris, mapping = aes(x = Sepal.Width, 
                                  y = Sepal.Length, 
                                  color = Species,
                                  shape = Species)) +
  geom_point()

#Putting something in the AES lets it change based on value. Putting it outside lets you explicitly set it for all data.

#4

ggplot(data = iris, mapping = aes(x = Sepal.Width, 
                                  y = Sepal.Length, 
                                  color = Species,
                                  shape = Species)) +
  geom_point() + scale_shape_manual(values = c(1, 5, 7))


#5

ggplot(data = iris, mapping = aes(x = Sepal.Width, 
                                  y = Sepal.Length, 
                                  color = Species,
                                  shape = Species)) +
  geom_point() + scale_shape_manual(values = c(1, 5, 7)) +
  scale_x_log10() + scale_y_log10()

#6

ggplot(data = iris, mapping = aes(x = Sepal.Width, 
                                  y = Sepal.Length, 
                                  color = Species,
                                  shape = Species)) +
  geom_point() + scale_shape_manual(values = c(1, 5, 7)) +
  scale_x_log10() + scale_y_log10() +
  scale_color_manual(values = c("purple", "darkorange", "blue"))

# 8

ggplot(data = iris, mapping = aes(x = Sepal.Width, 
                                  y = Sepal.Length, 
                                  color = Species,
                                  shape = Species)) +
  geom_point() +
  scale_shape_manual(values =  c(1, 5, 7)) +
  scale_x_log10() +
  scale_y_log10() +
  scale_color_manual(values = c("purple", "darkorange", "blue")) + 
  labs(x = "Sepal Width (cm)",
       y = "Sepal Length (cm)",
       title = "This is where the title goes",
       shape = "Species of Iris",
       color = "Species of Iris")
  
  #Setting shape and color to the same label collapses their legends. Cool!


#10

ggplot(data = iris, mapping = aes(x = Sepal.Width, 
                                  y = Sepal.Length, color = Species, shape = Species)) +
  geom_point() +
  scale_shape_manual(values =  c(1, 5, 7)) +
  scale_x_log10() +
  scale_y_log10() +
  scale_color_manual(values = c("purple", "orange", "blue")) +
  labs(x = "Sepal Width (cm)",
       y = "Sepal Length (cm)",
       title = "This is where I would put a title",
       shape = "Species of Iris",
       color = "Species of Iris") +
  theme_minimal()

#11

p <- ggplot(data = iris, mapping = aes(x = Sepal.Width, 
                                       y = Sepal.Length, 
                                       color = Species,
                                       shape = Species)) +
  geom_point() +
  scale_shape_manual(values =  c(1, 5, 7)) +
  scale_x_log10() +
  scale_y_log10() +
  scale_color_manual(values = c("purple", "orange", "blue")) +
  labs(x = "Sepal Length (cm)",
       y = "Sepal Width (cm)",
       title = "This is where I would put a title",
       color = "Species of Iris",
       shape = "Species of Iris") + 
  theme(plot.title = element_text(hjust = .5)) +
  theme_bw() +
  facet_wrap(vars(Species)) 

(averages <- iris %>% group_by(Species) %>% summarise(avglength = mean(Sepal.Length)))

p + geom_hline(data = averages, mapping = aes( yintercept = avglength))

#To make the lines be red:

p + geom_hline(data = averages, color = "red", mapping = aes( yintercept = avglength))
