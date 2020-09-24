 ##VECTORS (R for Science Ch.20)
 Tibbles are made up of vectors
 
 Atomic Vectors- has type (logical, int, double, character, complex, raw)
 
 Lists (recursive vectors): can contain other lists.
 
x = list("a", "b", 1:10)
length(x)

augmented vector- have additional metadata
  Factors, Dates/Date-times,DFs/tibbles
  

vectors are homogeneous; below converts bool to int
c(1,2,TRUE) #1 2 1

list(1,2,TRUE) #1 2 TRUE

ints: can be NA
doubles: NA,NaN,Inf,-Inf
  check w/  s.finite(),is.nan(),etc
  
  
  NAs can be specific to vector type
    ex NA_integer_
  MOST functions will convert for you; not all
  
  CONVERTERS:
  ex as.double()
  often done implicitly; ex, mean(int vector)
  
  Testing: is_atomic(),is_logical(), etc. There's a full table for how different types react w/ these functions.
  
  
  ****R operators work with vectors out of the box (apparently scalars internally are vectors)
  Vector recycling can be unintuitive, so be careful.

NAMING- items can be given a name. neat.
set_names(1:3, c("a", "b", "c"))

ACCESSING:
x[c(3,2,5)] to get index 3,2,5
x[c(-1,-3,-5)] everything but these (cannot mix w/ negative). A little unintuitive.
vectors are not 0-indexed.

LISTS
str(a list) - preview STRucture
lists can contain lists; subset like 
a[[4]]. cool.

b = list(1,list(2,3),4)
b[1]
b[2]

attr(b,"attributeyay") = "value"
attributes(b)

FACTORS
x <- factor(c("ab", "cd", "ab"), levels = c("ab", "cd", "ef"))
typeof(x) #integer
attributes(x) #"factor"


###PIPES %>%
are part of tidyverse (magrittr)

pryr::object_size() confirms that pipes don't fill up memory as you might expect. 

often more readable than nested functions.

don't:
  -string together a ton (hard to debug)
  -use when multiple inputs/outputs involved
  -use for complex, nonlinear code
  
%T% :runs code after it, but returns output of function before. Good if you want to add a save function to the end of a pipe sequence, for example.

%$% 'explodes' variables out of a df, so you don't have to refer to base object. ex:
mtcars %$%
  cor(disp, mpg)
  
%<>% is like += genericized to other functions. scary. 

  mtcars <- mtcars %>% 
    transform(cyl = cyl * 2)
  
  vs  
  
  mtcars %<>% transform(cyl = cyl * 2)