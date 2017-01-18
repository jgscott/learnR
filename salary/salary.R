library(mosaic)

salary = read.csv('salary.csv', header=TRUE)

# Look at the distibution of salary by sex
mean(Salary~Sex,data=salary)
boxplot(Salary~Sex,data=salary, names=c("Female", "Male"))

# What if we adjust for the worker's experience?
plot(Salary~Experience, data=salary)
lm1 = lm(Salary~Experience, data=salary)
summary(lm1)

# Look at the residuals
# "Salary adjusted for experience"
boxplot(resid(lm1)~salary$Sex)

# Now a multiple regression model
lm2 = lm(Salary~Experience+Months+Education, data=salary)
summary(lm2)
boxplot(resid(lm2)~salary$Sex)

# What if we explicitly include a dummy variable for whether the worker is male?
lm3= lm(Salary~Experience+Months+Education+Sex, data=salary)
summary(lm3)

# We can quantify uncertainty via bootstrapping
lm(Salary~Experience+Months+Education+Sex, data=resample(salary))

myboot = do(1000)*lm(Salary~Experience+Months+Education+Sex, data=resample(salary))

hist(myboot$Sex)
