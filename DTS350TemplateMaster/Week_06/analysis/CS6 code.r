library(tidyverse)
library(dplyr)
library(ggrepel)

diamonds
?diamonds

#Make visualizations to give the distribution of each of the x, y, and z
  #variables in the diamonds data set.
  #x y and z are length, width, and depth

ggplot(data=diamonds,aes(x=x)) + geom_histogram(binwidth=0.1) +
  xlim(c(0,10)) + xlab("Length (mm)") + ylab("Count") +
  theme_bw()

ggplot(data=diamonds,aes(x=y)) + geom_histogram(binwidth=0.1) +
  xlim(c(0,10)) + xlab("Width (mm)") +
  theme_bw()

ggplot(data=diamonds,aes(x=z)) + geom_histogram(binwidth=0.1) +
  xlim(c(0,10)) + xlab("Depth (mm)") +
  theme_bw()

#Explore the distribution of price. Is there anything 
  #unusual or surprising?
  
  #Can you determine what variable in the diamonds dataset is most 
  #important for predicting the price of a diamond? How is that 
  #variable correlated with cut? Why does the combination of those
  #two relationships lead to lower quality diamonds being 
  #more expensive?


ggplot(data=diamonds,aes(x=price)) + geom_density() + theme_bw()

ggplot(data=diamonds,aes(x=price)) + geom_histogram(binwidth=100) + theme_bw()

ggplot(data=diamonds,aes(x=price)) + geom_histogram(binwidth=10) + 
  xlim(c(0,5000)) + theme_bw()

ggplot(data=diamonds,aes(x=price)) + geom_histogram(binwidth=1) + 
  xlim(c(0,1000)) + theme_bw()

#Price peaks beneath $1000
ggplot(data=diamonds,aes(x=price)) + geom_density + 
  xlim(c(0,1000)) + theme_bw()


ggplot(data=diamonds,aes(x=carat,y=price)) + geom_point() + theme_bw()


#Diamond price doesn't obviously go up with cut... weird.
ggplot(data=diamonds,aes(x=cut,y=price)) + geom_boxplot() + theme_bw()



#decreasing color quality generally increases price. Also weird.
#color is from D (best) to J (worst)
ggplot(data=diamonds,aes(x=color,y=price)) + geom_boxplot() +
ggtitle("Diamond Price by Color Rating") + xlab("Color Rating\nFrom D (best) to J (worst)") +
ylab("Price") + theme_bw() 


#And, price generally goes down down with increasing clarity.
  #From ?diamonds:
  #I1 (worst), SI2, SI1, VS2, VS1, VVS2, VVS1, IF (best)
ggplot(data=diamonds,aes(x=clarity,y=price)) + geom_boxplot() +
xlab("Clarity") + ylab("Price") + theme_bw()

#prices have no obvious relationship with depth.
ggplot(data=diamonds,aes(x=depth,y=price)) + geom_point() + theme_bw()


#No obvious relationship between table and price.
#Table: width of top of diamond relative to widest point (43–95)
ggplot(data=diamonds,aes(x=table,y=price)) + geom_point() + 
xlim(c(50,70)) + theme_bw()
  #It looks like the data points are clustered at round table
  #numbers, and cover the span of prices pretty evenly.


#Less surprisingly, larger diamonds are more expensive.
ggplot(data=diamonds,aes(x=x,y=price)) + geom_point() + 
  xlim(c(0,10)) + xlab("Length (mm)") + theme_bw()

ggplot(data=diamonds,aes(x=y,y=price)) + geom_point() + 
  xlim(c(0,10)) + xlab("Width (mm)") + theme_bw()

ggplot(data=diamonds,aes(x=z,y=price)) + geom_point() + 
  xlim(c(0,10)) + xlab("Depth (mm)") + theme_bw()

#Same goes for volume
ggplot(data=mutate(diamonds,volume = x*y*z),aes(x=volume,y=price)) +
  geom_point() + xlim(c(0,1000)) +
  xlab("Volume (x*y*z)") + ylab("Price") + theme_bw()

#Diamond carat generally goes down as measures of 'quality' increase. Here's the problem.
ggplot(data=diamonds,aes(x=cut,y=carat)) + geom_boxplot() +
  ggtitle("Diamond Carat by Cut Quality") + xlab("Cut Rating") +
  ylab("Weight, Carat") +
  theme_bw()

ggplot(data=diamonds,aes(x=color,y=carat)) + geom_boxplot() +
  ggtitle("Diamond Carat by Color Rating") + xlab("Color Rating\nFrom D (best) to J (worst)") +
  ylab("Weight, Carat") +
  theme_bw()





#Make a visualization of carat partitioned by price.
ggplot(data=diamonds,aes(x=carat,y=price)) + geom_point() +
  facet_wrap(~round(carat),ncol=6) +
  theme_bw()

grouped = diamonds %>% group_by(carat = ceiling(carat)) %>% summarise(price = mean(price))

ggplot(data=diamonds,aes(x=carat,y=price,color=floor(carat))) +
  geom_point(data=diamonds) +
  #geom_line(data=grouped,aes(x=carat-.5,y=price),color="yellow") +
  xlab("Carat") + ylab("Price") + ggtitle("Price by Carat") +
  theme_bw() +
  theme(
    legend.position = "none"
    ) + scale_colour_viridis_c()

  

#How does the price distribution of very large diamonds compare
  #to small diamonds? Does the data agree with your expectations?
sized = mutate(diamonds,
  size = case_when(
   carat <= 1 ~ "Small Carat\n(<= 1 )",
   carat >= 4 ~ "Large Carat\n(>= 4 )",
   TRUE ~ "middle"
  )) %>% filter(size != "middle")
sizes = sized %>% group_by(size) %>% summarise(price=mean(carat))
colors = c("#AAAA00","blue")

ggplot(data=diamonds,aes(x=price)) + 
  geom_density(data=filter(diamonds,carat<=1),color=colors[1]) + 
  geom_density(data=filter(diamonds,carat>=4),color=colors[2]) +
  geom_text(data=sizes,aes(label=size,y=10^-4,x=c(16000,1800))) +
  xlab("Price") + ylab("Density") + ggtitle("Price Distribution, Small vs. Large Diamonds") +
  theme_bw()
  
  #Large diamonds are more uniformly distributed in price, and are more
  #expensive than smaller diamonds. As you would expect.




#Visualize a combined distribution of cut, carat, and price.
ggplot(data=diamonds,aes(x=carat,y=price)) + geom_point() + facet_wrap(facets = ~cut) +
  xlab("Carat") + ylab("Price") + ggtitle("Carat vs Price by Cut Quality") +
  theme_bw()

  #Price generally increases with carat at a comparable rate, across all cut qualities. 3+ carat diamonds are
    #rare and highly valuable across the board/

