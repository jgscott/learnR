Predictive models for flu activity: Google flu trends
-----------------------------------------------------

In this walk-through, you'll build and test a predictive model using
stepwise selection.

The data you'll look at contain weekly data from the Centers for Disease
Control on the number of influenza-like illnesses reported in the
south-eastern United States. This column is labeled "TILI" in the two
data files below. The data run from 2008 through the last week of 2011.

In addition, you have information on 86 flu-related search terms from
Google's databases. Some are obvious ("how.long.does.flu.last"); some
tug at the heart a bit ("child.temperature"); a handful are funny
("can.dogs.get.the.flu"). Each entry indicates how often someone Googled
that phrase during that particular week. The units here are standard
deviations above the mean for that particular search string (or any
search string containing the given string). Thus a positive number
indicates that more people Googled that phrase in that particular week
than they did in an average week.

Data files:  
\* [flu.csv](http://jgscott.github.io/teaching/data/flu.csv): data from
2008 through 2011.

As usual, load the mosaic library and the data set.

    library(mosaic)
    flu = read.csv("flu.csv", header=TRUE)
    names(flu)  # the actual search terms

    ##  [1] "week"                                    
    ##  [2] "cdcflu"                                  
    ##  [3] "dangerous.fever"                         
    ##  [4] "how.long.does.flu.last"                  
    ##  [5] "i.have.the.flu"                          
    ##  [6] "fever.cough"                             
    ##  [7] "what.to.eat.when.you.have.the.flu"       
    ##  [8] "medicine.for.flu"                        
    ##  [9] "how.long.are.you.contagious.with.the.flu"
    ## [10] "viral.pneumonia"                         
    ## [11] "how.to.get.over.the.flu"                 
    ## [12] "treat.the.flu"                           
    ## [13] "signs.of.the.flu"                        
    ## [14] "flu.contagious"                          
    ## [15] "ear.thermometer"                         
    ## [16] "can.dogs.get.the.flu"                    
    ## [17] "anas.barbariae.hepatis"                  
    ## [18] "how.to.treat.flu"                        
    ## [19] "cure.flu"                                
    ## [20] "treat.flu"                               
    ## [21] "cold.or.flu"                             
    ## [22] "what.is.a.high.fever"                    
    ## [23] "oscillococcinum"                         
    ## [24] "treatment.for.flu"                       
    ## [25] "remedies.for.flu"                        
    ## [26] "how.to.get.rid.of.the.flu"               
    ## [27] "bacterial.pneumonia"                     
    ## [28] "symptoms.of.the.flu"                     
    ## [29] "fever.and.cough"                         
    ## [30] "braun.thermoscan"                        
    ## [31] "how.long.am.i.contagious"                
    ## [32] "home.remedies.for.flu"                   
    ## [33] "cough.fever"                             
    ## [34] "cure.the.flu"                            
    ## [35] "low.body.temperature"                    
    ## [36] "contagious.flu"                          
    ## [37] "headache.cough"                          
    ## [38] "painful.cough"                           
    ## [39] "get.rid.of.flu"                          
    ## [40] "normal.body"                             
    ## [41] "cough.headache"                          
    ## [42] "how.to.fight.the.flu"                    
    ## [43] "flu.or.cold"                             
    ## [44] "over.the.counter.flu.medicine"           
    ## [45] "flu.and.fever"                           
    ## [46] "viral.bronchitis"                        
    ## [47] "thermoscan"                              
    ## [48] "taking.temperature"                      
    ## [49] "influenza.a.and.b"                       
    ## [50] "fever.flu"                               
    ## [51] "oral.thermometer"                        
    ## [52] "the.flu"                                 
    ## [53] "medicine.for.the.flu"                    
    ## [54] "treat.a.fever"                           
    ## [55] "cough.after.flu"                         
    ## [56] "acute.bronchitis"                        
    ## [57] "what.to.do.when.you.have.the.flu"        
    ## [58] "bronchitis"                              
    ## [59] "extractum"                               
    ## [60] "best.flu.medicine"                       
    ## [61] "how.long.are.you.contagious"             
    ## [62] "fever.reducers"                          
    ## [63] "body.temperature"                        
    ## [64] "reduce.fever"                            
    ## [65] "flu.remedies"                            
    ## [66] "anas.barbariae.hepatis.et.cordis"        
    ## [67] "remedies.for.the.flu"                    
    ## [68] "symptoms.pneumonia"                      
    ## [69] "viral.syndrome"                          
    ## [70] "the.flu.symptoms"                        
    ## [71] "what.is.influenza"                       
    ## [72] "pneumonia"                               
    ## [73] "fever.temperature"                       
    ## [74] "child.temperature"                       
    ## [75] "incubation.period.for.the.flu"           
    ## [76] "high.fever"                              
    ## [77] "low.body.temp"                           
    ## [78] "how.long.does.fever.last"                
    ## [79] "is.it.the.flu"                           
    ## [80] "what.to.do.for.the.flu"                  
    ## [81] "fight.the.flu"                           
    ## [82] "symptoms.of.bronchitis"                  
    ## [83] "bacterial.bronchitis"                    
    ## [84] "chest.cough"                             
    ## [85] "fever.breaks"                            
    ## [86] "cough.and.fever"                         
    ## [87] "fever.too.high"                          
    ## [88] "early.flu.symptoms"

### Data cleaning and pre-processing

The first thing to notice here is that the data set has 21 observations
with missing outcome variables, denoted `NA`:

    summary(flu$cdcflu)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   100.0   399.0   708.0   939.1  1111.0  4565.0      21

We can use the `is.na` function to tell us which cases these are:

    na_cases = which(is.na(flu$cdcflu))
    flu[na_cases, 1:2]

    ##          week cdcflu
    ## 21 2008-05-25     NA
    ## 22 2008-06-01     NA
    ## 23 2008-06-08     NA
    ## 24 2008-06-15     NA
    ## 25 2008-06-22     NA
    ## 26 2008-06-29     NA
    ## 27 2008-07-06     NA
    ## 28 2008-07-13     NA
    ## 29 2008-07-20     NA
    ## 30 2008-07-27     NA
    ## 31 2008-08-03     NA
    ## 32 2008-08-10     NA
    ## 33 2008-08-17     NA
    ## 34 2008-08-24     NA
    ## 35 2008-08-31     NA
    ## 36 2008-09-07     NA
    ## 37 2008-09-14     NA
    ## 38 2008-09-21     NA
    ## 39 2008-09-28     NA
    ## 40 2008-10-05     NA
    ## 41 2008-10-12     NA

It looks like these are all in the summer, way out of flu season. We'll
remove these cases (rows) from the data set, since we can't learn
anything from a data point where the y variable isn't observed.

    flu = flu[-na_cases,]

We next need to take care of a minor pre-processing step: separating the
"week" variable from the data. We don't want R thinking "week" is a
variable to be used for prediction when we build a model. Therefore,
we'll peel the first column off the data set and save it as a separate
"flu\_week" variable. Then we'll delete that first column from the main
data set.

    flu_week = flu[,1]
    flu = flu[,-1]

Now we'll tell R that to use the `flu_week` variable as the row names of
the `flu` data frame. That way we'll have informative row names:

    rownames(flu) = flu_week
    flu[1:6,1:3]  # first 6 rows and 3 columns

    ##            cdcflu dangerous.fever how.long.does.flu.last
    ## 2008-01-06    880          -0.577                 -0.091
    ## 2008-01-13   1620          -0.577                  0.993
    ## 2008-01-20   1213           1.019                  0.583
    ## 2008-01-27   1959           0.737                  2.554
    ## 2008-02-03   2921           1.281                  2.189
    ## 2008-02-10   2739           2.119                  3.813

### Building and checking a predictive model

Let's start by plotting the outcome variable over time and compare this
to one of the predictors:

    plot(cdcflu~flu_week, data=flu)

![](flu_files/figure-markdown_strict/unnamed-chunk-7-1.png)

    plot(over.the.counter.flu.medicine~flu_week, data=flu)

![](flu_files/figure-markdown_strict/unnamed-chunk-7-2.png)

It looks like the search terms will be useful here; certainly searches
for "over the counter flu medicine" look to have a very similar seasonal
pattern as actual flu cases.

To illustrate the process of building and checking a predictive model,
let's do three things:  
1. Split the data into a training and testing set.  
2. Fit a model to the training set.  
3. Make predictions on the testing set and check our generalization
error.

First, let's create our training and testing sets. There are 187 data
points in the sample; let's use 150 of them (about 80%) as a training
set, and the remaining 20% as a testing set.

To do this, we'll use the `sample` function to randomly sample a set of
cases in the training set:

    n = nrow(flu)  # how many total observations?
    train_cases = sample(1:n, size=150) # which cases are in the training set?
    flu_train = flu[train_cases,] # these cases in the training set
    flu_test = flu[-train_cases,] # remaining cases in testing set

The `train_cases` variable tells you which rows (cases) of the flu data
frame are in the training set. We store these rows in the `flu_train`
data frame, and the remaining ones in the `flu_test` data frame.

Now let's fit a simple model (with only three search terms) using the
data in `flu_train`, and then use the data in `flu_test` to make
predictions.

    lm1 = lm(cdcflu ~ flu.and.fever + over.the.counter.flu.medicine + treat.a.fever, data=flu_train)
    yhat_test = predict(lm1, newdata=flu_test)

These are *out-of-sample* predictions, since we didn't use these data
points to help fit the original model. These predictions are reasonably
well correlated with the actual responses in the testing set:

    plot(cdcflu ~ yhat_test, data = flu_test)
    abline(0,1)

![](flu_files/figure-markdown_strict/unnamed-chunk-10-1.png)

Finally, let's calculate the mean-squared prediction error (MSPE) on the
test set:

    MSPE =  mean( (yhat_test-flu_test$cdcflu)^2)
    RMSPE = sqrt(MSPE)
    RMSPE

    ## [1] 345.2796

Your number will be slightly different from mine, since the train/test
split is random.

### Averaging over multiple train/test splits

Our estimate of the mean-squared prediction error depends on the
particular (random) way in which we split the data into training and
testing sets. To reduce this dependence, we can average our results over
many different train/test splits. This is easy to accomplish in R, by
placing our code for split/fit/test inside a loop.

The code below averages the RMSPE over 100 different train/test splits:

    n_splits = 100
    out = do(n_splits)*{
      # Step 1: split
      train_cases = sample(1:n, size=150) # different sample each time
      flu_train = flu[train_cases,] # training set
      flu_test = flu[-train_cases,] # testing set

      # Step 2: fit
      lm1 = lm(cdcflu ~ flu.and.fever + over.the.counter.flu.medicine +
                 treat.a.fever, data=flu_train)
      
      # Step 3: test
      yhat_test = predict(lm1, newdata=flu_test)
      MSPE =  mean( (yhat_test-flu_test$cdcflu)^2)
      RMSPE = sqrt(MSPE)
      RMSPE
    }

We now have 100 different estimates of the (root) mean-squared
predictive error:

    hist(out$result)

![](flu_files/figure-markdown_strict/unnamed-chunk-13-1.png)

And we can average these to get an estimate of MSPE that is less subject
to Monte Carlo variability:

    mean(out$result)

    ## [1] 411.2591

### Comparing with the full model

Can we do better than this simple three-variable model? To see, we'll
use every search term in the data set as a predictor. This will give us
quite a big model, with 87 parameters (an intercept + 86 search terms).
In the following model statement, the \`.' means "use every variable not
otherwise named."

    lm_big = lm(cdcflu ~ ., data=flu_train)
    coef(lm_big)

    ##                              (Intercept) 
    ##                               773.751306 
    ##                          dangerous.fever 
    ##                               -16.069917 
    ##                   how.long.does.flu.last 
    ##                               155.834269 
    ##                           i.have.the.flu 
    ##                              -136.647130 
    ##                              fever.cough 
    ##                               268.507169 
    ##        what.to.eat.when.you.have.the.flu 
    ##                                88.998717 
    ##                         medicine.for.flu 
    ##                               238.297889 
    ## how.long.are.you.contagious.with.the.flu 
    ##                              -129.091167 
    ##                          viral.pneumonia 
    ##                                34.402334 
    ##                  how.to.get.over.the.flu 
    ##                               192.427480 
    ##                            treat.the.flu 
    ##                               154.396828 
    ##                         signs.of.the.flu 
    ##                               243.679892 
    ##                           flu.contagious 
    ##                                -2.041536 
    ##                          ear.thermometer 
    ##                               -81.425067 
    ##                     can.dogs.get.the.flu 
    ##                                23.607846 
    ##                   anas.barbariae.hepatis 
    ##                               273.472211 
    ##                         how.to.treat.flu 
    ##                                85.119564 
    ##                                 cure.flu 
    ##                               192.643967 
    ##                                treat.flu 
    ##                               134.812447 
    ##                              cold.or.flu 
    ##                               -19.260745 
    ##                     what.is.a.high.fever 
    ##                               -20.911138 
    ##                          oscillococcinum 
    ##                               -35.449024 
    ##                        treatment.for.flu 
    ##                               146.871701 
    ##                         remedies.for.flu 
    ##                              -115.091641 
    ##                how.to.get.rid.of.the.flu 
    ##                                 8.665804 
    ##                      bacterial.pneumonia 
    ##                               -63.823735 
    ##                      symptoms.of.the.flu 
    ##                              -306.486844 
    ##                          fever.and.cough 
    ##                                37.932355 
    ##                         braun.thermoscan 
    ##                               -30.114003 
    ##                 how.long.am.i.contagious 
    ##                              -112.928445 
    ##                    home.remedies.for.flu 
    ##                              -227.243697 
    ##                              cough.fever 
    ##                              -173.720832 
    ##                             cure.the.flu 
    ##                              -200.293149 
    ##                     low.body.temperature 
    ##                              -189.700095 
    ##                           contagious.flu 
    ##                               232.587105 
    ##                           headache.cough 
    ##                                22.117613 
    ##                            painful.cough 
    ##                               -35.874104 
    ##                           get.rid.of.flu 
    ##                               -35.543430 
    ##                              normal.body 
    ##                               -38.055821 
    ##                           cough.headache 
    ##                               -17.375703 
    ##                     how.to.fight.the.flu 
    ##                                 4.785462 
    ##                              flu.or.cold 
    ##                              -260.844435 
    ##            over.the.counter.flu.medicine 
    ##                              -119.491463 
    ##                            flu.and.fever 
    ##                               -28.879033 
    ##                         viral.bronchitis 
    ##                                11.629557 
    ##                               thermoscan 
    ##                                91.225057 
    ##                       taking.temperature 
    ##                                35.916752 
    ##                        influenza.a.and.b 
    ##                                -9.335658 
    ##                                fever.flu 
    ##                               177.260550 
    ##                         oral.thermometer 
    ##                                58.623686 
    ##                                  the.flu 
    ##                                26.813551 
    ##                     medicine.for.the.flu 
    ##                                 2.749747 
    ##                            treat.a.fever 
    ##                              -230.198040 
    ##                          cough.after.flu 
    ##                              -120.611724 
    ##                         acute.bronchitis 
    ##                                35.275416 
    ##         what.to.do.when.you.have.the.flu 
    ##                               -55.238521 
    ##                               bronchitis 
    ##                                 6.178018 
    ##                                extractum 
    ##                               -21.064994 
    ##                        best.flu.medicine 
    ##                                69.606859 
    ##              how.long.are.you.contagious 
    ##                               -93.977675 
    ##                           fever.reducers 
    ##                               112.354988 
    ##                         body.temperature 
    ##                               -29.056927 
    ##                             reduce.fever 
    ##                               -56.796043 
    ##                             flu.remedies 
    ##                              -600.712699 
    ##         anas.barbariae.hepatis.et.cordis 
    ##                                48.389338 
    ##                     remedies.for.the.flu 
    ##                              -250.703573 
    ##                       symptoms.pneumonia 
    ##                               -31.261587 
    ##                           viral.syndrome 
    ##                               124.958869 
    ##                         the.flu.symptoms 
    ##                                 9.650402 
    ##                        what.is.influenza 
    ##                                65.749104 
    ##                                pneumonia 
    ##                               -46.313597 
    ##                        fever.temperature 
    ##                                30.248829 
    ##                        child.temperature 
    ##                                55.190036 
    ##            incubation.period.for.the.flu 
    ##                                61.528149 
    ##                               high.fever 
    ##                              -127.738847 
    ##                            low.body.temp 
    ##                               -71.379277 
    ##                 how.long.does.fever.last 
    ##                               260.629467 
    ##                            is.it.the.flu 
    ##                                81.349326 
    ##                   what.to.do.for.the.flu 
    ##                                23.353996 
    ##                            fight.the.flu 
    ##                               195.646005 
    ##                   symptoms.of.bronchitis 
    ##                               292.040884 
    ##                     bacterial.bronchitis 
    ##                                56.788870 
    ##                              chest.cough 
    ##                                79.704834 
    ##                             fever.breaks 
    ##                               -35.949067 
    ##                          cough.and.fever 
    ##                               -18.660017 
    ##                           fever.too.high 
    ##                                61.800394 
    ##                       early.flu.symptoms 
    ##                                -6.747565

Let's use the testing set to compare the error of this big model with
the small three-variable model:

    # Fit small model
    lm_small = lm(cdcflu ~ flu.and.fever + over.the.counter.flu.medicine + treat.a.fever, data=flu_train)

    # Form predictions
    yhat_test_small = predict(lm_small, newdata=flu_test)
    yhat_test_big = predict(lm_big, newdata=flu_test)

    # Check generalization error of each model
    RMSPE_small = sqrt(mean( (yhat_test_small-flu_test$cdcflu)^2))
    RMSPE_big = sqrt(mean( (yhat_test_big-flu_test$cdcflu)^2))

    # The result?
    c(RMSPE_small, RMSPE_big)

    ## [1] 366.0329 574.5212

This tells which model performed better on this particular testing set.
But clearly it will be better to average over many different train/test
splits.

    n_splits = 100
    out = do(n_splits)*{
      # Step 1: split
      train_cases = sample(1:n, size=150) # different sample each time
      flu_train = flu[train_cases,] # training set
      flu_test = flu[-train_cases,] # testing set

      # Step 2: fit both models
      lm_big = lm(cdcflu ~ ., data=flu_train)
      lm_small = lm(cdcflu ~ flu.and.fever + over.the.counter.flu.medicine +
                      treat.a.fever, data=flu_train)

      # Step 3: form predictions and test
      yhat_test_small = predict(lm_small, newdata=flu_test)
      yhat_test_big = predict(lm_big, newdata=flu_test)
      RMSPE_small = sqrt(mean( (yhat_test_small-flu_test$cdcflu)^2))
      RMSPE_big = sqrt(mean( (yhat_test_big-flu_test$cdcflu)^2))

      # The result?
      c(RMSPE_small, RMSPE_big)
    }

And now we can calculate the mean of each model's generalization error
across all these different train/test splits:

    colMeans(out)

    ##       V1       V2 
    ## 408.1512 511.1926

It looks as though the big model has *worse* generalization error than
the simple three-variable model --- a classic example of overfitting. In
this case, the big model has 87 parameters, but there are only 150 data
points in the training set, and so the big model is overwhelmed by noise
in the data.

### Using stepwise selection

We've seem that the small three-variable model actually outperforms the
big, 86-variable model at prediction. But is there some happy medium?
That is, can we do better by including somewhere between 3 and 86
variables?

We'll use stepwise selection to search for a model that leads to
superior generalization error, starting from the big model. Notice that
we use *all* the data, not just the training data, to actually search
for a model using stepwise selection:

    lm_big = lm(cdcflu ~ ., data=flu)
    lm_step = step(lm_big, data = flu, trace=0)
    coef(lm_step)

    ##                   (Intercept)        how.long.does.flu.last 
    ##                     689.02117                     173.03993 
    ##               viral.pneumonia       how.to.get.over.the.flu 
    ##                     152.86586                     147.26484 
    ##              signs.of.the.flu                flu.contagious 
    ##                     154.90361                     -29.27350 
    ##          can.dogs.get.the.flu        anas.barbariae.hepatis 
    ##                     101.02217                     153.24357 
    ##                      cure.flu                     treat.flu 
    ##                     180.58940                      43.83036 
    ##             treatment.for.flu              remedies.for.flu 
    ##                     116.62396                    -291.86649 
    ##     how.to.get.rid.of.the.flu           symptoms.of.the.flu 
    ##                      54.00117                    -148.97596 
    ##                  cure.the.flu          low.body.temperature 
    ##                    -114.24131                    -165.14211 
    ##                contagious.flu                 painful.cough 
    ##                      80.86923                     130.34918 
    ##                   flu.or.cold                    thermoscan 
    ##                    -225.87288                      53.26366 
    ##            taking.temperature                     fever.flu 
    ##                      84.86497                     153.94250 
    ##              oral.thermometer                 treat.a.fever 
    ##                      89.74740                    -114.22976 
    ##                fever.reducers                  reduce.fever 
    ##                     154.33660                     -72.75817 
    ##                  flu.remedies            symptoms.pneumonia 
    ##                    -336.41910                     -34.60397 
    ##             what.is.influenza incubation.period.for.the.flu 
    ##                     135.13813                     -67.56347 
    ##                    high.fever      how.long.does.fever.last 
    ##                     -65.25695                     110.52540 
    ##                   chest.cough 
    ##                     -48.53005

We can also compare the sizes of the two models:

    length(coef(lm_big))

    ## [1] 87

    length(coef(lm_step))

    ## [1] 33

This model uses 32 variables (plus an intercept) -- more than 3, but a
lot less than 86!

Let's now see how our stepwise-selection model performs when we test its
true out-of-sample performance. There's a cute trick we can use here to
save a lot of typing. Having fit the model to the full data set, we can
use the `update` function to refit that model to the training data only.
This saves us from having to laboriously type out the model formula
using all 32 variables selected by the `step` function:

    # Step 1: split
    train_cases = sample(1:n, size=150) # different sample each time
    flu_train = flu[train_cases,] # training set
    flu_test = flu[-train_cases,] # testing set

    # Step 2: fit the model, i.e. update the stepwise-selected model
    # to use the training data only rather than the full data set
    lm_step_train = update(lm_step, data=flu_train)  # use update rather than lm

    # Step 3: form predictions and test
    yhat_test_step = predict(lm_step_train, newdata=flu_test)
    RMSPE_step = sqrt(mean( (yhat_test_step-flu_test$cdcflu)^2))

And the result?

    RMSPE_step

    ## [1] 252.5198

Again, your number will be different because of Monte Carlo variability.

Of course, we'll get much more stable results by averaging over lots of
train/test splits. Let's do this, and compare the generalization error
to what we get from the small and big models on the same set of splits:

    out = do(100)*{
      # Step 1: split
      train_cases = sample(1:n, size=150) # different sample each time
      flu_train = flu[train_cases,] # training set
      flu_test = flu[-train_cases,] # testing set
      
      # Step 2: fit all three models (the stepwise model using update)
      lm_big = lm(cdcflu ~ ., data=flu_train)
      lm_small = lm(cdcflu ~ flu.and.fever + over.the.counter.flu.medicine +
                       treat.a.fever, data=flu_train)
      lm_step_train = update(lm_step, data=flu_train)  # use update rather than lm
      
      # Step 3: form predictions and test
      yhat_test_big = predict(lm_big, newdata=flu_test)
      yhat_test_small = predict(lm_small, newdata=flu_test)
      yhat_test_step = predict(lm_step_train, newdata=flu_test)
      RMSPE_big = sqrt(mean( (yhat_test_big-flu_test$cdcflu)^2))
      RMSPE_small = sqrt(mean( (yhat_test_small-flu_test$cdcflu)^2))
      RMSPE_step = sqrt(mean( (yhat_test_step-flu_test$cdcflu)^2))
      
      # The result?
      c(RMSPE_small, RMSPE_big, RMSPE_step)
    }

    # Average of the different splits
    colMeans(out)

    ##       V1       V2       V3 
    ## 415.8322 519.5109 286.9927

Your numbers will be a bit different, but on average, you should notice
that the stepwise model (the third entry) significantly outperforms both
the small model and the big model.
