# clear the memory

rm(list = ls())
library(tidyverse)

# ==============================================
# 0. Import dataset
# ==============================================
china <- read.csv("data/china.csv")
book <- read.csv("data/textbooks.csv")
birth <- read.csv("data/ncbirths.csv")


# ==============================================
# 1. Control Flow
# ==============================================

# 1. for loop

## example 1
for (i in 1:5){
  print(i)
}

## example 2
for (j in c(1, -1, 1, 3, 0, -1)){
  print(j+1)
}

## example 3
for (k in seq(0, 10, by = 2)){
  print(k)
}


# 2. if-else

## example 1
score <- 95
if(score > 60){
  print("Pass the course!")
}else{
  print("Fail.")
}

## example 2
for (i in 55:65){
  if(i < 60){
    print("Fail.")
  }else if(i == 60){
    print("On the threshold.")
  }else{
    print("Pass the course!")
  }
}



# 3. self-defined function: function()

## example 1: define addition
add <- function(a, b){
  return(a+b)
}
add(50, 100)  

# ==============================================
# 2. Row / Column Sums
# ==============================================

# 1. Row-wise Totals in R: rowSums()

df <- data.frame(
  a = c(1, 2, 3),
  b = c(4, 5, 6)
)

# Add new column: Method 1
df$row_total1 <- df %>% rowSums()

# Add new column: Method 2
df["row_total2"] <- df %>% rowSums()

print(df)

# 2. Column-wise Totals in R: colSums()

df <- data.frame(
  a = c(1, 2, 3),
  b = c(4, 5, 6)
)

col_total <- df %>% colSums()

print(col_total)

# ==============================================
# 3. Hypothesis Testing: t-test
# ==============================================

# 1. one-proportion t-test

## example 1: Is the weekly childcare time (for male) equal to 25 hrs?
china <- china %>% 
  filter(child_care >= 0)

china_male <- china %>% 
  filter(gender == 1)

t.test(china_male$child_care,
       mu = 25, 
       conf.level = 0.95)

## example 2: Is the weekly childcare time less than 25 hrs?
t.test(china$child_care,
       mu = 25,
       alternative = "less",
       conf.level = 0.95)



# 2. paired sample t-test

## example: Does UCLA bookstore charge a different price of text?
t.test(book$ucla_new,
       book$amaz_new,
       paired = TRUE,
       coef.level = 0.95)


# 3. two independent sample t-test

## example: Do newborns’ weights differ btw smoking & nonsmoking mothers?
t.test(birth$weight ~ birth$habit,
       conf.level = 0.95)