Approximating the sampling distribution by bootstrapping
--------------------------------------------------------

Learning goals:  
\* bootstrap the sample mean  
\* bootstrap the OLS estimator  
\* compute and interpret the bootstrapped standard error  
\* compute confidence intervals from bootstrapped samples

Data files:  
\*
[creatinine.csv](http://jgscott.github.io/teaching/data/creatinine.csv):
data on age and kidney function for 157 adult males from a single
clinic.

Load the mosaic library and then return to the creatinine data set,
which we recall had data on the age and kidney function for a sample of
men from a single clinic.

    library(mosaic)

    creatinine = read.csv('creatinine.csv', header=TRUE)
    summary(creatinine)

    ##       age          creatclear   
    ##  Min.   :18.00   Min.   : 89.3  
    ##  1st Qu.:25.00   1st Qu.:118.6  
    ##  Median :31.00   Median :128.0  
    ##  Mean   :36.39   Mean   :125.3  
    ##  3rd Qu.:43.00   3rd Qu.:133.3  
    ##  Max.   :88.00   Max.   :147.6

The two variables are  
\* age: the patient's age.  
\* creatclear: the patient's creatinine-clearance rate, measured in
ml/minute.

### Bootstrapped samples

We will start by addressing the following question. What can we say
about the average creatinine-clearance rate for the population of men
who attend this clinic, on the basis of this particular sample of 157?
The sample mean is easy enough to compute:

    creatclear_samplemean = mean(creatinine$creatclear)
    creatclear_samplemean

    ## [1] 125.2548

But we know that our sample mean of 125 won't exactly equal the
population mean. To quantify how far off our estimate is likely to be,
we would like to know the standard error of the sample mean. Moreover,
we'd like to know this without taking many more samples of 157 from the
population and seeing how the sample mean changes from one sample to the
next.

The idea of the bootstrap is to pretend that your sample represents the
whole population. We then take repeated "bootstrapped" samples from the
original sample. Each bootstrapped sample is defined by two
properties:  
1) It has the same size as the original sample.  
2) It is a sample with replacement from the original sample. Because we
sample with replacement, it is inevitable that our bootstrapped sample
will contain ties and omissions. That is, some points from the original
sample will get picked more than once, and some won't get picked at all.
This approximates the process of taking repeated real samples from the
whole population.

Let's see this in action. First, let's create a bootstrapped sample and
look at the first 20 data points. We'll do this using the `sample`
command.

    bootstrapped_sample = sample(creatinine, size = 157, replace=TRUE)
    head(bootstrapped_sample, 20)

    ##      age creatclear orig.id
    ## 133   43      123.2     133
    ## 150   62      114.7     150
    ## 45    26      130.3      45
    ## 45.1  26      130.3      45
    ## 119   25      140.8     119
    ## 83    31      131.6      83
    ## 125   24      129.6     125
    ## 148   25      123.0     148
    ## 25    28      126.8      25
    ## 153   23      127.9     153
    ## 9     38      115.2       9
    ## 8     73      103.0       8
    ## 141   28      125.1     141
    ## 101   26      138.5     101
    ## 130   32      126.6     130
    ## 122   41      121.5     122
    ## 113   63      112.5     113
    ## 57    61      118.6      57
    ## 74    51      110.4      74
    ## 52    27      130.9      52

If you look carefully, you may see a repeated entry in these first 20
rows. That's because our bootstrapped sample is a sample with
replacement from the original sample. You can visualize the pattern of
ties and omissions with the following plot:

    plot(table(bootstrapped_sample$orig.id))

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-5-1.png)

The height of each bar shows how many times that original data point was
picked. The gaps show data points that were omitted.

There's actually a more concise way to draw bootstrapped samples using
the `resample` command, which we'll use from now on. Try executing the
following block of code 5 or 10 times to get a feel for the different
patterns of ties and omissions that arise in each bootstrapped sample.

    # same as sample(creatinine, size = 157, replace=TRUE)
    bootstrapped_sample = resample(creatinine)  
    plot(table(bootstrapped_sample$orig.id))

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-6-1.png)

### Bootstrapping the sample mean

We're now ready to estimate the sampling distribution of the sample mean
by bootstrapping. Our basic procedure is:  
1) Take a bootstrap sample from the original sample.  
2) For this bootstrapped sample, we compute the sample mean of the
creatinine-clearance rate.

We repeat this process a large number of times (say, 1000 or more). The
key point is that, because each bootstrapped sample has a unique pattern
of ties and omissions, each will have a different sample mean. The
histogram of sample means across the bootstrapped samples then gives us
an idea of how the sample mean changes from sample to sample.

Try executing the following block of code 5-10 times to see the
different sample means you get for each bootstrapped sample.

    bootstrapped_sample = resample(creatinine)
    mean(bootstrapped_sample$creatclear)

    ## [1] 124.514

The final trick is to use the `do` command to automatic the process of
taking repeated bootstrapped samples and computing the sample mean for
each one.

    do(10)*{
      bootstrapped_sample = resample(creatinine)  # same as sample(creatinine, size = 157, replace=TRUE)
      mean(bootstrapped_sample$creatclear)
    }

    ##      result
    ## 1  126.7376
    ## 2  125.8503
    ## 3  127.3510
    ## 4  124.5248
    ## 5  127.4191
    ## 6  125.8497
    ## 7  124.2701
    ## 8  124.0465
    ## 9  125.9783
    ## 10 125.6064

If this looks unfamiliar, try revisiting the ["Gone
fishing"](http://jgscott.github.io/teaching/r/gonefishing/gonefishing.html)
walkthrough to remind yourself of the logic of the `do(10)*` command.

Now we're ready. Let's take 1000 bootstrapped samples, compute the
sample mean for each one and visualize the results.

    # Take bootstrapped samples
    myboot = do(1000)*{
      bootstrapped_sample = resample(creatinine)  # same as sample(creatinine, size = 157, replace=TRUE)
      mean(bootstrapped_sample$creatclear)
    }
    # Visualize the sampling distribution and compute the bootstrapped standard error
    hist(myboot$result)

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-9-1.png)

    sd(myboot$result)

    ## [1] 0.9208574

Because we have different bootstrapped samples, your histogram and
estimated standard error will look slightly different from mine. But
they should be relatively close.

Incidentally, if you repeatedly execute the above code block, you'll get
slightly different histograms and standard errors each time. We refer to
this variability as "Monte Carlo error," to distinguish it from the
standard error of the estimator itself. In principle, you can drive the
Monte Carlo error to virtually nothing by taking a very large number of
bootstrapped samples.

### Bootstrapping the OLS estimator

Once you get the hang of bootstrapping the sample mean, you can
bootstrap just about anything. As a specific example, we will
approximate the sampling distribution of the least-squares estimator for
the relationship between creatinine clearance rate and age:

    # Plot the data
    plot(creatclear~age, data=creatinine)
    # Fit a straight line to the data by least squares
    lm1 = lm(creatclear~age, data=creatinine)
    # Extract the coefficients and plot the line
    coef(lm1)

    ## (Intercept)         age 
    ## 147.8129158  -0.6198159

    abline(lm1)

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-10-1.png)

Let's warm-up by computing the OLS estimator for a single bootstrapped
sample. Try executing this code block 5-10 different times:

    lm_boot = lm(creatclear~age, data=resample(creatinine))
    lm_boot

    ## 
    ## Call:
    ## lm(formula = creatclear ~ age, data = resample(creatinine))
    ## 
    ## Coefficients:
    ## (Intercept)          age  
    ##    150.5431      -0.6824

Notice how the slope and intercept of the fitted line change for each
sample.

To get a good idea of the sampling distribution for these quantities, we
want to repeat this many more than 5-10 times. Let's now use the `do`
command to automate the whole process and save the result.

    myboot2 = do(1000)*{
      lm_boot = lm(creatclear~age, data=resample(creatinine))
      lm_boot
    }
    # Inspect the first several lines
    head(myboot2)

    ##   Intercept        age    sigma r.squared        F numdf dendf .row .index
    ## 1  146.5953 -0.5539220 6.979254 0.6380754 273.2660     1   155    1      1
    ## 2  146.0221 -0.5601161 7.996567 0.5505381 189.8568     1   155    1      2
    ## 3  148.0365 -0.6181531 6.878273 0.7018148 364.8113     1   155    1      3
    ## 4  150.3503 -0.7051662 6.436485 0.6970664 356.6632     1   155    1      4
    ## 5  149.2101 -0.6572372 6.290953 0.7603602 491.8041     1   155    1      5
    ## 6  149.3291 -0.6452266 6.892803 0.7063523 372.8434     1   155    1      6

Notice that we have separate columns for the intercept, slope on the age
variable, sigma (the residual standard deviation), and R-squared. (Don't
worry about the "F" column for now.) Let's visualize the sampling
distributions for the intercept and slope.

    hist(myboot2$Intercept)

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-13-1.png)

    sd(myboot2$Intercept)

    ## [1] 1.480747

    hist(myboot2$age)

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-13-2.png)

    sd(myboot2$age)

    ## [1] 0.03944745

### Confidence intervals

We've met coverage intervals before. A coverage interval is an interval
that covers a specified percentage (say 80% or 95%) of a distribution.

A confidence interval for a parameter is nothing but a coverage interval
for that parameter's sampling distribution. For example, let's look more
closely at the sampling distribution for the slope on the `age` variable
that we just approximated by bootstrapping. We'll plot the histogram,
compute the endpoints of an 80% coverage interval, and show these
endpoints on the plot.

    hist(myboot2$age)
    myinterval = quantile(myboot2$age, probs=c(0.1, 0.9))
    abline(v = myinterval, col='blue')

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-14-1.png)

    myinterval

    ##        10%        90% 
    ## -0.6705294 -0.5725388

We would refer to this interval as an 80% confidence interval for the
slope of the age variable in our regression model. (As above, your
numbers won't match mine exactly because of the randomness inherent to
bootstrapping. But they should be close.) Note that this confidence
interval is very different from an 80% coverage interval of the actual
ages in the underlying sample:

    quantile(creatinine$age, probs=c(0.1, 0.9))

    ## 10% 90% 
    ##  23  62

You can use the `confint` command to quickly get confidence intervals
for all model parameters:

    confint(myboot2, level=0.8)

    ##        name       lower       upper level     method    estimate
    ## 1 Intercept 146.0341078 149.7247575   0.8 percentile 147.8129158
    ## 2       age  -0.6705294  -0.5725388   0.8 percentile  -0.6198159
    ## 3     sigma   6.3707481   7.3098796   0.8 percentile   6.9105379
    ## 4 r.squared   0.6177443   0.7269072   0.8 percentile   0.6724361
    ## 5         F 250.4877322 412.5727339   0.8 percentile 318.1901588

You will notice that this gives a slightly different answer to the
confidence interval we calculated from the quantiles, above. That's
because the default behavior of the \`confint' function is to give a
confidence interval that is symmetric about the sample mean. That is, we
take the mean of the histogram and step out symmetrically to either side
until we cover 80% of the sampling distribution; we call this a
"central" confindence interval. The 80% interval we computed above, on
the other hand, contained exactly 10% of the bootstrapped samples in
each tail of the histogram; we call this an "equal-tail" confidence
interval. Neither is better than the other; they are simply different
conventions. In the special case where the underlying sampling
distribution is exactly symmetric, then the two conventions will give
the same answer.

### The normal linear regression model

Most statistical software packages have built-in routines for
calculating standard errors and confidence intervals, and will show them
as part of a routine summary output for a regression model. R is no
exception: the `summary` and `confint` functions do just this. For
example, if we fit the straight line to the creatinine-clearance data
and ask for a summary, we get a column of standard errors for each
parameter (here labelled "Std. Error"):

    lm1 = lm(creatclear~age, data=creatinine)
    summary(lm1)

    ## 
    ## Call:
    ## lm(formula = creatclear ~ age, data = creatinine)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -18.2249  -4.6175   0.2221   4.7212  15.8221 
    ## 
    ## Coefficients:
    ##              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept) 147.81292    1.37965  107.14   <2e-16 ***
    ## age          -0.61982    0.03475  -17.84   <2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 6.911 on 155 degrees of freedom
    ## Multiple R-squared:  0.6724, Adjusted R-squared:  0.6703 
    ## F-statistic: 318.2 on 1 and 155 DF,  p-value: < 2.2e-16

You can also use the `confint` function to get confidence intervals at a
specified level:

    confint(lm1, level = 0.95)

    ##                   2.5 %      97.5 %
    ## (Intercept) 145.0875702 150.5382614
    ## age          -0.6884549  -0.5511768

R is definitely not using the bootstrap to calculate these standard
errors and confidence intervals. So what is it doing instead? The short
answer is that it is calculating *Gaussian* standard errors and
confidence intervals, which are based on the assumption that the
residuals in the regression model follow a Gaussian, or normal,
distribution.

This is a deep topic that we won't treat in detail right now. For most
purposes, however, it’s fine to think of the confidence intervals
returned by R's default routines as just an approximation to the
bootstrapped confidence intervals you’ve become familiar with.

To be a bit more specific: if you want to rely on these Gaussian
confidence intervals, it would be wise to check the validity of the
normality assumption:  
- Do the residuals look normally distributed? (Make a histogram and
check whether the histogram looks normal.)  
- Do the residuals look like they have approximately constant variance?
(Plot the residuals versus the fitted values and look for telltale "fan"
shapes.)  
- Do the residuals look independent of each other? (Again, plot the
residuals versus the fitted values and look for patterns of correlation
in adjacent residuals.)

If the answer to any of these three questions is no, then you're
probably better off with the bootstrapped confidence intervals instead.
Otherwise the Gaussian-based confidence intervals are likely to be a
fine approximation.

Let's try these questions with the model above. First, do the residuals
look approximately normal? We will make a histogram and check:

    hist(resid(lm1))

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-19-1.png)

This histogram shows no obvious departures from normality, so we're good
on the first question.

Second, do the residuals look like they have approximately constant
variance? We will plot the residuals versus the fitted values and see
whether there are any "fan" shapes:

    plot(resid(lm1) ~ fitted(lm1))

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-20-1.png)

There are no fan shapes here; the residuals exhibit a similar scale of
variation regardless of the fitted value from the regression model.

The same plot above, of the residuals versus the fitted values, also
gives us an answer to the third question: do the residuals look
independent of each other? Yes, they do. We do not see any obvious
patterns of dependence, in which adjacent residuals look more similar to
each other than far-apart residuals.

Therefore, in light of the answers to these three questions, we are safe
to use the standard errors and confidence intervals from the Gaussian
(normal) model. You'll notice, in fact, that the bootstrapped confidence
intervals and the Gaussian confidence intervals are nearly identical:

    confint(myboot2)

    ##        name       lower       upper level     method    estimate
    ## 1 Intercept 144.9066372 150.7918606  0.95 percentile 147.8129158
    ## 2       age  -0.7026099  -0.5497488  0.95 percentile  -0.6198159
    ## 3     sigma   6.1324210   7.5942863  0.95 percentile   6.9105379
    ## 4 r.squared   0.5815549   0.7490051  0.95 percentile   0.6724361
    ## 5         F 215.4189249 462.5423914  0.95 percentile 318.1901588

    confint(lm1)

    ##                   2.5 %      97.5 %
    ## (Intercept) 145.0875702 150.5382614
    ## age          -0.6884549  -0.5511768
