
# 1. Assign Values

  a <- 3
  print(a)
  
  b <- a*a
  print(b)
  
  x <- "Hello!"
  print(x)
  

# 2. Data Type
  
  ## 2.1: Basic data types: Numeric, Character, and Logical
  x <- 5
  class(x)
  
  y <- "Hello World!"
  class(y)
  
  z <- TRUE
  class(z)
  
  ## 2.2: Storing data object: Vector, Matrix, and DataFrame
  
    ### 2.2.1: Vector
    id <- 1:4
    print(id)
    class(id)    # Output: "integer"
    
    score <- c(30, 86, 50, 95)
    print(score)
    class(score) # Output: "numeric"
    
    name <- c("Sam", "John", "Andy", "Judy") 
    print(name)
    class(name)  # Output: "character"
    
    ### 2.2.2: List
    my_list <- list("Hello World!", 1, TRUE, score)
    print(my_list)
    class(my_list)
    
    
    ### 2.2.3: Matrix
    id <- 1:4
    score <- c(30, 86, 50, 95) 
    id_score <- matrix(c(id, score), nrow = 4)
    print(id_score)
    class(id_score)
    
    ### 2.2.4: DataFrame
    df <- data.frame(stu_id = id, 
                     stu_score = score)
    print(df)
    class(df)
    
  

# 3. Install Packages
    
  ## install the package to your RStudio
  install.packages("tidyverse")
  
  ## load the package so you can use
  library(tidyverse)
  

# 4. Learn to use a function: `help()`
  
  help(mean)
  help(sd)
  ?mean

