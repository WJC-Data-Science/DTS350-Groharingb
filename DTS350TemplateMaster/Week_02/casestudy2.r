library(gapminder)
library(dplyr)
library(ggplot2)


#Plot 1
df = filter(gapminder,country!="Kuwait")

plot1 = ggplot(data=df,aes(x=lifeExp,y=gdpPercap,size=pop/100000,color=continent)) +
  geom_point() + facet_grid(~year) +
  scale_y_continuous(trans = "sqrt",limits=c(0,50000)) +
  scale_x_continuous(limits=c(25,80)) + #25-80 x limits look about right
  xlab("Life Expectancy") + ylab("GDP per capita") +
  labs(size="Population (100k)") + theme_bw()

ggsave("plot1.png",
       plot=plot1,
       device="png",
       width=15,height=5,
       units="in")

#Plot 2
graph2_df = summarise(group_by(df,continent,year),
                      gdpPercap = weighted.mean(gdpPercap,pop),
                      pop = sum(as.numeric(pop)))

plot2 = ggplot(data=df,aes(x=year,y=gdpPercap,color=continent)) +
  geom_line(aes(group=country)) + geom_point(aes(size=pop/100000)) +
  facet_grid(~continent) +
  scale_y_continuous(limits=c(0,50000)) +
  xlab("Year") + ylab("GDP per capita") +
  labs(size="Population (100k)") + theme_bw() +
  geom_line(data=graph2_df,aes(x=year,y=gdpPercap),color="black") +
  geom_point(data=graph2_df,aes(x=year,y=gdpPercap,size=pop/100000),color="black")

ggsave("plot2.png",
       plot=plot2,
       device="png",
       width=15,height=5,
       units="in")
 





#What I learned:
# -How to save a plot in code. This lets me specify dimensions, instead of resizing the little window in rstudio to get it about right.