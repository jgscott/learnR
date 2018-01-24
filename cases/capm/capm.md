### Market model  

For this exercise, you'll need to download the marketmodel.csv data set from the class website. Each row is a week of data on the stock market, and each column is an asset:  
- SPY: the S&P 500  
- AAPL: Apple  
- GOOG: Google  
- MRK: Merck  
- JNJ: Johnson and Johnson  
- WMT: Wal Mart  
- TGT: Target  

The individual entries are the weekly returns: that is, the change in that stock's price from the close of one Monday to the close of the next Monday.  These are on a 0-to-1 scale, so that 0.1 is a 10% return, etc.

(A) Regress the returns for each of the 6 stocks individually on the return of S&P 500.  Which stock seems to be the most tightly coupled to the movements of the wider market?  (You decide what "most tightly coupled" means.)  

(B) What do you notice about the intercepts? Are they mostly small, or mostly large? Interpret these intercepts in terms of whether any of the individual stocks appear to be outperforming the market on a systematic basis.  

(C) Does your estimate of the slope for Wal-Mart versus the S&P 500 agree (roughly) with the “beta” reported by [Yahoo Finance](https://finance.yahoo.com/quote/WMT?p=WMT)? If you notice a discrepancy, offer a possible explanation.  

(D) Consider the 6 models you fit in Part (A). Each model leads to a set of residuals for one particular stock regressed against the S&P 500. Which set of residuals has the largest correlation with the Wal Mart residuals -- that is, the residuals from the model having Wal-Mart as the response variable? Why do you think this is so?  

