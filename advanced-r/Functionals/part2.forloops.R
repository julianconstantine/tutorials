# ADVANCED R: FUNCTiONALS
# Link: http://adv-r.had.co.nz/Functionals.html

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