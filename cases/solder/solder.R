data(solder)


bwplot(skips ~ Solder, data=solder)
bwplot(skips ~ Opening, data=solder)


lm1 = lm(skips ~ Solder, data=solder)
lm2 = lm(skips ~ Opening, data=solder)

lm3 = lm(skips ~ Solder + Opening, data=solder)
     
lm4 = lm(skips ~ Solder + Opening + Solder:Opening, data=solder)

         
bwplot(skips ~ Solder:Opening, data=solder)


lm5 = lm(skips ~ Solder + Opening + Solder:Opening + Mask, data=solder)
