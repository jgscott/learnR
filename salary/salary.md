### Example: predictors of white-collar salaries

In this walk-through, we'll look at whether there seems to be a "wage
gap" at a tech firm between male and female employees with similar
qualifications. We will use multiple regression to adjust for the effect
of education and experience in evaluating the correlation between an
employee's sex and his or her annual salary.

Learning goals:  
- fit a multiple regression model  
- correctly interpret the estimated coefficients  
- quantify uncertainty about parameters in a multiple-regression model
using bootstrapping

Data files:  
- [salary.csv](http://jgscott.github.io/teaching/data/salary.csv):
human-resources data on employees at a tech firm.

First load the mosaic library and read in the data.

    library(mosaic)

The variables we'll use from this data set are:  
- Salary: annual salary in dollars  
- Experience: months of experience at the particular company  
- Months: total months of work experience, including all previous jobs  
- Sex: whether the employee is male or female

Let's first Look at the distibution of salary by sex.

    mean(Salary~Sex,data=salary)

    ##        0        1 
    ## 62610.45 59381.90

    boxplot(Salary~Sex,data=salary, names=c("Female", "Male"))

![](salary_files/figure-markdown_strict/unnamed-chunk-3-1.png)

Upon first glance, it looks as though women are paid more at this
company than men, on average.

### Statistical adjustment for experience.

However, does the story change if we adjust for work experience?

    plot(Salary~Experience, data=salary)

![](salary_files/figure-markdown_strict/unnamed-chunk-4-1.png)

    lm1 = lm(Salary~Experience, data=salary)
    coef(lm1)

    ## (Intercept)  Experience 
    ##  52516.6821    361.5327

We expect experienced workers to be paid more, all else being equal. How
do these residuals---that is, salary adjusted for experience---look when
we stratify them by sex?

    boxplot(resid(lm1)~salary$Sex)

![](salary_files/figure-markdown_strict/unnamed-chunk-5-1.png)

Now it looks like men are being paid more than women for an equivalent
amount of work experience, since men have a positive residual, on
average. The story is similar if we look at overall work experience,
including jobs prior to the one with this particular company:

    plot(Salary~Months, data=salary)

![](salary_files/figure-markdown_strict/unnamed-chunk-6-1.png)

    lm2 = lm(Salary~Months, data=salary)
    coef(lm2)

    ## (Intercept)      Months 
    ##  44807.1515    277.8743

The story in the residuals is similar: the distribution of adjusted
salaries for men is shifted upward compared to that for women.

    boxplot(resid(lm2)~salary$Sex)

![](salary_files/figure-markdown_strict/unnamed-chunk-7-1.png)

### Fitting a multiple regression model by least squares

To get at the partial relationship between gender and salary, we must
fit multiple-regression model that accounts for experience with the
company and total number of months of professional work. We will also
adjust for a third variable: years of post-secondary education. It is
straightforward to fit such a model by least squares in R.

    lm3 = lm(Salary ~ Experience + Months + Education + Sex, data=salary)
    coef(lm3)

    ## (Intercept)  Experience      Months   Education         Sex 
    ##  39305.7117    122.2467    263.5782    591.0780   2320.5438

According to this model, men are paid $2320 more per year than women
with similar levels of education and work experience, both overall and
with this particular company.

### Bootstrapping a multiple regression model

We can quantify our uncertainty about this effect via bootstrapping:

    boot3 = do(5000)*{
      lm(Salary~Experience+Months+Education+Sex, data=resample(salary))
    }
    hist(boot3$Sex)

![](salary_files/figure-markdown_strict/unnamed-chunk-9-1.png)

    confint(boot3)

    ##         name         lower        upper level     method     estimate
    ## 1  Intercept 35215.3701998 4.493656e+04  0.95 percentile 3.930571e+04
    ## 2 Experience    44.3151747 1.950210e+02  0.95 percentile 1.222467e+02
    ## 3     Months   236.7148283 2.921528e+02  0.95 percentile 2.635782e+02
    ## 4  Education  -736.8814256 1.434428e+03  0.95 percentile 5.910780e+02
    ## 5        Sex   190.9743496 4.326123e+03  0.95 percentile 2.320544e+03
    ## 6      sigma  1967.5649458 2.962562e+03  0.95 percentile 2.672043e+03
    ## 7  r.squared     0.9151387 9.665268e-01  0.95 percentile 9.380802e-01
    ## 8          F   102.4474432 2.743087e+02  0.95 percentile 1.439242e+02

In this case, the bootstrapped confidence interval runs from about $160
to about $4300. (You'll get slightly different confidence intervals than
shown here, because of the Monte Carlo variability inherent to
bootstrapping.) This is quite a wide range: we cannot rule out that the
wage gap is quite small, but nor can we rule out that it might run into
the thousands of dollars.
