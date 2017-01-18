# A helper function for calculating percent returns from a Yahoo Series

# Source this to the console first, and then it will be available to use

# (Like importing a library)

computereturns = function(series) {

	mycols = grep('Adj.Close', colnames(series))
	myorder = order(rownames(series))
	series = series[myorder,]

	closingprice = series[,mycols]

	N = nrow(closingprice)
	myrownames = rownames(series)[1:(N-1)]

	percentreturn = as.data.frame(closingprice[2:N,]) / as.data.frame(closingprice[1:(N-1),]) - 1

	mynames = strsplit(colnames(percentreturn), '.', fixed=TRUE)

	mynames = lapply(mynames, function(x) return(paste0(x[1], ".PctReturn")))

	colnames(percentreturn) = mynames
	rownames(percentreturn) = myrownames

	na.omit(percentreturn)

}

