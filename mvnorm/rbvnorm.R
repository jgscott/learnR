rbvnorm = function(n, mu1, mu2, sigma1, sigma2, rho) {
	require(mvtnorm)
	
	sig = c(sigma1, sigma2)
	mu = c(mu1, mu2)
	Sigma = matrix(c(1, rho, rho, 1), nrow=2)
	Sigma = diag(sig) %*% Sigma %*% diag(sig)
	x = rmvnorm(n, mean=mu, sigma=Sigma)
	if(n == 1) return(drop(x))
	else return(x)
}
