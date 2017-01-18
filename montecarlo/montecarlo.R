library(mosaic)

#### Three ways to do a Monte Carlo simulation in R


#####
# 1) The most intuitive way for non-CS majors
# Uses "syntactic sugar" from the mosaic library
#####


# Here is something we do once: generate a random uniform number
runif(1)

# Save the result in a new variable called x
x = runif(1)
x

# Here is a way to do that same thing 100 times
do(100)*{
	runif(1)
}

# Save the result in a new variable called MonteCarlo
MonteCarlo = do(1000)*{
	runif(1)
}
hist(MonteCarlo$result)


# We can do anything we want inside the braces.
# The last line is what gets aggregated.
MonteCarlo = do(1000)*{
	u = runif(1)
	x = cos(exp(2+u))
	x
}
hist(MonteCarlo$result)


#####
# 2) The most "R-native" way
# no extra libraries
#####


# here is a for loop in R
for(i in 1:10) {
	print(i)
}

# for loops in R do not have a return value.
# Therefore we must pre-allocate a variable to store computations.

NMC = 1000
result = rep(0, NMC)
for(i in 1:NMC) {
	result[i] = i
}
result

# Slightly more interesting
result = rep(0, NMC)
for(i in 1:NMC) {
	result[i] = runif(1)
}
result

# Although dumber than this, which is passed to C and therefore much faster
result = runif(1000)



#####
# 3) My favorite way
#####


# Install and load the foreach library
library(foreach)

# foreach loops have return values
# Here's the syntax
result = foreach(i = 1:1000) %do% {
	runif(1)
} 

# By default, foreach aggregates results in a list
# To aggregate in a vector, pass the following flag

result = foreach(i = 1:1000, .combine = 'c') %do% {
	runif(1)
} 
hist(result)

# Here's one reason this way is my favorite
library(parallel)
library(doMC)
registerDoMC(parallel::detectCores())  # function is in the parallel namespace

# Pretty automatic multi-core simulations
result = foreach(i = 1:1000, .combine = 'c') %dopar% {
	runif(1)
} 
hist(result)
