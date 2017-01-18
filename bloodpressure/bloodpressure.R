library(lme4)
library(mosaic)

# Naive approach: treat every observation as independent
mu_hat = mean(systolic ~ factor(treatment), data=bloodpressure)
sigma_hat = sd(systolic ~ factor(treatment), data=bloodpressure)
sample_size = tally( ~ factor(treatment), data=bloodpressure)

delta = mu_hat[1] - mu_hat[2]
se_delta = sqrt(sum(sigma_hat^2 / sample_size))

delta/se_delta

# naive standard errors
sigma_hat/sqrt(sample_size)


# Notice the structure of the data
tally( ~ factor(subject) + factor(treatment), data=bloodpressure)
tally( ~ factor(subject), data=bloodpressure)

# Avoiding pseudo-replication

# Easiest: average the person-level data
# Treat each average as a single data point
person_mean = mean(systolic ~ factor(subject), data=bloodpressure)
treatment_ind = c(rep(1,10), rep(2,10))

# Mean and standard deviation for each group
mean(person_mean ~ factor(treatment_ind))
sd(person_mean ~ factor(treatment_ind))

# Standard error of the sample mean for each group
sd(person_mean ~ factor(treatment_ind))/sqrt(10)

# Easy to phrase as a linear model
lm1 = lm(person_mean ~ factor(treatment_ind))
summary(lm1)

# Accounting for varying sample sizes?
person_weights = tally( ~ factor(subject), data=bloodpressure)

# Use weighted least squares
lm2 = lm(person_mean ~ factor(treatment_ind), weights=person_weights)
summary(lm2)

# Better: a hierarchical model that addresses the "compound error term"
# (1 | subject) says: introduce a random intercept term for each subject
hlm1 = lmer(systolic ~ factor(treatment) + (1 | subject), data=bloodpressure)
summary(hlm1)
print(hlm1)
r1 = ranef(hlm1, condVar = TRUE)
dotplot(r1)

# This looks structurally similar to a model with dummy variables for subjects
# But it is very different!
# Notice how drastically wrong the answer is for the "fixed effects" model
lm3 = lm(systolic ~ factor(treatment) + factor(subject), data=bloodpressure)
summary(lm3)

lm4 = lm(systolic ~ factor(subject) + factor(treatment), data=bloodpressure)
summary(lm4)
