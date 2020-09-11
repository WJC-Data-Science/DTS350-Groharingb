---
title: 'Task 5: Data Import and ggplot2'
author: "Brooks Groharing"
date: "9/10/2020"
output: 
  html_document: 
    keep_md: yes
---



## Intro

### What I learned
I learned:
  -How to download online datasets and libraries in code
  -How to import .csvs files, and how R tries to interpret their values 
  -More options in ggplot, like blanking out elements and adding offset labels with ggrepel
  -More options for graph themes and color schemes
  
### What I found difficult
I had some difficulty importing the dataset from 538 (below).



## FiveThirtyEight Data

The dataset I grabbed is from 538's "Tracking Congress In The Age Of Trump," a live page tracking how often each member of congress votes in line with the President, and ranks them all.

Link to webpage: https://projects.fivethirtyeight.com/congress-trump-score/
Link to datasets: https://github.com/fivethirtyeight/data/tree/master/congress-trump-score

I downloaded just the averagess.csv dataset for this assignment, and ignored the voting predictions data.

### Importing it


```r
download.file("https://projects.fivethirtyeight.com/congress-tracker-data/csv/averages.csv","congress-tracking.csv")

df = read_csv("congress-tracking.csv")
```

```
## Parsed with column specification:
## cols(
##   congress = col_double(),
##   chamber = col_character(),
##   bioguide = col_character(),
##   last_name = col_character(),
##   state = col_character(),
##   district = col_double(),
##   party = col_character(),
##   votes = col_double(),
##   agree_pct = col_double(),
##   predicted_agree = col_double(),
##   net_trump_vote = col_double()
## )
```

### Data Manipulations

First I consolidated individual politicians:

```r
politicians = summarise(group_by(df,last_name,chamber,state,district), avg = mean(agree_pct,na.rm=TRUE))
## `summarise()` regrouping output by 'last_name', 'chamber', 'state' (override with `.groups` argument)
```
Then, I averaged their "Trump scores" by state.

```r
states = summarise(group_by(politicians,state),mean(avg,na.rm=TRUE))
## `summarise()` ungrouping output (override with `.groups` argument)
```

### Saving Transformed Data
Lastly, I saved the aggregated state data as a .csv.


```r
write.csv(states,"AgreementScoreByState.csv")
```
