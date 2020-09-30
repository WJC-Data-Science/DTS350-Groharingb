---
title: "Task10Plots.rmd"
author: "Brooks Groharing"
date: "9/30/2020"
output: 
  html_document: 
    keep_md: yes
---



## Departure Delay by Carrier




```r
final_fl_bp
```

```
## Warning: Removed 8255 rows containing non-finite values (stat_boxplot).
```

![](Task10Plots_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

This shows the distribution of departure delays, broken down by airline. The y-axis has been limited to compensate for some incredibly late outliers. Otherwise, the data would hardly be readable. From this plot, I learned about coord_cartesian(), which is a more compact way of limiting multiple axes (as I do in the next plot).


## Departure Delay by Departure Time





```r
final_fl_sc
```

![](Task10Plots_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

This groups the delay data by each flight's departure time. The data are limited to 8-9am, since otherwise the graph would be difficult to read. Here I learned that when making integer sequences, R will let you use a non-int number in your bounds. This prevents you from having to find the end position by hand when creating breaks at a set interval. 

## Car Efficiency by Class





```r
cargraph
```

![](Task10Plots_files/figure-html/unnamed-chunk-6-1.png)<!-- -->


This graphs engine displacement versus highway gas mileage in a bunch of cars, and then groups them by vehicle category. I learned how to layer elements to change one point type without altering the legend, and how to manually set a ggrepel seed so the resulting placements are reproducible.

