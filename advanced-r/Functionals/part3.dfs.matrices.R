# ADVANCED R: FUNCTiONALS
# Link: http://adv-r.had.co.nz/Functionals.html

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