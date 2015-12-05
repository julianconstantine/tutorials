# DATA TABLE TUTORIAL
install.packages("data.table")
library("data.table")

# Cast mtcars data frame as data table
mtcarsDT <- as.data.table(mtcars)

# CHAPTER 1: DATA TABLE "NOVICE"
# The free version only includes the first chapter :(

# SECTION 1: INTRODUCTION
# QUERIES WITH DATA TABLES
# The code below does the following:
#   (i)  SUBSETS     mpg > 20 (cars with mileager greater than 20 mpg)
#   (j)  CALCULATES  AvgHP (average horsepower); MinWT (minimum weight of all cars in subset)
#   (by) GROUPED BY  cyl (number of cylinders); under5gears (TRUE if number of gears is < 5)
# NOTE: i, j, by in R is analogous to WHERE, SELECT, GROUP BY in SQL

mtcarsDT[
  i = mpg > 20,                                          
  j = .(AvgHP = mean(hp), "MinWT(kg)" = min(wt*453.6)),  
  by = .(cyl, under5gears = gear < 5)                
]

# Create another data table
# B and D are RECYCLED (repeated twice and six times, respectively) to match the length of A and C 
DT <- data.table(A = 1:6, B = c("a", "b", "c"), C = rnorm(6), D = TRUE)
DF <- as.data.frame(DT)

# INTERNAL STRUCTURE OF DATA TABLE OBJECTS
# IS-A INHERITANCE: A data.table "is a" data.frame. All data.frame methods work with data.tables
# Actually, I'm not sure if this is correct. It might be only for C++ or I might just have it wrong
is.data.frame(DT)  # Returns: TRUE
is.data.table(DF)  # Returns: FALSE

# LIKE data frames, data tables are "lists of vectors"
names(DT)  # Returns: [1] "A" "B" "C" "D"
class(DT)  # Returns: "data.table" "data.frame"
dim(DT)  # Returns: 6 4
typeof(DT)  # Returns: "list"
length(DT)  # Returns: 4

# UNLIKE data frames, DT[1] accesses the FIRST ROW
# DT[1] is a data.table/data.frame containing four lists (variables), containing one value (observation)

DT[1]  # Returns:
#    A B          C    D
# 1: 1 a -0.8632018 TRUE

class(DT[1])  # Returns: "data.table" "data.frame"
typeof(DT[1])  # Returns: "list"
dim(DT[1])  # Returns: 1 4
length(DT[1])  # Returns: 4

# LIKE data frames, DT[[1]] acceses the FIRST COLUMN (i.e. the first element in the list)
# DT[[1]] is an integer vector containing all six observations of the variable A
# NOTE: DT[[1]] is equivalent to DT[["A]] and DT$A

DT[[1]]  # Returns: [1] 1 2 3 4 5 6
class(DT[[1]])  # Returns: "integer
typeof(DT[[1]])  # Returns: "integer"
dim(DT[[1]])  # Returns: NULL


# SELECTING ROWS IN I
# Selects rows three through five
# Works the SAME for data tables and data frames
DT[3:5, ]
DF[3:5, ]

# Selects rows three through five for data tables
DT[3:5]

# Gives error for data frames
DF[3:5]


# SECTION 2: SELECTING COLUMNS IN J
# Select columns using the .() command
# .() is an alias to list() in the scope of a data.table object
# NOTE: You must include the comma unless you include the j argument! DT[.(B, C)] will NOT work!

# These all select columns B and C and return them as data.tables
DT[, .(B, C)]
DT[, list(B, C)]
DT[j = .(B, C)]
DT[j = list(B, C)]
DT[, j = .(B, C)]
DT[, j = list(B, C)]

# Different ways to select column B
DT[, .(B)]  # Returns as data table
DT[, B]  # Returns as vector
DT$B  # Returns as vector

# COMPUTING ON COLUMNS
# These both compute the sum of column A and the mean of column C
DT[, .(TotalA = sum(A), MeanC = mean(C))]
DT[j = .(TotalA = sum(A), MeanC = mean(C))]

# If one of your column operations produces a result that is shorter than another, the result will be "recycled" to fill in a longer column so that everything matches
# This calculates the sum of all values in C and "recycles" it 6 times for each value in B
DT[, .(B, TotalC = sum(C))]

# OTHER USES OF J
# j can do pretty much anything. It doesn't just have to calculate statistics. It is a general way of selecting/manipulating columns of a data table

# EXAMPLE: Plotting 
# These both plot A values on the x-axis and corresponding C values on the y-axis
DT[, plot(A, C)]
DT[, j = plot(A, C)]

# EXAMPLE: Multiple j commands
# For some reason this doesn't work if it's all on one line
DT[, { print(A) 
       hist(C) 
       NULL     }]


# SECTION 3: DOING J BY GROUP
# Calculates sum and mean of column C by (factor of) B
DT[, j = .(SumC = sum(C), MeanC = mean(C)), by = .(B)]

# Can also use FUNCTION CALLS in by
# NOTE: The MODULO operator %% in R requires TWO PERCENT SIGNS

# This calculates the sum of column C by Grp (defined by whether A is even or not, i.e. whether A %% 2 = 0 or A %% 2 = 1)
DT[, j = .(SumC = sum(C)), by = .(Grp = A %% 2)]

# To group only on a subset, just provide an argument for i 
# This calculates the same thing as above, but only for rows 2 through 4
DT[i = c(2:4), j = .(SumC = sum(C)), by = .(Grp = A %% 2)]
