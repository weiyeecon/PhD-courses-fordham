qderivfun2<-function(y,x,thetahat){
  k=dim(as.matrix(x)) #dimension of x-variabls
  p=k[2] #set dimension of theta space
  N=length(y) #sample size
  derivs=vector(,N) #pre-allocate space
  H=matrix(0,p,p) #pre-allocate space for Hessian
  h=.Machine$double.eps^(1/3) #set approximation error
  for (i in 1:p){
    
    for (j in 1:p){
      z=rep(0,p) #create scalar to approximate derivative at each p
      z[j]=h
      theta1=thetahat+z
      theta2=thetahat-z
      qout1=qderivfun(y,x,theta1)
      q1=qout1$derivstore[,i]
      qout2=qderivfun(y,x,theta2)
      q2=qout2$derivstore[,i]
      d=(q1-q2)/(2*h) #central difference formula for derivative
      H[i,j]=sum(d) #store the Hessian matrix
    }
  }
  A0hat=(1/N)*H
  return(list(H=H,A0hat=A0hat))
}