# ADVANCED R: FUNCTiONALS
# Link: http://adv-r.had.co.nz/Functionals.html

# (6) LOOPS THAT SHOULD BE LEFT AS IS
# Some loops have no natural functional equivalent.
# Three of the most important examples are:
#   1. Modifying in place
#   2. Recursive functions
#   3. While loops

# (6.1) MODIFYING IN PLACE
# "Modifying in place" is (I think) when you are making "changes" to a specific object that you input into the loop, rather than returning a new object.
# Wickham didn't make this 100% clear

trans <- list(disp=function(x) x*0.0163871, am=function(x) factor(x, levels = c("auto", "manual")))

# This overwrites some of the data (in the disp and am columns).
# You want to use a for loop for overwriting data ('Modifying in place"
for(var in names(trans)) {
  mtcars[[var]] <- trans[[var]](mtcars[[var]])
}

# We could do this with lapply() but it's ugly
lapply(names(trans), function(var) {
  mtcars[[var]] <<- trans[[var]](mtcars[[var]])
})

# (6.2) RECURSIVE RELATIONSHIPS
# Converting for loops to functionals is difficult when the relationship between elements is defined recursively or not independent(?)

# Example: Exponential smoothing
# We can't eliminate the for loop b/c none of the functionals we have can calculate the ith output based on both the ith and (i-1)st inputs
# Alternatively, one can replace the for loop by solving the recurrence relation (...)
exp_smooth <- function(x, alpha) {
  s <- numeric(length(x)+1)
  
  for (i in seq_along(s)) {
    if (i == 1) {
      s[i] <- x[i]  # Recursion up in this bitch
    } else {
      s[i] <- alpha*x[i-1] + (1-alpha)*s[i-1]  # Moar r3curs10n
    }
  }
  
  return(s)
}

x <- runif(50)

# Runs exponential smoother
exp_smooth(x, alpha=0.5)

# (6.3) WHILE LOOPS
# For loops can be rewritten as while loops, but not vice versa. While loops are more general and, unlike for loops, do not know in advance how many times they will be run

# Example 1: A while loop that can be re-written as a for loop
i <- 1

while(i <= 10) {
  print(i)
  i <- i + 1
}

# Rewrite as:
for (i in 1:10) {print(i)}

# Example 2: A while loop that cannot be re-written as a for loop
i <- 0

while(TRUE) {
  if (runif(1) > 0.9) {
    break
  }
  
  i <- i + 1
}
