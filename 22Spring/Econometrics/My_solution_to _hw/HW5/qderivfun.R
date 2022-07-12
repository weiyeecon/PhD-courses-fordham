qderivfun<-function(y,x,thetahat){
  N=length(y) #sample size
  k1=dim(as.matrix(x)) #find number of x-variables
  k=k1[2] #add to x column to adjust for vector of ones
  derivstore=matrix(0,N,k)
  h=.Machine$double.eps^(1/3) #set approximation error
  x=as.matrix(x) #declare as matrix
  for (j in 1:k){
    z=rep(0,k)
    z[j]=h
    for (i in 1:N){
      Qph=qfunction(y[i],t(x[i,]),thetahat+z)
      Qmh=qfunction(y[i],t(x[i,]),thetahat-z)
      qderiv=(Qph-Qmh)/(2*h)
      derivstore[i,j]=qderiv
    }
    
  }
  B0hat=(1/N)*(t(derivstore)%*%derivstore) #B0hat from AVAR
  ssum=colSums(derivstore)
  return(list(derivstore=derivstore,ssum=ssum,B0hat=B0hat))
}
