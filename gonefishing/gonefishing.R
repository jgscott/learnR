library(mosaic)

# Read in the data
gonefishing = read.csv("gonefishing.csv", header=TRUE)

npop = nrow(gonefishing)

gonefishing$volume = (gonefishing$height)*(gonefishing$length)*(gonefishing$width)

plot(weight~volume, data=gonefishing, pch=19, col=rgb(30,30,30,30, maxColorVal=256))

lmfull = lm(weight~volume, data=gonefishing)
coef(lmfull)
abline(lmfull)

# Take a sample of size 30 from the population
# and fit a linear model to that sample

# First define the sample size
nsamp = 30

# Try taking a sample a few different times
lmsamp = lm(weight~volume, data=sample(gonefishing,nsamp))
coef(lmsamp)


# We can automate the process of taking multiple samples
# Try 10 first
do(10)*lm(weight~volume, data=sample(gonefishing,30))

# How about 1000?
do(1000)*lm(weight~volume, data=sample(gonefishing,30))

# Plot some lines
plot(weight~volume, data=gonefishing, pch=19, col=rgb(1, 0, 0, 0.2))
for(i in 1:1000) {
  abline(lm(weight~volume, data=sample(gonefishing,30)), col=rgb(0.5,0.5,0.5,0.1))
}

# We can avoid the screen dump by saving the output.
montecarlo = do(1000)*lm(weight~volume, data=sample(gonefishing,30))

# Look at histograms of the sampling distributions
hist(montecarlo$volume)
hist(montecarlo$Intercept)

# Compute the standard error of the slope estimate
sd(montecarlo$volume)

# Check that the estimator looks unbiased
colMeans(montecarlo)

# Extract a 95% coverage interval for each model parameter
confint(montecarlo, level=0.95)


### Now try bootstrapping

# First get a sample of size 30
myfishingtrip = sample(gonefishing,30)

# The model using your sample
lmmytrip = lm(weight~volume, data=myfishingtrip)
coef(lmmytrip)

# Try a single bootstrapped sample from your sample

lmboot = lm(weight~volume, data=resample(myfishingtrip))
coef(lmboot)

# How about 10 bootstrapped samples?
do(10)*lm(weight~volume, data=resample(myfishingtrip))

# Now 1000
myboot = do(1000)*lm(weight~volume, data=resample(myfishingtrip))

hist(myboot$volume)
hist(myboot$Intercept)
colMeans(myboot)

# Compare the true standard error with the bootstrapped standard error
# It won't be exactly right, but should be in the ballpark
sd(montecarlo$volume)
sd(myboot$volume)

# Coverage interval from the bootstrapped samples
confint(myboot, level=0.95)

# Now try using the mathematical formulas
lm1 = lm(weight~volume, data=gonefishing)
summary(lm1)
