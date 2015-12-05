# ADVANCED R: FUNCTiONALS
# Link: http://adv-r.had.co.nz/Functionals.html

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