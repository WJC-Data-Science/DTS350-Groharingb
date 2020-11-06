library(tidyquant) # to get stock data
library(tidyverse) # for pipes
library(dplyr) # for data transformations
library(lubridate) # for date/time functions
library(timetk) # for converting dates to xts
library(dygraphs) # for interactive plots

#KR: stock for Kroger
#Load it into a tibble
df_kr = tq_get("KR",get="stock.prices")

xts = df_kr %>%
  pivot_wider(names_from=symbol,values_from=adjusted) %>% 
  filter(year(date)>2015) %>%
  select(date,KR) %>% tk_xts(data_var=date)

#Stock price performance over 5 years.
dygraph(data=xts,main="Kroger stock price performance, 2016-present")

# Image that you invested $10,000 in kroger about two years ago on April 5th. 
# Make a graph with dygraph that shows performance using dyRebased() to $10,000.

xts_monthly = df_kr %>% filter(date >= "2018-4-5") %>%
  tq_transmute(mutate_fun=monthlyReturn,col_rename=c("Monthly Return")) %>%
  tk_xts()

start = "2020-3-29"
present = "2020-11-04"

dygraph(data=xts_monthly,main="Kroger $10k stock performance, by month (4/5/18-present)") %>%
  dyRebase(value=10000) %>%
  dySeries(color="blue") %>%
  dyAnnotation("2019-3-29","A",tooltip="March 2019: KR stock falls 16 percent following dissappointing Q4 sales") %>%
  dyAnnotation("2020-3-31","B",tooltip="March 2020: The stock market crashes, signalling the start of an ongoing recession") %>%
  dyRangeSelector(dateWindow=c("2018-3-29","2020-11-04"),keepMouseZoom=TRUE)
  
#I've highlighted two important times/trends in the data.

#First, KR stock prices underwent a broad downward trend throughout 2019, with especially poor quarterly sales discouraging investors in April. Stock continued to rise and fall through the remainder of the year. 2020 disrupted this pattern, with the pandemic and recession depressing stock prices from March onwards.