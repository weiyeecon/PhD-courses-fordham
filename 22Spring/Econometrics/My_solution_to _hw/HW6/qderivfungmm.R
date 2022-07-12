qderivfungmm<-function(y,x,z1,thetahat,ksi){
N=length(y) #sample size
k1=dim(as.matrix(x)) #find number of x-variables
k=k1[2]+1 #add to x column to adjust for vector of ones
z1=as.matrix(z1) #declare IV vector as a matrix
L=dim(z1) #find dimension of IV vector
L=L[2]+1 #add one for addition of a vector of ones
gderivstore=matrix(0,L,k) #create space for derivative matrix
h=.Machine$double.eps^(1/3) #set approximation error
x=as.matrix(x) #declare x-variables as matrix

for (j in 1:k){
z=rep(0,k)
z[j]=h
gderiv=vector(,L)
for (i in 1:N){
Qph=gfunction(y[i],cbind(1,t(x[i,])),cbind(1,t(z1[i,])),thetahat+z)
Qmh=gfunction(y[i],cbind(1,t(x[i,])),cbind(1,t(z1[i,])),thetahat-z)
qderiv=(Qph-Qmh)/(2*h)
derivstore=gderiv+qderiv
gderiv=derivstore
}
gderivstore[,j]=gderiv
}

lambda0=matrix(0,L,L) #create space for lambda
for (i in 1:N){
g=gfunction(y[i],cbind(1,t(x[i,])),cbind(1,t(z1[i,])),thetahat)
lambda=g%*%t(g)+lambda0
lambda0=lambda
}
Z1=cbind(rep(1,N),z1) #add vector of ones to IVs
X1=cbind(rep(1,N),x) #add vector of ones to x-variables
Lambda=(1/N)*lambda0
Ghat=(1/N)*gderivstore
g=gfunction(y,X1,Z1,thetahat)
HStat=t(N^(-1/2)*g)%*%ksi%*%(N^(-1/2)*g) #over-id J-stat
HStatp=1-pchisq(HStat,L-k) #p-value for J-stat
Ahat=t(Ghat)%*%ksi%*%Ghat
Bhat=t(Ghat)%*%ksi%*%Lambda%*%ksi%*%Ghat
Avar=(solve(Ahat)%*%Bhat%*%solve(Ahat))/N #variance-covariance matrix
return(list(Ghat=Ghat,ksi=ksi,Lambda=Lambda,Avar=Avar,HStat=HStat,HStatp=HStatp))

}