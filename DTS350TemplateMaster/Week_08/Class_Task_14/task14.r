library(tidyverse) #My code looks like lasagna
randomletters = "https://raw.githubusercontent.com/WJC-Data-Science/DTS350/master/randomletters.txt" %>% readr::read_lines()
wnums = "https://raw.githubusercontent.com/WJC-Data-Science/DTS350/master/randomletters_wnumbers.txt" %>% readr::read_lines()
x = str_remove_all(randomletters,"[^a-z.\\s]")
out = str_c("Hidden message 1: ", str_extract(randomletters,"(.)"))
for (i in 0:length(str_extract_all(x,"(.)")[[1]])){ if(i %% 1700 == 0 || i == 0){ out = str_c(out,str_sub(x,start = i,end = i)) } }
a = (out %>% str_split("(?<=\\.)(.)"))[[1]][1]
b = str_c("Hidden message 2: ", (message2 = (str_sub("ABCDEFGHIJKLMNOPQRSTUVWXYZ", (wnums %>% str_split("[^0-9]+"))[[1]], (wnums %>% str_split("[^0-9]+"))[[1]]))[2:40] %>% str_c(collapse = "")))
c = str_c("Longest vowel sequence: ", (longest_vowels = (str_remove_all(randomletters,"\\.|\\s") %>% str_extract_all("[aeiou]+"))[[1]][ ((str_remove_all(randomletters,"\\.|\\s") %>% str_extract_all("[aeiou]+"))[[1]] %>% str_length() %>% str_order(decreasing = TRUE))[1] ]))
cat("\n",a,"\n\n",b,"\n\n",c,sep = "")