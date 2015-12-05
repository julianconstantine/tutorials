# ADVANCED R: FUNCTiONALS
# Link: http://adv-r.had.co.nz/Functionals.html

# (7) A FAMILY OF FUNCTIONS
# Let's write our own version of addition

add0 <- function(x, y) {
  # stopifnot() validates the input to make sure it's correct. What a cool function!
  stopifnot(length(x) == 1, length(y) == 1, is.numeric(x), is.numeric(y))
  
  return(x + y)
}

# Now let's add our own function to remove NA's
rm_NA <- function(x, y, identity) {
  if (is.na(x) && is.na(y)) {
    return(identity)
  } else if (is.na(x)) {
    return(y)
  } else {
    return(x)
  }
}

rm_NA(NA, 10, 0)  # Returns 10
rm_NA(10, NA, 0)  # Returns 10
rm_NA(NA, NA, 0)  # Returns 0

# Now let's combine the two to have an add function that returns 0 when both operands are NA
add <- function(x, y, na.rm = FALSE) {
  if (na.rm && (is.na(x) || is.na(y))) {
    return(rm_NA(x, y, 0))
  } else{
    return(x + y)
  }
}

add(10, NA)  # Returns NA
add(10, NA, na.rm = TRUE)  # Returns 10

add(NA, NA)  # Returns NA
add(NA, NA, na.rm = TRUE)  # Returns 0
  