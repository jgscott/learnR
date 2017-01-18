bwplot(Butterfat ~ Age, data=butterfat)
lm1 = lm(Butterfat ~ Age, data=butterfat)
coef(lm1)

bwplot(Butterfat ~ Breed, data=butterfat)
lm2 = lm(Butterfat ~ Breed, data=butterfat)
coef(lm2)


lm3 = lm(Butterfat ~ Breed + Age, data=butterfat)
coef(lm3)


lm4 = lm(Butterfat ~ Breed + Age + Breed:Age, data=butterfat)
coef(lm4)

anova(lm3)

# Balanced design
xtabs(~Breed + Age, data=butterfat)
