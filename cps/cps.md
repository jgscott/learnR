Hourly wages in the Current Population Survey
---------------------------------------------

Learning goal:  
- observe how and why collinearity affects the estimated coefficient and
the ANOVA table for a multiple regression model.

Data files:  
- [http://jgscott.github.io/teaching/data/cps.csv](cps.csv): data from
the [Current Population Survey](http://www.census.gov/cps/)\], a major
source of data about the American labor force.

### ANOVA tables in multiple regression

We'll start by loading the mosaic library, reading in the CPS data set,
and summarizing the variables.

    library(mosaic)
    cps = read.csv("cps.csv", header=TRUE)  # Or use Import Dataset
    summary(cps)

    ##       wage             educ       race     sex     hispanic   south   
    ##  Min.   : 1.000   Min.   : 2.00   NW: 67   F:245   Hisp: 27   NS:378  
    ##  1st Qu.: 5.250   1st Qu.:12.00   W :467   M:289   NH  :507   S :156  
    ##  Median : 7.780   Median :12.00                                       
    ##  Mean   : 9.024   Mean   :13.02                                       
    ##  3rd Qu.:11.250   3rd Qu.:15.00                                       
    ##  Max.   :44.500   Max.   :18.00                                       
    ##                                                                       
    ##     married        exper         union          age             sector   
    ##  Married:350   Min.   : 0.00   Not  :438   Min.   :18.00   prof    :105  
    ##  Single :184   1st Qu.: 8.00   Union: 96   1st Qu.:28.00   clerical: 97  
    ##                Median :15.00               Median :35.00   service : 83  
    ##                Mean   :17.82               Mean   :36.83   manuf   : 68  
    ##                3rd Qu.:26.00               3rd Qu.:44.00   other   : 68  
    ##                Max.   :55.00               Max.   :64.00   manag   : 55  
    ##                                                            (Other) : 58

There are 11 variables in this data set:  
- wage: a person's hourly wage in dollars (the data is from 1985).  
- educ: number of years of formal education. Here 12 indicates the
completion of high school.  
- race: white or non-white.  
- sex: male or female.  
- hispanic: an indicator of whether the person is Hispanic or
non-Hispanic.  
- south: does the person live in a southern (S) or non-southern (NS)
state?  
- married: is the person married or single?  
- exper: number of years of work experience  
- union: an indicator for whether the person is in a union or not.  
- age: age in years  
- sector: clerical, construction, management, manufacturing,
professional (lawyer/doctor/accountant/etc), sales, service, or other.

First consider a two-variable regression model that uses a person's
education level and sector of employment as predictors of his or her
wage:

    lm1 = lm(wage ~ educ + sector, data=cps)
    summary(lm1)

    ## 
    ## Call:
    ## lm(formula = wage ~ educ + sector, data = cps)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -10.344  -2.953  -0.755   2.243  32.102 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)    0.60754    1.33098   0.456  0.64825    
    ## educ           0.52674    0.09647   5.460 7.34e-08 ***
    ## sectorconst    3.02131    1.13154   2.670  0.00782 ** 
    ## sectormanag    4.41563    0.78483   5.626 3.00e-08 ***
    ## sectormanuf    1.53365    0.73969   2.073  0.03862 *  
    ## sectorother    1.66512    0.72821   2.287  0.02262 *  
    ## sectorprof     3.10268    0.69218   4.482 9.07e-06 ***
    ## sectorsales    0.02658    0.87188   0.030  0.97569    
    ## sectorservice -0.18152    0.69298  -0.262  0.79347    
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 4.554 on 525 degrees of freedom
    ## Multiple R-squared:  0.2266, Adjusted R-squared:  0.2148 
    ## F-statistic: 19.23 on 8 and 525 DF,  p-value: < 2.2e-16

Now see what happens when we switch the order of the two variables:

    lm2 = lm(wage ~ sector + educ, data=cps)
    summary(lm2)

    ## 
    ## Call:
    ## lm(formula = wage ~ sector + educ, data = cps)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -10.344  -2.953  -0.755   2.243  32.102 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)    0.60754    1.33098   0.456  0.64825    
    ## sectorconst    3.02131    1.13154   2.670  0.00782 ** 
    ## sectormanag    4.41563    0.78483   5.626 3.00e-08 ***
    ## sectormanuf    1.53365    0.73969   2.073  0.03862 *  
    ## sectorother    1.66512    0.72821   2.287  0.02262 *  
    ## sectorprof     3.10268    0.69218   4.482 9.07e-06 ***
    ## sectorsales    0.02658    0.87188   0.030  0.97569    
    ## sectorservice -0.18152    0.69298  -0.262  0.79347    
    ## educ           0.52674    0.09647   5.460 7.34e-08 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 4.554 on 525 degrees of freedom
    ## Multiple R-squared:  0.2266, Adjusted R-squared:  0.2148 
    ## F-statistic: 19.23 on 8 and 525 DF,  p-value: < 2.2e-16

In a word, nothing! The coefficients, standard errors, t statistics, and
p-values are all the same. That's because the model itself---that is,
the underlying regression equation relating the outcome to the
predictors---is the same regardless of the order in which we name the
variables. (That's because we add the individual terms in the regression
equation together, and [addition is
commutative](http://en.wikipedia.org/wiki/Commutative_property).) This
is comforting: it means our model doesn't depend on some arbitrary
choice of how to order the variables.

However, the ANOVA tables for the two models are different. Let's use
the `simple_anova` function from my website:

    source('http://jgscott.github.io/teaching/r/utils/class_utils.R')

Now we'll use this to construct an ANOVA table. In the first table, it
looks like education contributes more to the fit of the model than
sector of employment:

    simple_anova(lm1)

    ##            Df      R2 R2_improve     sd sd_improve       pval
    ## Intercept   1 0.00000            5.1391                      
    ## educ        1 0.14586   0.145864 4.7540    0.38511 0.0000e+00
    ## sector      7 0.22661   0.080741 4.5538    0.20021 4.9169e-09
    ## Residuals 525

In the second table, it now looks like a person's sector of employment
contributes more to the fit than his or her education:

    simple_anova(lm2)

    ##            Df      R2 R2_improve     sd sd_improve       pval
    ## Intercept   1 0.00000            5.1391                      
    ## sector      7 0.18268   0.182683 4.6768    0.46225 0.0000e+00
    ## educ        1 0.22661   0.043922 4.5538    0.12307 7.3424e-08
    ## Residuals 525

In other words, the ANOVA table usually *does* depend on the order in
which we name the variables, even though the model itself does not. The
only exception is when the variables are independent of one another.
This exception doesn't apply here, because some sectors of the economy
have more educated workers than other sectors. Said concisely, the two
variables are correlated (collinear) with each other:

    bwplot(educ ~ sector, data=cps)

![](cps_files/figure-markdown_strict/unnamed-chunk-7-1.png)

We therefore reach an important conclusion about the ANOVA table for a
multiple-regression model:  
- The ANOVA table attempts to partition credit among the variables by
measuring their contribution to the model's predictable sums of squares.
More specifically, it assigns credit by adding the variables one at a
time and measuring the corresponding decrease in the residual sum of
squares.  
- But the table depends on the ordering of the variables, and the
ordering of the variables is arbitrary.  
- We therefore cannot give credit to the individual variables in a model
without making an arbitrary decision about their order.

Though this seems like a paradox, it's really a manifestation of a
broader concept. In a regression model, the variables work as a team.
And it is difficult to partition credit to the individuals who compose a
team---whether it's a team of lawyers, film-makers, or basketball
players---except in the rare case where the individuals contribute to
the team in totally independent ways.

### Adding collinear variables to a model

In the presence of collinearity, adding new variables to a baseline
model will change the coefficients of the old variables. That's
because:  
- a coefficient in a multiple regression model is a *partial
relationship* between the predictor and the response, holding other
variables constant  
- a partial relationship depends on context, i.e. on what variables are
being held constant.  
- changing the context (by adding new variables) will therefore change
the partial relationship.

Let's see this principle in action, starting with a baseline model of
wages versus a sector of employment, education level, and whether a
worker is a member of union.

    lm3 = lm(wage ~ sector + educ + union, data=cps)
    summary(lm3)

    ## 
    ## Call:
    ## lm(formula = wage ~ sector + educ + union, data = cps)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -10.263  -2.872  -0.852   2.197  32.215 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)    0.62407    1.30962   0.477   0.6339    
    ## sectorconst    2.39793    1.12288   2.136   0.0332 *  
    ## sectormanag    4.50326    0.77250   5.829 9.73e-09 ***
    ## sectormanuf    1.10084    0.73482   1.498   0.1347    
    ## sectorother    1.20935    0.72441   1.669   0.0956 .  
    ## sectorprof     2.84034    0.68382   4.154 3.82e-05 ***
    ## sectorsales    0.15584    0.85841   0.182   0.8560    
    ## sectorservice -0.47462    0.68529  -0.693   0.4889    
    ## educ           0.51127    0.09499   5.383 1.11e-07 ***
    ## unionUnion     2.22675    0.52087   4.275 2.27e-05 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 4.481 on 524 degrees of freedom
    ## Multiple R-squared:  0.2527, Adjusted R-squared:  0.2398 
    ## F-statistic: 19.68 on 9 and 524 DF,  p-value: < 2.2e-16

Look at the coefficient on the union dummy variable: it looks like the
wage premium for union members is about $2.20 per hour, holding
education and employment sector constant.

But look at what happens when we add age to the model:

    lm4 = lm(wage ~ sector + educ + union + age, data=cps)
    summary(lm4)

    ## 
    ## Call:
    ## lm(formula = wage ~ sector + educ + union + age, data = cps)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -10.289  -2.769  -0.647   2.044  33.845 
    ## 
    ## Coefficients:
    ##               Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)   -4.10664    1.55576  -2.640 0.008547 ** 
    ## sectorconst    2.51598    1.09493   2.298 0.021964 *  
    ## sectormanag    4.11110    0.75671   5.433 8.51e-08 ***
    ## sectormanuf    1.33473    0.71773   1.860 0.063495 .  
    ## sectorother    1.71997    0.71272   2.413 0.016154 *  
    ## sectorprof     2.53735    0.66909   3.792 0.000167 ***
    ## sectorsales   -0.00088    0.83739  -0.001 0.999162    
    ## sectorservice -0.38637    0.66831  -0.578 0.563419    
    ## educ           0.62607    0.09508   6.584 1.11e-10 ***
    ## unionUnion     1.81954    0.51353   3.543 0.000431 ***
    ## age            0.08980    0.01687   5.322 1.53e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 4.368 on 523 degrees of freedom
    ## Multiple R-squared:  0.2911, Adjusted R-squared:  0.2775 
    ## F-statistic: 21.47 on 10 and 523 DF,  p-value: < 2.2e-16

Now our estimate of the wage premium for union members is a lot less:
about $1.80 per hour rather than $2.20. What happened?

Well, union members tend to be older than non-union members (i.e. union
status and age are correlated/collinear):

    mean(age ~ union, data=cps)

    ##      Not    Union 
    ## 36.17808 39.82292

And older works tend to earn more on average, than younger workers (the
correlation is about 17%):

    cor(wage ~ age, data=cps)

    ## [1] 0.1769669

That makes age a confounding variable for the relationship between union
status and wages. Controlling for this confounding variable changes our
estimate of the wage premium for union membership: some (but not all) of
the variation in wages that we previously were attributing to union
membership now gets attributed to age, instead.

This is a very general phenomenon in multiple regression modeling. If
you add a variable to a baseline model, and that variable is correlated
with some of the variables already in the model, then the coefficients
on those old variables will change in the new model.
