library(mosaic)

# import house data set
# house = read.csv("house.csv", header=TRUE)

plot(price~sqft, data=house, pch=19)
lm.all = lm(price~sqft, data=house)
abline(lm.all)

summary(house)

mean(price~nbhd,data=house)

# create subsets
house.n1 = subset(house,nbhd=="nbhd01")
house.n2 = subset(house,nbhd=="nbhd02")
house.n3 = subset(house,nbhd=="nbhd03")


# A separate model for neighborhood 1
plot(price~sqft, data=house.n1, pch=19, col='blue')
lm.n1 = lm(price~sqft, data=house.n1)
abline(lm.n1, col='blue')

# Fit the models for the other two neighborhoods as well
lm.n2 = lm(price~sqft, data=house.n2)
lm.n3 = lm(price~sqft, data=house.n3)


## Three separate models, treating
## nbhd as three separate data sets
plot(price~sqft, data=house)
points(price~sqft, data=house.n1, col='blue', pch=19)
points(price~sqft, data=house.n2, col='red', pch=19)
points(price~sqft, data=house.n3, col='grey', pch=19)

abline(lm.n1, col='blue')
abline(lm.n2, col='red')
abline(lm.n3, col='grey')
abline(lm.all, lwd=3)

legend("topleft", legend=c("N1", "N2", "N3", "All"), col=c("blue", "red", "grey", "black"), lty="solid")

# Extract the coefficients from each model
coef(lm.n1)
coef(lm.n2)
coef(lm.n3)
coef(lm.all)

# This is cumbersome; R gives us a shortcut.
lm2 = lm(price~sqft*nbhd, data=house)
plot(price~sqft, data=house)
points(fitted(lm2)~sqft,data=house, pch=19, col='grey')

# The coefficients are returned in "baseline and offset" form
coef(lm2)
32906.42 - 7224.31
40.30 + 9.13
coef(lm.n2)

## Compare with using lm() to fit group-wise means
mean(price~nbhd,data=house)
lm0 = lm(price~nbhd, data=house)
coef(lm0)

# What if we wanted to constrain all three neighborhoods to have the same slope, but allow different intercepts?
lm3 = lm(price~sqft + nbhd, data=house)
plot(price~sqft, data=house)
points(fitted(lm3)~sqft,data=house, pch=19, col='grey')
coef(lm3)


## Some fancy plotting functions with add-in libraries
library(lattice)
xyplot(price~sqft | nbhd, data=house)

library(ggplot2)
qplot(sqft, price, color=nbhd, data=house)
qplot(sqft, price, data=house, facets=.~nbhd)
qplot(sqft, price, data=house, facets=brick~nbhd)
