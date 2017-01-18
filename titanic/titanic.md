Contingency tables
==================

In this walk-through, you will learn a few tools for summarizing
categorical data using contingency tables. You will also learn two other
basic data-handling skills:  
- to look at subsets of a data set defined by conditioning on a specific
variable, using the `subset` function, and  
- to turn a numerical variable into a categorical variable using the
`cut` function.

Data files:  
\*
[TitanicSurvival.csv](http://jgscott.github.io/teaching/data/TitanicSurvival.csv)

First download the TitanicSurvival.csv file and read it in. You can use
RStudio's Import Dataset button, or the read.csv command:

    TitanicSurvival = read.csv('TitanicSurvival.csv')

Let's look at the first few lines of the data set, which we can do using
the `head` function.

    head(TitanicSurvival)

    ##                                 X survived    sex     age passengerClass
    ## 1   Allen, Miss. Elisabeth Walton      yes female 29.0000            1st
    ## 2  Allison, Master. Hudson Trevor      yes   male  0.9167            1st
    ## 3    Allison, Miss. Helen Loraine       no female  2.0000            1st
    ## 4 Allison, Mr. Hudson Joshua Crei       no   male 30.0000            1st
    ## 5 Allison, Mrs. Hudson J C (Bessi       no female 25.0000            1st
    ## 6             Anderson, Mr. Harry      yes   male 48.0000            1st

We can see the name of each passenger and whether they survived, along
with their age, sex, and cabin class.

Next, we'll use the xtabs (for cross-tabulate) function to make some
contingency tables. We can stratify by survival status and sex:

    xtabs(~survived + sex, data=TitanicSurvival)

    ##         sex
    ## survived female male
    ##      no     127  682
    ##      yes    339  161

Or by passenger class:

    xtabs(~survived + passengerClass, data=TitanicSurvival)

    ##         passengerClass
    ## survived 1st 2nd 3rd
    ##      no  123 158 528
    ##      yes 200 119 181

Or by all three, to yield a multi-way table:

    xtabs(~survived + passengerClass + sex, data=TitanicSurvival)

    ## , , sex = female
    ## 
    ##         passengerClass
    ## survived 1st 2nd 3rd
    ##      no    5  12 110
    ##      yes 139  94 106
    ## 
    ## , , sex = male
    ## 
    ##         passengerClass
    ## survived 1st 2nd 3rd
    ##      no  118 146 418
    ##      yes  61  25  75

Notice how this is presented as a set of two-way tables, given the
constraints of the two-dimensional screen.

We can also turn a table of counts into a table of proportions using the
`prop.table` command.

    table1 = xtabs(~survived + sex, data=TitanicSurvival)
    prop.table(table1, margin=1)

    ##         sex
    ## survived    female      male
    ##      no  0.1569839 0.8430161
    ##      yes 0.6780000 0.3220000

The first command says to store the table of raw counts in a variable
called `table1`. The second says to turn the counts into proportions,
standardizing so that the rows (margin=1) sum to 1.

We can also standardize along the columns. In fact, this probably makes
more sense here. We're thinking of sex as the predictor and survival as
the response, and therefore we want to see how the relative chances of
survival changes for men versus women:

    prop.table(table1, margin=2)

    ##         sex
    ## survived    female      male
    ##      no  0.2725322 0.8090154
    ##      yes 0.7274678 0.1909846

### Relative risk

From the last table above (where the columns sum to 1), we can compute
the relative risk and odds ratio. First, the relative risk. The risk of
dying for men is the 1st row, second column of the table. We can access
this number by explicitly referring to the row and column numbers inside
brackets, like this:

    risk_table = prop.table(table1, margin=2)
    risk_men = risk_table[1,2]
    risk_men

    ## [1] 0.8090154

Or about 81%.

Similarly, the risk of dying for women is the first row, first column of
the standardized table:

    risk_women = risk_table[1,1]
    risk_women

    ## [1] 0.2725322

Or about 27%.

Now we can compute the relative risk from these two quantities:

    relative_risk = risk_men/risk_women
    relative_risk

    ## [1] 2.968513

It looks like men were about three times as likely to die on the Titanic
as women.

### Discretizing a variable into categories

Our data set on the Titanic also has a numerical variable called `age`,
measured in years. Incidentally, this piece of information is missing
for 263 of the passengers:

    summary(TitanicSurvival$age)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.1667 21.0000 28.0000 29.8800 39.0000 80.0000     263

The age of these 263 people is shown as NA, for "not available."

Let's say we want to build a table of relative survival rates for
children (i.e. those 17 and younger). This requires that we convert the
age variable into categories.

We can do this using the `cut` function, like so:

    TitanicSurvival$AgeCategory = cut(TitanicSurvival$age, breaks=c(0,17,80))

This expression has a lot going on. Focus on the righthand side first:
we've cut the age variable in the TitanicSurvival data frame, choosing
0, 17, and 80 as the endpoints of our intervals. We chose 80, because
that was the maximum age in the data set; and 0, because that was
slightly lower than the lowest age in the data set (the intervals are
right-inclusive by default).

We've then taken the result of the right-hand side and stored it in a
new variable called AgeCategory, which now lives in the TitanicSurvival
data frame. If we ask for a new summary of the TitanicSurvival data set,
we'll see the fruits of our labor:

    summary(TitanicSurvival)

    ##                                X        survived      sex     
    ##  Abbing, Mr. Anthony            :   1   no :809   female:466  
    ##  Abbott, Master. Eugene Joseph  :   1   yes:500   male  :843  
    ##  Abbott, Mr. Rossmore Edward    :   1                         
    ##  Abbott, Mrs. Stanton (Rosa Hunt:   1                         
    ##  Abelseth, Miss. Karen Marie    :   1                         
    ##  Abelseth, Mr. Olaus Jorgensen  :   1                         
    ##  (Other)                        :1303                         
    ##       age          passengerClass  AgeCategory 
    ##  Min.   : 0.1667   1st:323        (0,17] :154  
    ##  1st Qu.:21.0000   2nd:277        (17,80]:892  
    ##  Median :28.0000   3rd:709        NA's   :263  
    ##  Mean   :29.8811                               
    ##  3rd Qu.:39.0000                               
    ##  Max.   :80.0000                               
    ##  NA's   :263

The new variable we've created, AgeCategory, tells us whether someone is
a child or adult.

Let's now use this to build a table:

    xtabs(~survived + AgeCategory, data=TitanicSurvival)

    ##         AgeCategory
    ## survived (0,17] (17,80]
    ##      no      73     546
    ##      yes     81     346

Many more children than adults survived.

### Subsets of the data

R makes it easy to condition on a variable in looking at various data
summaries. For example, let's say we want to look at survival status
versus age for males alone. We can do this using the subset function:

    TitanicMales = subset(TitanicSurvival, sex=="male")

This command creates a subset of the original data set containing all
the males and none of the females. Note two things about the right-hand
side of this expression:  
1. We put "male" in quotation marks, because sex is a categorical
variable.  
2. The double-equals sign `==` is used to check for equality, as opposed
to the single equals sign `=` used in variable assignment.

Let's now build a table from this subset:

    xtabs(~survived + AgeCategory, data=TitanicMales)

    ##         AgeCategory
    ## survived (0,17] (17,80]
    ##      no      51     472
    ##      yes     31     104

Many more children than adults survived.

We could have actually accomplished the same thing in a single line, by
chaining together the two statements:

    xtabs(~survived + AgeCategory, data=subset(TitanicSurvival, sex=="male"))

    ##         AgeCategory
    ## survived (0,17] (17,80]
    ##      no      51     472
    ##      yes     31     104

    xtabs(~survived + AgeCategory, data=subset(TitanicSurvival, sex=="female"))

    ##         AgeCategory
    ## survived (0,17] (17,80]
    ##      no      22      74
    ##      yes     50     242

Finally, we can also define subsets in terms of a numerical variable
like age:

    xtabs(~survived + sex, data=subset(TitanicSurvival, age < 18))

    ##         sex
    ## survived female male
    ##      no      22   51
    ##      yes     50   31

    xtabs(~survived + passengerClass, data=subset(TitanicSurvival, age >= 18))

    ##         passengerClass
    ## survived 1st 2nd 3rd
    ##      no  101 142 303
    ##      yes 168  86  92

We do not put 18 in quotation marks, because age is a numerical
variable.

### Mosaic plot

A mosaic plot can help to visualize multiway tables.

    mosaicplot(~ sex + AgeCategory + survived, data=TitanicSurvival)

![](titanic_files/figure-markdown_strict/unnamed-chunk-19-1.png)

The area of each box tells you what fraction of cases fall into the
corresponding cell of the contingency table. From this plot, it's clear
that adult male passengers of the Titanic died in far higher proportions
than any other category of person.
