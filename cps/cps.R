library(mosaic)

# read in the data set

# Is there a wage premium for men?
boxplot(wage~sex, data=cps85)
mean(wage~sex, data=cps85)
lm(wage~sex, data=cps85)

# A difference of 2.12
# What happens if we re-deal the cards?
mean(wage~shuffle(sex), data=cps85)

# Try this 1000 times and plot the "observed" differences in wages
permtest = do(1000)*mean(wage~shuffle(sex), data=cps85)
hist(permtest$M - permtest$F, xlim=c(-2.5,2.5))
abline(v=2.12, col='red')

#Do this with lm to take advantage of baseline/offset form
permtest2 = do(1000)*lm(wage~shuffle(sex), data=cps85)
head(permtest2)
hist(permtest2$sexM, xlim=c(-2.5,2.5))
abline(v=2.12, col='red')

# But could the wage premium for men be explained by differential union membership?
boxplot(wage~union, data=cps85)
xtabs(~sex+union,data=cps85)

# Let's plot wages stratified by both sex and union membership
boxplot(wage~(sex:union), data=cps85)

# How to test the hypotheses that, once we adjust for union membership,
# there is no additional wage premium for men?

# First try fitting a separable model for wage versus union membership and sex
# What should the male coefficient be under the null hypothesis?
lm1 = lm(wage ~ union + sex, data=cps85)
coef(lm1)


# Is that coefficient for men "significant"?
permtest3 = do(1000)*lm(wage~union+shuffle(sex), data=cps85)
head(permtest3)
hist(permtest3$sexM)



##### Multiple variables

# Quantify the partial relationship between sex and wage,
# holding other factors equal

# Method 1, slice and dice
# Similar ages, educational levels in the sales sector
sub1 = subset(cps85, age >=30 & age <= 35 & 
					educ >= 10 & educ <= 12 & 
					sector == "sales")

lm1 = lm(wage~sex, data=sub1)
summary(lm1)

#Oops!
table(sub1$sex)


# Method 2: regression
lm2 = lm(wage ~ sex + educ + age + sector, data=cps85)
summary(lm2)

# The above model assumes that the male wage premium is constant across
# all ages, educational levels, and sectors

# What if the wage premium for men is different for older workers
summary(cps85$age)
cps85$agegroup = cut(cps85$age, breaks=c(0,25,35,50,70))

bwplot(wage~sex | agegroup, data=cps85)
# Looks like a bigger gap for older workers

# This suggests we need an interaction term
lm3 = lm(wage ~ sex + educ + age + sector + sex:age, data=cps85)
summary(lm3)

# All else being equal,
# we expect a 25-year-old male to make -0.94 + 0.078*25 = 1.01 more
# And a 50-year old male to make -0.94 + 0.078*50 = 2.96 more

