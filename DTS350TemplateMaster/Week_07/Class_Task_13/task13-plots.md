---
title: "task13-plots.rmd"
author: "Brooks Groharing"
date: "10/8/2020"
output: 
  html_document: 
    keep_md: yes
---



### Initial plotting


![](task13-plots_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

This graphic plots the distribution of six-month return values in the raw dataset, faceted by stock. The quartiles and outliers for each stock are represented as boxplots, while the underlying datapoints are plotted in the background with a random horizontal jitter. Blue diamonds indicate the mean return for each stock over the 9 year period.

### Tidying the dataset

In the initial dataset, date ranges are condensed into a single string per row.


```r
head(df_rds)
```

```
## # A tibble: 6 x 3
##   contest_period      variable value
##   <chr>               <chr>    <dbl>
## 1 January-June1990    PROS      12.7
## 2 February-July1990   PROS      26.4
## 3 March-August1990    PROS       2.5
## 4 April-September1990 PROS     -20  
## 5 May-October1990     PROS     -37.8
## 6 June-November1990   PROS     -33.3
```

To divide this into multiple columns, we can use tidyr's separate() function:


```r
df_tidy = df_rds %>% 
  separate(contest_period,into=c("month_start","end"),sep="-") %>%
  separate(end,into=c("month_end","year_end"),sep=-4)

df_tidy
```

```
## # A tibble: 300 x 5
##    month_start   month_end year_end variable value
##    <chr>         <chr>     <chr>    <chr>    <dbl>
##  1 January       June      1990     PROS      12.7
##  2 February      July      1990     PROS      26.4
##  3 March         August    1990     PROS       2.5
##  4 April         September 1990     PROS     -20  
##  5 May           October   1990     PROS     -37.8
##  6 June          November  1990     PROS     -33.3
##  7 July          December  1990     PROS     -10.2
##  8 August1990    January   1991     PROS     -20.3
##  9 September1990 February  1991     PROS      38.9
## 10 October1990   March     1991     PROS      20.2
## # ... with 290 more rows
```

This format is easier to manipulate in r, and allows for graphing the data over time.

### Plotting the Tidied Data


![](task13-plots_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

This plot breaks down the distribution of six-month returns by their year of collection (That means, for example, that the return for August 1990 through January 1991 is included in the the 1991 distribution.) Again, this is made possible by pulling out the individual variables within the original contest_period string.

### Generating a 'Spread' Table
Finally, tidyr's pivot_wider() function can be used to 'spread' a tided dataset back out. This format is less useful in code, but has the potential to be more compact/human readable:

```r
DJIA = df_tidy %>% 
  filter(variable=="DJIA") %>%
  select(month_end,year_end,variable,value) %>%
  pivot_wider(names_from=year_end,values_from=value) %>%
  head(12) #maybe a clunky solution...

DJIA$month_end = factor(DJIA$month_end,
                levels=c(
                "January",
                "February",
                "March",
                "April",
                "May",
                "June",
                "July",
                "August",
                "September",
                "October",
                "November",
                "December"))

DJIA = DJIA %>% arrange(DJIA,month_end)

knitr::kable(select(DJIA,Month=month_end,'1990':'1998'))
```



|Month     |  1990| 1991| 1992| 1993| 1994| 1995| 1996| 1997|  1998|
|:---------|-----:|----:|----:|----:|----:|----:|----:|----:|-----:|
|January   |    NA| -0.8|  6.5| -0.8| 11.2|  1.8| 15.0| 19.6|  -0.3|
|February  |    NA| 11.0|  8.6|  2.5|  5.5|   NA| 15.6| 20.1|  10.7|
|March     |    NA| 15.8|  7.2|  9.0|  1.6|  7.3| 18.4|  9.6|   7.6|
|April     |    NA| 16.2| 10.6|  5.8|  0.5| 12.8| 14.8| 15.3|  22.5|
|May       |    NA| 17.3| 17.6|  6.7|  1.3| 19.5|  9.0| 13.3|  10.6|
|June      |   2.5| 17.7|  3.6|  7.7| -6.2| 16.0| 10.2| 16.2|  15.0|
|July      |  11.5|  7.6|  4.2|  3.7| -5.3| 19.6|  1.3| 20.8|   7.1|
|August    |  -2.3|  4.4| -0.3|  7.3|  1.5| 15.3|  0.6|  8.3| -13.1|
|September |  -9.2|  3.4| -0.1|  5.2|  4.4| 14.0|  5.8| 20.2| -11.8|
|October   |  -8.5|  4.4| -5.0|  5.7|  6.9|  8.2|  7.2|  3.0|    NA|
|November  | -12.8| -3.3| -2.8|  4.9| -0.3| 13.1| 15.1|  3.8|    NA|
|December  |  -9.3|  6.6|  0.2|   NA|  3.6|  9.3| 15.5| -0.7|    NA|
