# define our parameters and specify two different values for B in order to account for both sets of parameters
B1 = (.7)
x = []
x.append(20)
T = 20
a = 0


# define a function that calculates the proceeding cake consumption given the initial and a guess for the first period
def adjustedx1(min1, max1, initial):
  newx1 = [initial]
  newx1.append((max1+min1)/2)
  for t in range(2, T+1):
    newx1.append((1+B1) * newx1[t-1] - B1 * newx1[t-2])
  return newx1

# define the boundaries for initial cake consumption
max1 = x[0]
min1 = 0


# recall the defied funcions and define them as a list for both sets which simplifies the following conditionals
x1 = adjustedx1(min1, max1, x[0])

# create a conditional loop such that we redefine upper and lower boundaries until we have no more cake at the end of the final period
while True:
  if x1[T] > 0.00001:
    max1 = x1[1]
  elif x1[T] < -0.00001:
    min1 = x1[1]
  else:
    break
  x1 = adjustedx1(min1, max1, x[0])


# this value should be close to 0 if we properly condition our statements, and it certainly is
print(x1)