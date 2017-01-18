library(mosaic)
library(faraway)

# The log transform
# Often useful for data bounded below by 0
# that span many orders of magnitude

# Read in the infant mortality data set
# variables are infant deaths per 1000 live births.
# and GDP per capita, in U.S. dollars.
infmort = read.csv('infmort.csv', header=TRUE)

# Try plotting the data
plot(mortality ~ gdp, data=infmort)

plot(mortality ~ log(gdp), data= infmort)

plot(log(mortality) ~ log(gdp), data= infmort)

lm1 = lm(log(mortality) ~ log(gdp), data= infmort)
coef(lm1)
abline(lm1)


# Plot the curve on the original scale
plot(mortality ~ gdp, data= infmort)
beta = coef(lm1)

# Predict on the log scale, and then undo the transformation
logmort.pred = beta[1] + beta[2]*log(infmort$gdp)
mort.pred = exp(logmort.pred)

# Add the predicted points to the plot in a different color
plot(mortality ~ gdp, data= infmort)
points(mort.pred ~ gdp, data=infmort, col='blue', pch=18)

# try typing in ?points if you want to see the options

# Could also add the curve directly
plot(mortality ~ gdp, data= infmort)
curve(exp(beta[1]) * x^beta[2], add=TRUE, col='blue')



# The logit transform
# Often useful for data between 0 and 1

# Read in data on state-level income vs percent US born
data(eco, package="faraway")

# Doesn't seem linear
plot(income ~ usborn, data=eco)

# A log transform is no better
plot(income ~ log(usborn), data=eco)

# A logit transform works better
plot(income ~ logit(usborn), data=eco)

