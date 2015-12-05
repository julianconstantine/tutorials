# A TUTORIAL ON DATA STRUCTURES IN R
# LINK: http://blog.datacamp.com/a-tutorial-on-data-structures-in-r/
library("ggplot2")

# BASIC COMPOUND DATA STRUCTURES
#   1) Vectors (1-dimensional)
#   2) Matrices (2-dimensional)
#   3) Arrays (N-dimensional)
#   4) Lists (1-dimensional)
#   5) Data Frames (2-dimensional)


# 1) USING VECTORS IN R
# 1-Dimensional, sequential collections of homogeneous values
# Because vectors are homogeneous, values are coerced to be the same data type
c(2, "two")  # Returns "2"   "two"  (coerced 2 into a character)

# INITIALIZE A VECTOR
# I) Using the CONCATENATE FUNCTION
# This is what c() stands for!
v1 <- c(1, 2, 3, 4, 5, 1, 2, 3, 4, 5)  

# II) Using the REPLICATE FUNCTION
v2 <- rep(1:5, times=2)  

# III) Using the SEQUENCE FUNCTION
v3 <- rep(seq(from=1, to=5, by=1), times=2)  

# ACCESS VECTOR ELEMENTS
# Access elements with indices 5-10 (inclusive)
v1[5:10]  # Returns 5 1 2 3 4 5

# Access elements with indices 5, 7-10 (all are inclusive)
v2[c(5, 7:10)]  # Returns 5 2 3 4 5

# Remove elements with indices 7, 8, and 9
v4 <- v1[-(7:9)]  # v4 returns  1 2 3 4 5 1 5

# ASSIGN NAMES TO VECTOR ELEMENTS
# letters[1:N] returns a character vector containing the first N letters of the alphabet
names(v1) <- letters[1:length(v1)]

# Now, v1 will return the following
#   > v1
#   a b c d e f g h i j 
#   1 2 3 4 5 1 2 3 4 5

# This is kind of like a dictionary where the letters are the keys and the numbers are the values
# However, both v1[1] and v1['a'] return the same thing: 1 with the label a above it

# A simpler way to do this is to directly create a named vector
v6 <- c(a=1, b=6.1, c=9.0, d=0.7)

# Now we get
#   > v6
#     a   b   c   d 
#   1.0 6.1 9.0 0.7 

# SORTING AND ORDERING
# Sorting and ordering change the indices of the data, not the data itself
# sort() returns the values of a vector from highest to lowest
v1s <- sort(v1)  

# Now, we get
#   > v1s
#   a f b g c h d i e j 
#   1 1 2 2 3 3 4 4 5 5 

# order() returns the indices of the elements in sort(v2)
order(v2)  # Returns 1  6  2  7  3  8  4  9  5 10
v2[order(v2)]  # Equivalent to sort(v2); returns 1 1 2 2 3 3 4 4 5 5

# OTHER VECTOR STUFF
# unique() returns all the unique values, deleting repetitions
unique(v1)  # Returns 1 2 3 4 5

# is.vector() returns true if argument is a vector
is.vector(v1)  # TRUE
is.vector(4)  # TRUE
is.vector('hello')  # TRUE
is.vector(matrix(1))  # FALSE

# Clear vectors from workspace
rm(v1, v1s, v2, v3, v4, v6)


# 2) USING LISTS IN R
# Lists are generalized vectors that allow for heterogeneous data types
# Vectors, integers, strings, matrices, data.frames, functions, etc. can all be elements of a list
# Lists in R are like dictionaries in Python

# Create lists using the list() command and access elements using the extraction operator [[ 
MyList <- list()
MyList[["bae"]] <- "Nina"
MyList[[2]] <- c(1, 2, 3)

# Now we will see how LISTS function VERY SIMILARLY to PYTHON DICTIONARIES
# Run this code and we get
#   > MyList
#   $bae
#   [1] "Nina"
#
#   [[2]]
#   [1] 1 2 3

# ACCESSING LIST ELEMENTS
MyList[["bae"]]  # Returns "Nina"
class(MyList[["bae"]])  # Returns "character"

# MyList is a 1-dimensional list object of length 2
length(MyList)  # Returns 2

# The elements of MyList are "labeled buckets" that hold the "objects" we put into the list
# The "buckets" are sublists, analogous to key:value pairs in Python dictionaries
# The "labels" are the indices of the "buckets," analogous to keys in Python dictionaries  
# The "objects" are the things stored in the bucket, analogous to values in Python dictionaries

# Accesses first element/"bucket"/key:value pair of MyList
MyList[1]  # Returns $bae  "Nina"
class(MyList[1])  # Returns "list"

# Accesses the object/value in the first "bucket"/key:value pair of MyList
MyList[[1]]  # Returns "Nina"
MyList[["bae"]]  # Returns "Nina"
class(MyList[[1]])  # Returns "character"

# unlist() creates a named (when possible) vector containing all the values in the elements of MyList
unlist(MyList)

# > unlist(MyList):
#    bae                      
# "Nina"    "1"    "2"    "3" 

length(unlist(MyList))  # Returns 4
names(unlist(MyList))  # Returns "bae" ""    ""    ""


# 3) USING FACTORS IN R
# Factors are a special type of vector that allows for the processing of non-numeric data
# They take on a finite number of values called "levels"
# Factors are essentially a way of getting around the problem of heterogeneous data types in vectors. It turns everything you want to put in the vector into a single data type ("levels"), which only take on a finite number of values. Thus, a factor variable is a sort of "vector of levels"

# Generates a sample from the vector lev with replacement and stores as factor variable
lev <- c("Red", "Green", "Blue")
x <- factor(sample(lev, size=7, replace=TRUE))

# Summary of factor variable x
table(x)

# Returns
#   > table(x)
#   x
#    Blue Green   Red 
#       2     4     1 


# 4) USING MATRICES IN R
# Matrices are 2-dimensional equivalents of vectors, so they must contain homogeneous elements
# You can think of them as "vectors of vectors"

# Create matrices
# NOTE: byrow=FALSE is the default method
A <- matrix(1:4, nrow=4, ncol=4)  # Returns 4x4 matrix whose columns are (1, 2, 3, 4)

B <- matrix(3:5, nrow=4, ncol=4)  # Returns 4x4 matrix whose elements are 3, 4, 5 repeated columnwise

C <- matrix(3:6, nrow=4, ncol=4, byrow=TRUE)  # Returns 4x4 matrix whose rows are (3, 4, 5, 6)

D <- matrix(3:6, nrow=4, ncol=4, byrow=FALSE)  # Returns 4x4 matrix whose columns are (3, 4, 5, 6)

D2 <- t(D)  # Transposes D (euivalent to C)

# ROW AND COLUMN BINDING (rbind() and cbind() functions)
# Binds 3 copies of (1, 2, 3, 4) together as columns to form a 4x3 matrix
A2 <- cbind(c(1, 2, 3, 4), c(1, 2, 3 ,4), c(1, 2, 3, 4))  

# Binds vectors (1, 5) and (7, 2) together as columns to form 2x2 matrix
A3 <- cbind(c(1, 5), c(7, 2))  

# Binds 4x4 matrices A and B together by row to form an 8x4 matrix
A4 <- rbind(A, B)

# MATRICES VS. VECTORS
v1 <- rep(1:3, 2)
M <- rbind(v1, 1:3)

# Vectors have LENGTH but NOT DIMENSION
length(v1)  # Returns 6
dim(v1)  # Returns NULL

# Matrices have BOTH "length" (number of elements) AND dimension
length(M)  # Returns 12, so M has 12 elements (2x6)
dim(M)  # Returns 2 6, so M is a 2x6 matrix

# ELEMENT HOMOGENEITY
v1 <- c(1:10)  # Numeric vector
v2 <- rep(c("blah", "this", "is", "utter", "nonsense"), times=2)  # Character vector

# cbind() coerces v1 to a character vector because the elements of N must be homogeneous data types
N <- cbind(v1, v2)

# typeof() function returns the type of element in a multidimensional object
typeof(N) # Returns "character"
class(N)  # Returns "matrix"

# typeof() and class() are NOT necessarily equivalent for 1-dimensional objects
typeof(1)  # Returns "double"
class(1)  # Returns "numeric"

# But with characters, typeof() and class() are equivalent
typeof("a")  # Returns "character"
class("a")  # Returns "character"

# The difference between 1:5 = c(1:5) and c(1, 2, 3, 4, 5) is that the latter defaults to numeric elements and the former defaults to integer elements
# The NUMERIC class is IDENTICAL to DOUBLE or REAL
class(c(1:5))  # Returns "integer", equivalent to class(1:5)
typeof(c(1:5))  # Returns "integer", equivalent to typeof(1:5)

class(c(1, 2, 3, 4, 5))  # Returns "numeric"
typeof(c(1, 2, 3, 4, 5))  # Returns "double"

# Clear console
rm(A, A2, A3, A4, B, C, D, D2, M, N, v1, v2)

# HIGHER-DIMENSIONAL ARRAYS
# "Array" is a generic term for any object with homogeneous data, of whatever dimension

# Creates a 2x2x2 array
Y <- array(rnorm(2*2*2), dim=c(2, 2, 2))

class(Y)  # Returns "array"
typeof(Y)  # Returns "double"
dim(Y)  # Returns 2 2 2
length(Y)  # Returns 8


# 4) USING DATA FRAMES IN R
# Data frames are LISTS of VECTORS

# Create a data frame
letts <- c("a", "b", "c", "d", "e")
MyData <- data.frame(v1=c(1:20), x=rnorm(20), y=sample(c(TRUE, FALSE), size=20, replace=TRUE), z=letts)


# INTERNAL STRUCTURE OF DATA FRAMES
# The ELEMENTS of the DATA FRAME object are LISTS
class(MyData)  # Returns "data.frame"
typeof(MyData)  # Returns "list"

# Examine the columns of MyData. 
# IMPORTANT: MyData[, 1], MyData[[1]], MyData$v1, and MyData[["v1]] are equivalent
# They are all one-dimensional integer (row) vectors of length 20, but NULL dimension

# Access first column
col1 <- MyData[, 1]  # Returns: [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
class(col1)  # Returns "integer"
typeof(col1)  # Returns "integer"
length(col1)  # Returns 20
dim(col1)  # Returns NULL

# Access value inside first list object
MyData[[1]]  # Returns: [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
class(MyData[[1]])  # Returns "integer"
typeof(MyData[[1]])  # Returns "integer"
length(MyData[[1]])  # Returns 20
dim(MyData[[1]])  # Returns NULL

# Access column with name v1
MyData$v1  # Returns: [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
class(MyData$v1)  # Returns "integer"
typeof(MyData$v1)  # Returns "integer"
length(MyData$v1)  # Returns 20
dim(MyData$v1)  # Returns NULL

# Access value inside list with name/key "v1"
MyData[["v1"]]  # Returns: [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
class(MyData[["v1"]])  # Returns "integer"
typeof(MyData[["v1"]])  # Returns "integer"
length(MyData[["v1"]])  # Returns 20
dim(MyData[["v1"]])  # Returns NULL

# HOWEVER, MyData[1] is different
# MyData[1] is a data frame containing a single element, which is a list containing the vector v1
# MyData[1] returns what looks like a named column vector, with the rows labeled by numbers 1-20 and the column labeled by v1. The fact that it displays the vector v1 as a column is because MyData[1] is a data frame object
MyData[1]  
class(MyData[1])  # Returns "data.frame"
typeof(MyData[1])  # Returns "list"
length(MyData[1])  # Returns 1, because it's a list with only one "key:value" pair
dim(MyData[1])  # Returns 20  1

# MANIPULATING COLUMNS AND ROWS
str(MyData)  # Returns column names, data types, and displays the first couple of values in each column

names(MyData)  # Returns "v1" "x"  "y"  "z" (column names)
colnames(MyData)  # Same as above
rownames(MyData)  # Returns 1" ... "20" (row names are just numbers as characters)

MyData2 <- MyData 

# All four of these delete the the first column from MyData2
MyData2[1] <- NULL  
MyData2[[1]] <- NULL  
MyData2$v1 <- NULL
MyData2[["v1"]] <- NULL

# Copies fourth column of MyData into MyNewData as a vector
MyNewData <- MyData[, -(1:3)]  
names(MyNewData)  # Returns NULL
class(MyNewData)  # Returns "factor"

# Copies fourth column of MyData into MyNewData as a data frame
MyNewData2 <- MyData[, -(1:3), drop=FALSE]
names(MyNewData2)  # Returns "z"
class(MyNewData2)  # Returns "data.frame"

# Adds column called Types containing the first 20 capital letters
MyData$Types <- LETTERS[1:20] 

# Adds column called Descript containing letters a, b repeated 10 times
MyData$Descript <- rep(letters[1:2], times=10)

# Renames Descript to Coding
colnames(MyData)[6] <- "Coding"

# INSPECTION AND CONVERSION FUNCTIONS
# Inspection functions: is.class()
is.character(MyData$Types)  # Returns TRUE

# Conversion functions: as.class()
as.factor(MyData$Types) # Returns first 20 letters coded as factors

# SORTING DATA FRAMES
# To sort data frames by the values in a column, we need to use order(), not sort()
# order() will return the appopriate sorted indices, which we use to access the new sorted data
# sort() will just return the sorted data

sort(MyData$x) # Returns column MyData$x in increasing order, but not whole data frame

# Returns MyData sorted in ascending order in the values of x, by row
# DEFAULT order() is in increasing order
MyData[order(MyData$x), ] 

# These both sort the rows in MyData by descending order in the values of x
MyData[order(MyData$x, decreasing=TRUE), ]
MyData[order(-MyData$x), ]


# PLOTTING
library("ggplot2")

# Gets all observations in MyData st x > 0 and y is FALSE
# NOTE: You must use a SINGLE ampersand & NOT a DOUBLE ampersand && else this will not subset properly
MyDataPF <- MyData[MyData$x > 0 & MyData$y == FALSE, ]

# Creates bar graph of Types vs. x colored by Coding
plot <- ggplot(MyDataPF, aes(x=Types, y=x)) + geom_bar(stat="identity", aes(fill=Coding))
plot <- plot + ggtitle("All positive x with false y type")
plot

# NOTE: For a scatterplot geom_point(), you must specify color in aes(), NOT fill
# But a scatterplot doesn't really work here
