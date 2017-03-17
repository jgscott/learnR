---
layout: page
title: Data analysis write-ups
---

## What should a data-analysis write-up look like?

Writing up the results of a data analysis is not a skill that anyone is born with.  It requires practice and, at least in the beginning, a bit of guidance.

### Organization  

When writing your report, organization will set you free.  A good outline is: 1) overview of the problem, 2) your data and modeling approach, 3) the results of your data analysis (plots, numbers, etc), and 4) your substantive conclusions.  

1) Overview  
Describe the problem.  What substantive question are you trying to address?  This needn't be long, but it should be clear.  

2) Data and model  
What data did you use to address the question, and how did you do it?  When describing your approach, be specific.  For example:  
* Don't say, "I ran a regression" when you instead can say, "I fit a linear regression model to predict price that included a house's size and neighborhood as predictors."  
* Justify important features of your modeling approach.  For example: "Neighborhood was included as a categorical predictor in the model because Figure 2 indicated clear differences in price across the neighborhoods."  

Sometimes your Data and Model section will contain plots or tables, and sometimes it won't.  If you feel that a plot helps the reader understand the problem or data set itself---as opposed to your results---then go ahead and include it.  A great example here is Tables 1 and 2 in the [main paper on the PREDIMED study](http://www.nejm.org/doi/pdf/10.1056/NEJMoa1200303).  These tables help the reader understand some important properties of the data and approach, but not the results of the study itself.  

3) Results  
In your results section, include any figures and tables necessary to make your case.  Label them (Figure 1, 2, etc), give them informative captions, and refer to them in the text by their numbered labels where you discuss them.   Typical things to include here may include: pictures of the data; pictures and tables that show the fitted model; tables of model coefficients and summaries.

4) Conclusion  
What did you learn from the analysis?  What is the answer, if any, to the question you set out to address?

### General advice

- Make the sections as short or long as they need to be.  For example, a conclusions section is often pretty short, while a results section is usually a bit longer.   

- It's OK to use the first person to avoid awkward or bizarre sentence constructions, but try to do so sparingly.  

- Do not include computer code unless explicitly called for.  Note: model outputs do not count as computer code.  Outputs should be used as evidence in your results section (ideally formatted in a nice way).  By code, I mean the sequence of commands you used to process the data and produce the outputs.  

- When in doubt, use shorter words and sentences.  

- A very common way for reports to go wrong is when the writer simply narrates the thought process he or she followed: :First I did this, but it didn't work.  Then I did something else, and I found A, B, and C.  I wasn't really sure what to make of B, but C was interesting, so I followed up with D and E.  Then having done this..."  Do not do this.  The desire for specificity is admirable, but the overall effect is one of amateurism.  Follow the recommended outline above.  


### Examples  

[Here's a good example of a write-up](http://jgscott.github.io/teaching/writeups/files/example_writeup1.pdf) for an analysis of a few relatively simple problems.  Because the problems are so straightforward, there's not much of a need for an outline of the kind described above.  Nonetheless, the spirit of these guidelines is clearly in evidence.   Notice the clear exposition, the labeled figures and tables that are referred to in the text, and the careful integration of visual and numerical evidence into the overall argument.  This is one worth emulating.    

