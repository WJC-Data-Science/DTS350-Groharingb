#Creating and ordering factors

library(tidyverse) #includes forcats package

x1 <- c("Dec", "Apr", "Jan", "Mar")
x2 <- c("Dec", "Apr", "Jam", "Mar")

month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

y1 <- factor(x1, levels = month_levels)
y1
sort(y1)

y2 <- factor(x2, levels = month_levels)#errors => NAs
y2

y2 = parse_factor(x2,levels=month_levels)#Gives warnings

#To set levels to data order, use unique():
f1 <- factor(x1, levels = unique(x1))
f1
#or inorder():
f2 <- x1 %>% factor() %>% fct_inorder()

#GSS Examples
gss_cat %>%
  count(race)

#To include empty levels, add drop=FALSE to your scale
ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

#############################
Reordering Factors:
use fct_reorder(factor/chrvector,numericvector)
reorders based on said vector. Example:

    relig_summary = gss_cat %>%
      group_by(relig) %>%
      summarise(
        age = mean(age, na.rm = TRUE),
        tvhours = mean(tvhours, na.rm = TRUE),
        n = n()
      )
    
    ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
      geom_point()
      
fct_elevel() pulls specific levels out to front, without reordering the rest
    
    rincome_summary <- gss_cat %>%
      group_by(rincome) %>%
      summarise(
        age = mean(age, na.rm = TRUE),
        tvhours = mean(tvhours, na.rm = TRUE),
        n = n()
      )
      
      ggplot(rincome_summary, aes(age, fct_relevel(rincome, "Not applicable"))) +
      geom_point()
  
Lining up with legend:  
fct_reorder2() sets value associated with end of x axis

    by_age <- gss_cat %>%
      filter(!is.na(age)) %>%
      count(age, marital) %>%
      group_by(age) %>%
      mutate(prop = n / sum(n))
    
    ggplot(by_age, aes(age, prop, colour = marital)) +
      geom_line(na.rm = TRUE)
    
    ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop))) +
      geom_line() +
      labs(colour = "marital")
      
Bar plots- use fct_infreq()

    gss_cat %>%
    mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
    ggplot(aes(marital)) +
      geom_bar()
  
#######################
To modify level names, use fct_recode():

    gss_cat %>% count(partyid)
    #vs:
    gss_cat %>%
    mutate(partyid = fct_recode(partyid,
      "Republican, strong"    = "Strong republican",
      "Republican, weak"      = "Not str republican",
      "Independent, near rep" = "Ind,near rep",
      "Independent, near dem" = "Ind,near dem",
      "Democrat, weak"        = "Not str democrat",
      "Democrat, strong"      = "Strong democrat"
    )) %>%
    count(partyid)
    
    
Combining groups:

    gss_cat %>%
      mutate(partyid = fct_recode(partyid,
        "Republican, strong"    = "Strong republican",
        "Republican, weak"      = "Not str republican",
        "Independent, near rep" = "Ind,near rep",
        "Independent, near dem" = "Ind,near dem",
        "Democrat, weak"        = "Not str democrat",
        "Democrat, strong"      = "Strong democrat",
        "Other"                 = "No answer",
        "Other"                 = "Don't know",
        "Other"                 = "Other party"
      )) %>%
      count(partyid)
      
fct_collapse(): collapse groups

fct_lump(): progressively collapse smaller groups. You can set the number of groups with n=#

    gss_cat %>%
      mutate(relig = fct_lump(relig, n = 10)) %>%
      count(relig, sort = TRUE) %>%
      print(n = Inf)  