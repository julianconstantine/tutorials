import numpy as np

# DATA TYPES
# Can use data types to convert Python numbers to array scalars/Python lists to ndarrays
x = np.float32(1.0)

print(x)  # Prints out 1.0
print(type(x))  # <class 'numpy.float32'>
print(type(1.0))  # <class 'float'>

# Just typing y will return:  array([1, 2, 4])
y = np.int_([1, 2, 4])

print([1, 2, 4])  # Returns [1, 2, 4]
print(y)  # Returns [1 2 4] (no commas!)

# The np.array class provides a 1-D array
z = np.int32([1, 2, 3])

# Both convert z to a float
np.float16(z)  # Returns:  array([ 1.,  2.,  3.], dtype=float16)

print(z.dtype)  # Returns:  dtype('int32')


# ARRAY CREATION
# Create 2 x 3 arrays of zeroes and ones
np.zeros((2, 3))
np.ones((2, 3))

# Use arange() to create arrays of regularly spaced numbers
np.arange(10)  # Returns:  array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
np.arange(start=2, stop=10, dtype=np.float)  # Returns:  array([ 2.,  3.,  4.,  5.,  6.,  7.,  8.,  9.])
np.arange(start=2, stop=3, step=0.1)  # Returns:  array([ 2. ,  2.1,  2.2,  2.3,  2.4,  2.5,  2.6,  2.7,  2.8,  2.9])

# Use linpsace() to create equally spaced arrays with a given number of elements
np.linspace(start=1., stop=4., num=6)  # Returns:  array([ 1. ,  1.6,  2.2,  2.8,  3.4,  4. ])

# Whatever the hell np.indices() actually does ...
np.indices((3, 3))  # Returns:  array([[[0, 0, 0], [1, 1, 1], [2, 2, 2]], [[0, 1, 2], [0, 1, 2], [0, 1, 2]]])


# INDEXING
# Unlike lists/tuples, numpy arrays ahve multidimensional indexing!
x = np.arange(10)

# Make x multidimensional (2 x 5)
x.shape = (2, 5)

# Now you can multidimensional-index away!
print(x[1][3])  # Returns:  8

# Can also index less this, but it is LESS EFFICIENT because after the first index element and NEW ARRAY has to be
# created and then indexed again
print(x[1, 3])

# If you just access x[0], you get the first (5-element) row of the 2 x 5 array
print(x[0])  # Returns:  [0 1 2 3 4]

# Slice and stride arrays like lists in base Python/vectors in MATLAB
# NOTE: Slicing returns a view of the array, NOT a copy!
x = np.arange(10)

print(x[2:5])  # Get third-fifth elements:  [2 3 4]
print(x[:-7])  # Get first three elements:  [0 1 2]
print(x[1:7:2])  # Get every other element betw. position 1 and position 7:  [1 3 5]

# Create 5 x7 array containing numbers 0, 1, 2, ;... 24
y = np.arange(35).reshape(5, 7)

# Get every third element (element 0, element 3, element 6) from every other row (row 1, row 3)
# Returns:
#  [[ 7 10 13]
#   [21 24 27]]
print(y[1:5:2, ::3])

# Index Arrays:
# NumPy arrays can be indexed via other arrays/sequences, called "index arrays" (surprise, surprise)
x = np.arange(start=10, stop=1, step=-1)

# Now index x using an array
# NOTE: You can idnex the same element twice, or out of order, to get the lements of x that you want!
print(x)  # Returns:  [10  9  8  7  6  5  4  3  2]
print(x[np.array([3, 3, -8, 8])])  # Returns:  [7 7 9 2]


# Boolean or "Mask" Arrays:
y = np.arange(35).reshape(5, 7)
b = y > 20  # NOTE: b is a 5 x 7 array!

# Index 5 x 7 array y using 5 x 7 Boolean array b. Note that the result is a 1-D array, NOT a 5 x 7 array like y!
# This is because b is also a 5 x7 array
print(y[b])  # Returns: [21 22 23 24 25 26 27 28 29 30 31 32 33 34]

# If the index array has FEWER dimensions than y, then the result will be MULTIDIMENSIONAL
print(y[b[:, 5]])  # NOTE: b[:, 5] = array([False, False, False,  True,  True], dtype=bool)
# Returns:
#  [[21 22 23 24 25 26 27]
#   [28 29 30 31 32 33 34]]

# Another example of multidimensional output/indexing:
x = np.arange(30).reshape(2, 3, 5)
print(x)
# Returns:
# [[[ 0  1  2  3  4]
#   [ 5  6  7  8  9]
#   [10 11 12 13 14]]
#
#  [[15 16 17 18 19]
#   [20 21 22 23 24]
#   [25 26 27 28 29]]]

# Result of indexing by b will be multidimensional because b has 2 dimensions and x has 3
b = np.array([[True, True, False], [False, True, True]])
print(x[b])
# Returns:
# [[ 0  1  2  3  4]
#  [ 5  6  7  8  9]
#  [20 21 22 23 24]
#  [25 26 27 28 29]]

# Index arrays and slices can be combined and everything works just fine!
# This gets first, third, and fifth rows/second and third columns of y
print(y[np.array([0, 2, 4]), 1:3])
# Returns:
# [[ 1  2]
#  [15 16]
#  [29 30]]

# Assigning Values to Indexed Arrays:
x = np.arange(10)

# Can assign constants or appropriately sized arrays to slices
# Both of these are valid:
x[2:7] = 1
x[2:7] = np.arange(5)

# However, sometimes weird things happen, for example:
x = np.arange(0, 50, 10)
print(x)  # Returns:  [ 0 10 20 30 40]

# This will increment the elements in positions 1 and 3 in x, but only once! (So element in position one does NOT get
#  incremented three times as one might expect)
# The reason for this is that a new temporary array is extracted from the original, it's values are changed, then it is
# re-assigned to the original array. Therefore, the element in position 1 is re-assigned three times, rather than
# incremented three times
x[np.array([1, 1, 3, 1])] += 1
print(x)  # Returns:  [ 0 11 20 31 40]


# BROADCASTING
x = np.arange(4)
xx = x.reshape(4, 1)
y = np.ones(5)
z = np.ones((3, 4))

print(x.shape, y.shape)  # Returns:  (4,) (5,)

# This will return a ValueError because trailing dimensions (4 and 5) are not equal
x + y

print(xx.shape)  # Returns:  (4, 1)

# The trailing dimensions of xx and y are 1 and 5, respectively, so they are compatible
print((xx + y).shape)  # Returns:  (4, 5)
print(xx + y)
# Returns:
# [[ 1.  1.  1.  1.  1.]
#  [ 2.  2.  2.  2.  2.]
#  [ 3.  3.  3.  3.  3.]
#  [ 4.  4.  4.  4.  4.]]

# x is 1 x 4 and z is 3 x 4, so result will be 3 x 4
print(x.shape, z.shape)  # Returns:  (4,) (3, 4)
print((x + z).shape)  # Returns:  (3, 4)
print(x + z)
# Returns:
# [[ 1.  2.  3.  4.]
#  [ 1.  2.  3.  4.]
#  [ 1.  2.  3.  4.]]

# Can use broadcasting to conveniently compute OUTER PRODUCTS of vectors(!!)
# NOTE: The documents mentioned "other outer operations" as though "outer operations" were a more general thing
a = np.array([0.0, 10.0, 20.0, 30.0])
b = np.array([1.0, 2.0, 3.0])

# Use the np.newaxis command to insert a new axis into a to make it a 2-D 4 x 1 array
# Combining a 4 x 1 array with an array b with shape (3,) yields a 4 x 3 array
print(a[:, np.newaxis] * b)
# Returns:
# [[  0.   0.   0.]
#  [ 10.  20.  30.]
#  [ 20.  40.  60.]
#  [ 30.  60.  90.]]

