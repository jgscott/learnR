library(mosaic)

summary(utilities)

# Goal: predict monthly gas bill in terms of temperature

# Notice that not every month has the same number of billing days
hist(utilities$billingDays, breaks=20)

# Define a new variable
utilities$daily.average.gasbill = utilities$gasbill/utilities$billingDays

# Plot the data and fit a linear regression model
plot(daily.average.gasbill ~ temp, data=utilities)
lm1=lm(daily.average.gasbill ~ temp, data=utilities)
points(fitted(lm1)~temp, data=utilities, col='red', pch=19)
abline(lm1)

plot(resid(lm1) ~ temp, data=utilities)


# Fit a model with a quadratic term:
lm2=lm(daily.average.gasbill ~ temp + I(temp^2), data=utilities)
# Replot the data and added the fitted values
plot(daily.average.gasbill ~ temp, data=utilities)
points(fitted(lm2)~temp, data=utilities, col='blue', pch=19)

plot(resid(lm2) ~ temp, data=utilities)
abline(h=0)
