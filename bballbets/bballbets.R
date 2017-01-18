library(mosaic)

bballbets = read.csv("bballbets.csv", header=TRUE)

plot(jitter(homewin,0.2) ~ spread, data=bballbets,
	xlab='Home team victory?', ylab='Point spread',
	pch=19, col=rgb(0,0,0,0.2), las=1)

# Look at the empirical win frequency within "buckets"
spread.discrete = cut(bballbets$spread, breaks=seq(-35,45,by=10))
lm0 = lm(homewin~spread.discrete, data=bballbets)
points(fitted(lm0) ~ spread, data=bballbets, col='blue', pch=19)

#### Fit a linear model to win versus spread
lm1 = lm(homewin~spread, data=bballbets)
summary(lm1)

plot(jitter(homewin,0.2) ~ spread, data=bballbets,
	xlab='Home team victory?', ylab='Point spread',
	pch=19, col=rgb(0,0,0,0.2), las=1)
points(fitted(lm0) ~ spread, data=bballbets, col='blue', pch=19)
abline(lm1)

# Uh oh! probabilities outside [0,1] are silly...
hist(fitted(lm1))

# Plot fitted values versus the original x variable
plot(fitted(lm1)~spread,data=bballbets)


# A simple fix: fit a logistic regression model instead
glm1 = glm(homewin~spread, data=bballbets, family=binomial)

# Plot these probabilities versus the original x variable
# See the sigmoidal curve.
plot(fitted(glm1)~spread,data=bballbets)

# Compare the linear vs logistic fit
plot(jitter(homewin,0.2) ~ spread, data=bballbets,
	xlab='Home team victory?', ylab='Point spread',
	pch=19, col=rgb(0,0,0,0.2), las=1)
points(fitted(lm1)~spread, data=bballbets, col='red', pch=19)
points(fitted(glm1)~spread,data=bballbets, col='blue', pch=19)

legend("topleft", legend=c("Linear", "Logistic"), col=c("red", "blue"), pch=19)

