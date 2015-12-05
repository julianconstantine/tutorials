# TUTORIAL ON 'APPLY' FUNCTIONS
# Idea: Avoid use of loops when doing stuff to data
# Link: http://blog.datacamp.com/r-tutorial-apply-family/

# APPLY FUNCTION
# Syntax: apply(X, MARGIN, FUN)
# Parameters: 'X' is just some array; 'MARGIN' tells apply() to iterate over rows (MARGIN = 1), columns (MARGIN = 2), or both (MARGIN = c(1,2)); 'FUN' tells apply() which function to use
# If specifying arguments explicitly need to use all caps, i.e. MARGIN=1, not margin=1
# "Margins can be thought of as the same thing as "dimensions," which is why row sums have MARGIN=1, they are sums over the first dimension of the array

X <- matrix(rnorm(30), nrow=5, ncol=6)

apply(X, MARGIN=2, FUN=sum) # Returns column sums

apply(X, MARGIN=1, FUN=sum) # Returns row sums


# LAPPLY FUNCTION ("List Apply")
# Syntax: lapply(X, FUN, ...)
# Parameters: 'X' is some array, data.frame, list, etc.; 'FUN' is the function to apply to each element thereof
# lapply() returns a LIST that is the same length as the original input object

A <- matrix(1:9, nrow=3, ncol=3)
B <- matrix(4:15, nrow=4, ncol=3)
C <- matrix(8:10, nrow=3, ncol=2)

MyList <- list(A, B, C)

# EXTRACTION OPERATOR: "[" (you need to include the quotes)
# Extracts second column from each matrix in the list 
lapply(MyList, FUN = "[", , 2)

# Extracts first row from each matrix in the list
lapply(MyList, FUN = "[", 1, )

# Extracts the element in the first column of the third row from each matrix in the list
lapply(MyList, FUN = "[", 3, 1)


# SAPPLY FUNCTION ("Simplified Apply")
# Syntax/parameters are the same as before
# sapply() is like lapply() but it tries to simplify the output as much as possible
# Apparently this makes sapply() a function "wrapper" for lapply()

# Compare lapply() with sapply() in extracting the (2,1) element of each matrix

lapply(MyList, FUN = "[", 2, 1) # Returns a list
sapply(MyList, FUN = "[", 2, 1) # Returns a vector

sapply(MyList, FUN = "[", 2, 1, simplify=FALSE) # Returns a list again
unlist(lapply(MyList, FUN = "[", 2, 1)) # Converts list returned by lapply() into a vector


# REP FUNCTION ("Replicate")
# Replicates vectors, elements, etc. a specified number of times according to a specified rule
# Extracts first element of second row of each item in MyList
Z <- sapply(MyList, FUN = "[", 2, 1) 

# Replicates the first element of Z thrice, the second once, and the third twice
Z <- rep(Z, times=c(3, 1, 2)) 


# MAPPLY FUNCTION ("Multivariate Apply")
# Purpose: "Vectorize" arguments to a function that doesn't normally take vectors as inputs
# Parameters: x, some vector; FUN, function to apply; times, number of times to do this

# For example, this creates a 4x4 matrix whose rows are all (1,2,3,4)
Q <- matrix(c(rep(1, 4), rep(2, 4), rep(3, 4), rep(4, 4)), nrow=4, ncol=4)

# mapply() does this much more easily
Q <- mapply(x=1:4, FUN=rep, times=4)


# SWEEP FUNCTION
# Purpose: Want to replicate actions on the margins of apply()
# Syntax: sweep(x, MARGIN, STATS, FUN)
# Parameters: x, some array; MARGIN, appropriate indices of x; STATS, the summary statistic to be "swept out"; FUN, function used to "carry out the sweep"

MyPoints <- B

# Finds means and standard deviations of each column of matrix MyPoints
MyPoints.means <- apply(MyPoints, MARGIN=2, FUN=mean)
MyPoints.sd <-apply(MyPoints, MARGIN=2, FUN=sd)

# Now transform data to have mean zero, standard deviation one
MyPoints.norm <- sweep(MyPoints, MARGIN=2, STATS=MyPoints.means, FUN="-")
MyPoints.norm <- sweep(MyPoints.norm, MARGIN=2, STATS=MyPoints.sd, FUN="/")

# We can do this in one line by nesting sweep calls
MyPoints.norm <- sweep(sweep(MyPoints, MARGIN=2, STATS=MyPoints.means, FUN="-"), MARGIN=2, STATS=MyPoints.sd, FUN="/")


# AGGREGATE FUNCTION
# Purpose: Aggregate data by some criterion and apply some function
# Syntax: aggregate(x, by, FUN)

# This creates some practice data
df <- data.frame(DepPC=c("90", "91", "92", "93", "94", "75"), DProgr=c(1:120), 
                 Qty=c(7:31, 9:23, 99:124, 2:28, 14:19, 21:29, 4, 3, 1:9, 66), 
                 Delivered=ifelse(rnorm(120) > 0, TRUE, FALSE))

# Uses sapply to tell you the data type of each column in df (cool!)
sapply(df, FUN=class)

# Sums up all the Qty values for each unique factor of DepPC
aggregate(df$Qty, by=df["DepPC"], FUN=sum)

# Using by=df$var does not work with aggregate()
aggregate(df$Qty, by=df$DepPC, FUN=sum)

# But casting it as a list will
aggregate(df$Qty, by=list(df$DepPC), FUN=sum)

# Visualize this data using ggplot2
library("ggplot2")

# Plots sales per department
p <- ggplot(data=df.plot, aes(x=DepPC, y=x)) + geom_point() 
p <- p + ggtitle("Sales per Department, Total") + ylab("Sales")

# NOTE: Including aes() in ggplot() or in geom_point() makes no difference
ggplot(data=aggregate(df$Qty, by=df["DepPC"], FUN=sum)) + geom_point(aes(x=DepPC, y=x))

# Now let's show which ones were delivered and which weren't
# Specifying list(aggvar = var) argument instead of just var on its own tells aggregate() to return a data.frame with the name aggvar where desired
df2 <- aggregate(list(Qty = df$Qty), by=list(DepPC = df$DepPC, Delivered = df$Delivered), FUN=sum)

# Creates a bar graph of quantity by each department, color-coded by whether or not each package was delivered
# NOTE: When making a bar graph, if you want the y values to represent heights of the bars, you need to use stat="identity" otherwise the default is stat="bin" (I think), which causes problems
p2 <- ggplot(data=df2) + geom_bar(aes(x=DepPC, y=Qty, fill=Delivered), stat="identity") 
p2 <- p2 + xlab("Department") + ylab("Sales") + ggtitle("Sales by Department")
print(p2)

 # This also works, but the default for stat_identity() is a scatterplot, so need to specify that you want a bar graph
ggplot(data=df2) + stat_identity(aes(x=DepPC, y=Qty, fill=Delivered), geom="bar")
