##Created by Wei Ye
##Date: March 14, 2022
#Note: I don't treat $\theta$ as vectors, but as matrix for my own convenience.
nrmethod <- function(y,x,theta){
  epsilon=10^(-10)
  d=matrix(0,nrow=dim(theta)[1],ncol=dim(theta)[2])
  for(i in 1:100){
    out1=qderivfun(y,x,theta[,i])
    ssum=out1$ssum
    out2=qderivfun2(y,x,theta[,i])
    hsum=out2$H
    theta[,i+1]=theta[,i]-solve(hsum)%*% ssum
    d[,i]=abs(theta[,i+1]-theta[,i])
    while (d[,i]>epsilon){
      d[,i]
      if (d[,i]<=epsilon){
        break
      }
    }
  }
}