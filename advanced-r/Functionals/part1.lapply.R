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