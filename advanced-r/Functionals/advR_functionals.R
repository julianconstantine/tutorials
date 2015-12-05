# ADVANCED R: FUNCTiONALS
# Link: http://adv-r.had.co.nz/Functionals.html

# HIGHER-ORDER FUNCTIONS
# Functions that map functions to functions (yo dawg!)
#   1. CLOSURE: Maps vector to function
#   2. FUNCTIONAL: Maps function to vector

# Example
# randomise(f) takes a function f and evaluates it at a randomly generated vector of 1000 standard normal variables
randomise <- function(f) f(runif(1000))

randomise(mean)  # Returns: 0.5120823
randomise(mean) # Returns: 0.4970858
randomise(sum) # Returns: 517.4219

# FUNCTIONALS can often replace FOR LOOPS, because they are (often) faster and more "expressive"
# In general, using the apply() series of functionals can replace a lot of for loops


# (1) MY FIRST FUNCTIONAL: LAPPLY()
# Takes a list and a function, applies function to each element of the list, and returns a modified list

# Example:
# Below we create a list of 20 elements, each containing between 1-10 standard uniform random numbers
l <- replicate(20, runif(sample(1:10, 1)), simplify=FALSE)

# Next, we use a for loop and the unlist() function to create a vector containing the size of each list element 
out <- vector("list", length(l))
for (i in seq_along(l)) {
  out[[i]] <- length(l[[i]])
}

unlist(out)

# Now do this in one line using lapply()
unlist(lapply(l, FUN=length))

# Simplify even further using sapply()
sapply(l, FUN=length)

# data.frames are also lists (of vectors), so we can use lapply()
unlist(lapply(mtcars, FUN=class))  # Tells us the data type of each column in mtcars

sapply(mtcars, FUN=class) # Does the same

# Overwrites mtcars data set by dividing each column by its mean
mtcars2 <- lapply(mtcars, FUN=function(x) x/mean(x))

# Equivalent way of doing this
# Essentially, the above method does everything in one line by defining the function to be used by lapply() inside lapply()'s FUN argument itself
normalize <- function(x) x/mean(x)
mtcars_lapply <- lapply(mtcars, FUN=normalize)

# Pure R implementation of lapply()
lapply2 <- function(x, f) {
  out <- vector(mode="list", length=length(x))
  
  for (i in seq_along(x)) {
    out[[i]] <- f(x[[i]])
  }
  
  return(out)
}

# Looping
# There are three basic ways to loop over a vector:
#   1. Over its elements: for (x in vec)
#   2. Over its indices: for (i in seq_along(vec))
#   3. Over its names: for (n in names(vec))

# FORM #1
# This is slow b/c it's natural to save the data by extending a data structure
# In this loop, you must copy the contents of res each iteration, which is time consuming
res <- c()
xvec <- runif(1000)

for (x in xvec) {
  res <- c(res, sqrt(x))
}

# FORM #2
# It's much better to initialize res to the desired length ahead of time so use the second form
# seq_along(x) is the same thing as 1:lenth(x) 
res <- numeric(length(xvec)) # By doing numeric(1000), you get a vector of 1000 zeroes

for (i in seq_along(xvec)) {
  res[i] <- sqrt(xvec[i])
}

# Three corresponding ways to use lapply()
# Typically, use the first form b/c lapply() automatically saves the output for you
lapply(xvec, function(x) {})
lapply(seq_along(xvec), function(i) {})
lapply(names(xvec), function(n) {})


# (2) FOR LOOP FUNCTIONALS: FRIENDS OF LAPPLY()

# Vector Output: vapply() and sapply()
# Similar to lapply(), but sapply() simplifies the output to an atomic vector (instead of a list) by "guessing" the most relevant type and vapply() takes another argument that tells it what to simplify to

# Returns vector of Booleans indicating if the columns of mtcars are numeric variables
sapply(mtcars, FUN=is.numeric)

# Does the same, requires specification of FUN.VALUE (not sure why)
vapply(mtcars, FUN=is.numeric, FUN.VALUE=logical(1))

# Runs is.numeric() columnwise on an empty list. Returns: list()
sapply(list(), FUN=is.numeric)

# Does the same, using vapply() with the output specified as a logical. Returns: logical(0)
vapply(list(), FUN=is.numeric, FUN.VALUE=logical(1))

# Comparison of sapply() and vapply()
df <- data.frame(x = 1:10, y = letters[1:10])

# Get data type of columns of df
# Here, sapply() and vapply() are the same
sapply(df, FUN=class) # Returns: "integer"   "factor"
vapply(df, FUN=class, FUN.VALUE=character(1)) # Returns: "integer"   "factor"

df2 <- data.frame(x = 1:10, y = Sys.time() + 1:10)

# Here, vapply() returns an error because y has more than one class value 
# The problem is with FUN.VALUE, which assumes each column will only return a character vector of length 1 when applied to each column
sapply(df2, FUN=class)
vapply(df2, FUN=class, FUN.VALUE=character(1))

# Pure R implementation of sapply() and vapply() 
sapply2 <- function(x, f) {
  res <- lapply(x, FUN=f)
  
  return(simplify2array(res))
}

vapply2 <- function(x, f, f.value) {
  out <- matrix(rep(f.value, times=length(x)), nrow=length(x))
  
  for (i in seq_along(x)) {
    res <- f(x[i])
    
    stopifnot(length(res) == length(f.value), typeof(res) == typeof(f.value))
    
    out[i, ] <- res
  }
  
  return(out)
}

# Multiple inputs: Map and mapply()
# Generate some fake data (as lists)
xvec <- replicate(n=5, expr=runif(n=10), simplify=FALSE)
wvec <- replicate(n=5, expr=rpois(n=10, lambda=5)+1, simplify=FALSE)

# Calculate 
unlist(lapply(xvec, FUN=mean))

# What about calculating weighted means? We can't pass additional arguments to lapply()
# One way to do this is with this ugliness

# Returns: 0.4632933 0.5221773 0.5098282 0.5690094 0.6169042
unlist(lapply(seq_along(xvec), FUN=function(i) {
  weighted.mean(xvec[[i]], wvec[[i]])
  }))

# A better way is to use the Map() version of lapply()
# Map() is used whenever you want to pass multiple arguments to the function in lapply(), i.e. when you have two or 
# more lists you want to process in parallel
unlist(Map(f=weighted.mean, xvec, wvec)) # Returns: 0.4632933 0.5221773 0.5098282 0.5690094 0.6169042

# Use Map() to normalize columns of mtcars
# Equivalent to: mtcars[] <- lapply(mtcars, function(x) x / mean(x))
mtmeans <- lapply(mtcars, FUN=mean)
mtmeans[] <- Map(f="/", mtcars, mtmeans)

# Map() is equivalent to mapply() with simplify=FALSE. Wickham likes Map() better

# Example: Rolling Computations
# Want to smooth data using a "rolling" mean function

rollmean <- function(x, n) {
  out <- rep(NA, times=length(x))
  
  offset <- trunc(n/2)
  
  for (i in (offset + 1):(length(x) - n + offset + 1)) {
    out[i] <- mean(x[(i - offset):(i + offset - 1)])
  }
  
  return(out)
}

x <- seq(from=1, to=3, length=100) + runif(100)
plot(x)

lines(rollmean(x, n=5), col="blue", lwd=2)
lines(rollmean(x, n=10), col="red", lwd=2)

# What if we want to do a rolling median? Instead of creating a new function rollmedian(), we can write a general
# function called rollapply()
# NOTE: You don't need to do ANYTHING special to pass functions as arguments to other functions. There are no 
#       function handles like in MATLAB. Yaaaaay :)

rollapply <- function(x, n, f) {
  out <- rep(NA, times=length(x))
  
  offset <- trunc(n/2)
  
  for (i in (offset + 1):(length(x) - n + offset + 1)) {
    out[i] <- f(x[(i - offset):(i + offset - 1)])
  }
  
  return(out)
}

plot(x)
lines(rollapply(x, n=5, f=median), col="red", lwd=2)

# Another way to write the rollapply() function is to use vapply() within it
# This is the way rollapply() is written in the zoo package

rollvapply <- function(x, n, f) {
  offset <- trunc(n/2)
  locs <- (offset + 1):(length(x) - n + offset + 1)  
  
  num <- vapply(locs, FUN=function(i) f(x[(i - offset):(i + offset)]), FUN.VALUE=numeric(1))
  
  return(c(rep(NA, times=offset), num))
}

# This gives the same thing as before
plot(x)
lines(rollvapply(x, n=5, f=median), col="blue", lwd=2)

# Parallelization
# Because lapply() performs calculations the same whatever the order of the data, we can easily parallelize things
# I am not going to get into this, but I will show that it's actually true below

# Consider this (pure R) implementation of lapply() which "scrambles" the order of computation

lapply3 <- function(x, f) {
  out <- vector(mode="list", length=length(x))
  
  for (i in sample(seq_along(x))) {
    out[[i]] <- f(x[[i]])
  }
  
  return(out)
}

# These return the same thing eve
unlist(lapply(1:10, FUN=sqrt))
unlist(lapply3(1:10, f=sqrt))


# (3) MANIPULATING MATRICES AND DATA FRAMES
# apply(), sweep(), and outer() work with matrices
# tapply() summarizes a vector based on groups defined by another vector
# The plyr package generalizes the tapply() function

# Matrix Function #1: apply()
A <- matrix(1:20, nrow=5)
apply(A, MARGIN=1, FUN=mean) # Calculates row (MARGIN=1) means

apply(A, MARGIN=2, FUN=mean) # Calculates column (MARGIN=2) means

# apply() has no simplify argument, so you can never be sure what type of output you will get
A1 <- apply(A, MARGIN=1, FUN=identity) # Transposes A and stores it as A1
identical(A, A1) # Returns FALSE b/c A is not symmetric

A2 <- apply(A, MARGIN=2, FUN=identity) # Does not transpose A
identical(A, A2) # Returns TRUE

# Matrix Function #2: sweep()
# Allows you to "sweep out" summary statistics from an array
X <- matrix(rnorm(n=20, mean=0, sd=10), nrow=4)

# Subtract minimum value of each row of X from each entry in that row
X1 <- sweep(X, MARGIN=1, STATS=apply(X, MARGIN=1, FUN=min), FUN="-") 

# Divide each entry in each row of X1 by the maximum value of that row
X2 <- sweep(X1, MARGIN=1, STATS=apply(X1, MARGIN=1, FUN=max), FUN="/")

# Matrix Function #4: outer()
# outer() takes in multiple vector inputs and returns a matrix/array where the input function is run over
# every combination of the input vectors
# It's called "outer" because it takes OUTER PRODUCTS of vectors X and Y

outer(X=1:3, Y=1:10, FUN="*") # Returns a 3x10 outer product matrix of 1:3 and 1:10. 

# Group Apply (tapply() Function)
# tapply() is a generalization of apply() which allows for "ragged" arrays, which have a different
# number of columns per row

# Creates vector of 22 N(22, 100/9) variables plus constants
pulse <- round(rnorm(n=22, mean=70, sd=10/3)) + rep(c(0, 5), times=c(10, 12))

# Creates vector of 10 A's followed by 12 B's
group <- rep(c("A", "B"), times=c(10, 12))

# Calculates number of A's and number of B's
tapply(pulse, INDEX=group, FUN=length)

# Returns:
#  A  B
# 10 12

# Calculates the average of pulse over the groups A and B
# Results are SLIGHTLY DIFFERENT each time because we're using rnorm()
tapply(pulse, INDEX=group, FUN=mean)

# Returns:
#        A        B 
# 70.20000 75.08333 

# tapply() is really just a combination of of split() and sapply()
# split() first splirts pulse into chunks corresponding to the different levels of group
split(pulse, f=group)

# Pure R implmentation of tapply()
tapply2 <- function(x, index, f, simplify=TRUE) {
  # Split x into groups by index and then apply the function f to each group
  pieces <- split(x, index)
  return(sapply(pieces, FUN=f, simplify=simplify))
}

# Calculates means again
tapply2(pulse, group, f=mean)

# Returns: 
#        A        B 
# 70.20000 75.08333 


# The plyr package
# The "apply" series of functions has grown organically over time, so the syntax is not standardized and the functions don't cover all possible cases of data structures 
# Uses the "split-apply-combine" strategy to split the input into pieces, apply a function to each piece, and then combine the pieces into output

# BUILT-IN FUNCTIONALS
# lapply(): list -> list
# sapply(): list -> array
# apply(): array -> array

# PLYR FUNCTIONALS
# llply(): list -> list
# ldply(): list -> data.frame
# laply(): list -> array
# dlply(): data.frame -> list
# ddply(): data.frame -> data.frmae
# daply(): data.frame -> array
# alply(): array -> list
# adply(): array -> data.frame
# aaply(): array -> array


# (4) MANIPULATING LISTS
# Can also think of functionals as tools for altering, subsetting, and collapsing lists
# Three functions for this: Map(), Reduce(), and Filter()

# List Function #1: Map()
# We already covered this

# List Function #2: Reduce()
# Reduces a vector to a single value by recursively calling a function two arguments at a time
# Extends a function that works on two inputs to work on many inputs
# Reduce() is also know as "fold"

# Examples:
Reduce(f="+", 1:3)  # (1+2)+3 = 6
Reduce(f=sum, 1:3)  # sum(sum(1,2),3) = 6

# Pure R implementation of Reduce()
Reduce2 <- function(f, x) {
  out <- x[[1]]
  
  for (i in seq(2, length(x))) {
    out <- f(out, x[[i]])
  }
  
  return(out)
}

# Reduce() is useful for performing recursive operations, like merges, intersections, etc.

# Example: Finding intersections of sets
# Creates five-element list each containing 15 randomly selected integers between 1 and 10 
l <- replicate(n=5, expr=sample(1:10, size=15, replace=TRUE), simplify=FALSE)

# Find intersection manually
intersect(intersect(intersect(intersect(l[[1]], l[[2]]), l[[3]]), l[[4]]), l[[5]])

# Now use Reduce()
# This should return the same thing
Reduce(f=intersect, l)


# Predicate Functionals
# A predicate is a function that returns a single Boolean value, e.g. is.numeric() or is.na()
# Three predicate functionals in base R:
#   1. Filter(): selects only elements matching predicate
#   2. Find(): returns first element that matches predicate
#   3. Position(): returns the position of the first element that matches oredicate

# Example: Using predicate functionals
# Implement where() function
where <- function(f, x) {
  return(vapply(x, f, logical(1)))
}

df <- data.frame(x = 1:3, y = c("a", "b", "c"))

# Indicate whether columns of df that are factor variables
where(is.factor, df)

# Returns:
#     x     y 
# FALSE  TRUE 

# Gets all columns of df that are factors
Filter(f=is.factor, df)  # Returns column y
class(Filter(f=is.factor, df))  # Returns "data.frame"

# Gets first column of df that is a factor
Find(f=is.factor, df)  # Returns elements of y
class(Find(f=is.factor, df))  # Returns "factor"

# Get position of first column of df that is a factor
Position(f=is.factor, df)  # Returns 2


# (5) MATHEMATICAL FUNCTIONALS