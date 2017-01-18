---
layout: post
---

Approximating the sampling distribution by bootstrapping
--------------------------------------------------------

Learning goals:  
\* bootstrap the sample mean  
\* bootstrap the OLS estimator  
\* compute and interpret the bootstrapped standard error  
\* compute confidence intervals from bootstrapped samples

Data files:  
\* [creatinine.csv](creatinine.csv): data on age and kidney function for
157 adult males from a single clinic.

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

    ##     age creatclear orig.id
    ## 19   27      132.8      19
    ## 148  25      123.0     148
    ## 115  54      113.9     115
    ## 103  27      132.0     103
    ## 138  23      119.9     138
    ## 79   23      136.2      79
    ## 20   71      105.5      20
    ## 43   24      142.9      43
    ## 64   63      114.6      64
    ## 61   22      124.0      61
    ## 122  41      121.5     122
    ## 8    73      103.0       8
    ## 95   25      139.7      95
    ## 12   24      128.6      12
    ## 58   18      143.8      58
    ## 25   28      126.8      25
    ## 73   65       89.3      73
    ## 23   23      131.2      23
    ## 121  57      113.4     121
    ## 74   51      110.4      74

If you look carefully, you may see a repeated entry in these first 20
rows. That's because our bootstrapped sample is a sample with
replacement from the original sample. You can visualize the pattern of
ties and omissions with the following plot:

    plot(table(bootstrapped_sample$orig.id))

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-5-1.png)<!-- -->

The height of each bar shows how many times that original data point was
picked. The gaps show data points that were omitted.

There's actually a more concise way to draw bootstrapped samples using
the `resample` command, which we'll use from now on. Try executing the
following block of code 5 or 10 times to get a feel for the different
patterns of ties and omissions that arise in each bootstrapped sample.

    # same as sample(creatinine, size = 157, replace=TRUE)
    bootstrapped_sample = resample(creatinine)  
    plot(table(bootstrapped_sample$orig.id))

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-6-1.png)<!-- -->

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

    ## [1] 124.6592

The final trick is to use the `do` command to automatic the process of
taking repeated bootstrapped samples and computing the sample mean for
each one.

    do(10)*{
      bootstrapped_sample = resample(creatinine)  # same as sample(creatinine, size = 157, replace=TRUE)
      mean(bootstrapped_sample$creatclear)
    }

    ##      result
    ## 1  124.0675
    ## 2  125.4312
    ## 3  125.9962
    ## 4  127.9217
    ## 5  125.4713
    ## 6  125.7452
    ## 7  124.8115
    ## 8  125.9662
    ## 9  125.1796
    ## 10 125.1981

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

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-9-1.png)<!-- -->

    sd(myboot$result)

    ## [1] 0.9462928

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

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-10-1.png)<!-- -->

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
    ##    147.7911      -0.6039

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

    ##   Intercept        age    sigma r.squared        F numdf dendf
    ## 1  145.0474 -0.5397870 6.528623 0.6062594 238.6602     1   155
    ## 2  148.8132 -0.6324065 6.373743 0.7178894 394.4299     1   155
    ## 3  148.2369 -0.6137878 7.304570 0.6550942 294.3981     1   155
    ## 4  147.4649 -0.6052031 6.057047 0.7441424 450.8057     1   155
    ## 5  148.0294 -0.6316402 7.501825 0.6822983 332.8790     1   155
    ## 6  147.6815 -0.6113110 6.590104 0.6758277 323.1409     1   155

Notice that we have separate columns for the intercept, slope on the age
variable, sigma (the residual standard deviation), and R-squared. (Don't
worry about the "F" column for now.) Let's visualize the sampling
distributions for the intercept and slope.

    hist(myboot2$Intercept)

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-13-1.png)<!-- -->

    sd(myboot2$Intercept)

    ## [1] 1.445293

    hist(myboot2$age)

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-13-2.png)<!-- -->

    sd(myboot2$age)

    ## [1] 0.03723882

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

![](creatinine_bootstrap_files/figure-markdown_strict/unnamed-chunk-14-1.png)<!-- -->

    myinterval

    ##        10%        90% 
    ## -0.6665540 -0.5723913

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

    ## Warning: confint: Using df=Inf.

    ##        name       lower       upper level method    estimate
    ## 1 Intercept 145.9438823 149.6483186   0.8 stderr 147.8129158
    ## 2       age  -0.6673584  -0.5719115   0.8 stderr  -0.6198159
    ## 3     sigma   6.3841670   7.3367439   0.8 stderr   6.9105379
    ## 4 r.squared   0.6224707   0.7236303   0.8 stderr   0.6724361
    ## 5         F 250.7264505 401.4040296   0.8 stderr 318.1901588
    ##   margin.of.error
    ## 1      1.85221814
    ## 2      0.04772347
    ## 3      0.47628841
    ## 4      0.05057979
    ## 5     75.33878957

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
