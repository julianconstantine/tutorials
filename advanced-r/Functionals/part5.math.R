# ADVANCED R: FUNCTiONALS
# Link: http://adv-r.had.co.nz/Functionals.html

# (5) MATHEMATICAL FUNCTIONALS
# Limits, maxima, and definite integrals are all functionals!
# Why did I never think about them this way ... ?

# Examples:
# integrates sin(x) from 0 to pi
integrate(f=sin, lower=0, upper=pi)  # Returns 2

# Finds zeroes of sin(x) on [pi/2, 3pi/2] 
str(uniroot(f=sin, interval=c(pi/2, 3*pi/2)))  # Root is pi 

# Finds optimaa of sin(x) on [0, 2pi]
str(optimize(f=sin, interval=c(0, 2*pi)))  # Minimum is 4.71 (3pi/2), objective(?) value is -1

# Finds maximum value instead of minimum
# Presumably the optimize() function defaults to finding the minimum
str(optimize(f=sin, interval=c(0, 2*pi), maximum=TRUE))  # Maximum is 1.57 (pi/2), objective value is 1

# Example: Negative Log Likelihood
# Here, we have a function that returns ANOTHER function (the negative log-likelihood of the Poisson parameter lambda, given a bunch of data points)
# This makes poissonNLL() a CLOSURE, not a functional
poissonNLL <- function(x) {
  n <- length(x)
  sum.x <- sum(x)
  
  # Calculates negative log-likelihood function
  f <- function(lambda) {
    n*lambda - sum.x*log(lambda)  # NOTE: there would be OTHER terms
  }
  
  # Returns negative log-likelihood function
  return(f)
}

# Generate some data
x1 <- c(41, 30, 31, 38, 29, 24, 30, 29, 31, 38)
x2 <- c(6, 4, 7, 3, 3, 7, 5, 2, 2, 7, 5, 4, 12, 6, 9)

# Negative log-likelihood functions nll1() and nll2()
nll1 <- poissonNLL(x1)
nll2 <- poissonNLL(x2)

# Now, we can use optimize() to find the parameter lambda that minimizes the negative log-likelihood function that we just created
optimize(f=nll1, interval=c(0, 100))  # minimum: 32.10, objective: -792.50

optimize(f=nll2, interval=c(0, 100))  # minimum: 5.47, objective: -57.30

# These values are correct because (the wya our function is written) we just get the mean of the data as our objective value
# (WHY IS THIS TRUE? IT MUST BE BECAUSE WE LEFT OUF THE "OTHER TERMS NOT INVOLVING LAMBDA")
mean(x1)  # Returns 32.1
mean(x2)  # Returns 5.47

# NOTE: The optim() function is a multidimensional generalization of optimize()


# EXERCISES
# 1) Implement arg_max(). It should take a function and a vector of inputs, and return the elements of the input where the function returns the highest value. Also implement the matching arg_min() function.

arg_max <- function(f, interval) {
  maximizer <- optimize(f=f, interval=interval, maximum=TRUE)$maximum
  return(maximizer)
}

arg_max(f=function(x) x**2, interval=-10:5)
arg_max(f=function(x) x**2, interval=-5:5)
