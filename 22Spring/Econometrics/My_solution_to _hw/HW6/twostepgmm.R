set.seed(1)
N=1000 #generate sample size
x1=rnorm(N) #generate x1 variable
x2=rnorm(N) #generate x2 variable
u=rnorm(N) #generate error term
y=(1+1*x1)+u #generate population model
X1=cbind(rep(1,N),x1,x2)
Z1=X1 #set IVs equal to x-variables (OLS)
x=cbind(x1,x2)
z1=x
ksi=solve((1/N)*t(Z1)%*%Z1)
o = optim(cbind(0,0,0),fn=gfunction,x=X1,y=y,z1=Z1,ksi=ksi,method="BFGS")
b=o$par
out1=qderivfungmm(y,x,z1,t(b),ksi)
ksi=solve(out1$Lambda)
o = optim(cbind(0,0,0),fn=gfunction,x=X1,y=y,z1=Z1,ksi=ksi,method="BFGS")
b=o$par
out1=qderivfungmm(y,x,z1,t(b),ksi)
Avarhat=out1$Avar
se=diag(Avarhat)^(1/2)
t=b/se