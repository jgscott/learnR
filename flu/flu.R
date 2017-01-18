# Read in the data, and tell R what column the row labels are in
# That way it doesn't think week is a categorical variable
flu = read.csv("flu.csv", header=TRUE)
flu2012 = read.csv("flu2012.csv", header=TRUE)


# the ~. syntax means regress on all variables not otherwise named
lm1 = lm(cdcflu ~ ., data=flu)
glm1 = glm(cdcflu~., data=flu, family=poisson(link="log"))

sum((flu$cdcflu - fitted(lm1))^2)

pred1=predict.lm(lm1,newdata=flu2012, se.fit=TRUE)

# Compare the following two
pred2a = predict.glm(glm1,newdata=flu2012, type="link", se.fit=TRUE)
pred2b = predict.glm(glm1,newdata=flu2012, type="response", se.fit=TRUE)

pred

# Extract the point estimates and estimation
# standard errors with pred1$fit and pred1$se.fit etc

plot(fitted(glm1))
lines(fitted(glm1)+2*sqrt(fitted(glm1)), col='red')
lines(fitted(glm1)-2*sqrt(fitted(glm1)), col='red')
points(flu$cdcflu, col="blue", pch=19)

plot(fitted(lm1))
lines(fitted(lm1)+2*583.4, col='red')
lines(fitted(lm1)-2*583.4, col='red')
points(flu$cdcflu, col="blue", pch=19)

pred