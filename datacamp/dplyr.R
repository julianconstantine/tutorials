library("dplyr")
# install.packages("hflights")
library("hflights") # Will import hflights data.frame

# CHAPTER 1: DPLYR PACKAGE

# SECTION 1: INTRODUCTION
# Introduces "grammar" of data minipulation, has five "verbs." Pronounced "deplier"
# Code is written in C++ so it is very fast

# hflights data.frame records all flights to/from Houston in 2011

# Typing in "hflights" to the R Console well produce the "data deluge" (hehehe)
# To avoid this, convert it to a tbl (table). It will print out kind of like a data.table

# Display fits to console. Doesn't splurge all the rows AND only shows as many columns as fit in the console
hflights <- tbl_df(hflights)

# Another way to preview data
glimpse(hflights)

# SECTION 2: TABLES (TBL)
# Returns: "tbl_df"     "tbl"        "data.frame"
# So a tbl "is a" data.frame (or should this be "has a"? Or does this even make sense?)
class(hflights)

