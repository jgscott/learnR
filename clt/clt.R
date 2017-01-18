crazy_pop = rexp(100000, 1/2)
hist(crazy_pop, 100)

mean(crazy_pop)
sd(crazy_pop)

n = 30
mean_samplingdist = do(1000)*{
  mysample = sample(crazy_pop,n)
  mean(mysample)
}

head(mean_samplingdist)
hist(mean_samplingdist$result)

sd(mean_samplingdist$result)

sd(crazy_pop)/sqrt(n)

