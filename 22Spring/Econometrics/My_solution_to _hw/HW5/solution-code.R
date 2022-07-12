library(tidyverse)
data=read_csv('apple.csv')
attach(data)
ecobuy=(ecolbs>0)
N=length(ecobuy)
y=ecobuy
X1=cbind(rep(1,660),regprc,ecoprc,age)

o = optim(cbind(0,0,0,0),fn=qfunction,x=X1,y=y,method="BFGS")
b=o$par
x=cbind(regprc,ecoprc,age)
out1=qderivfun(y,x,t(b))
B0=out1$B0hat
out2=qderivfun2(y,x,t(b))
A0=out2$A0hat
var=solve(A0)%*%B0%*%solve(A0)/N
se=diag(var)^(1/2)
t=b/se
probitout <- glm(y~x,family=binomial(link="probit"))
summary(probitout)
Lur=sum(y*pnorm(X1%*%t(b))+(1-y)*(1-y*pnorm(X1%*%t(b))))
X1=cbind(rep(1,660),regprc)
o = optim(cbind(0,0),fn=qfunction,x=X1,y=y,method="BFGS")
b=o$par
Lr=sum(y*pnorm(X1%*%t(b))+(1-y)*(1-y*pnorm(X1%*%t(b))))
LR=2*(Lur-Lr)
pvalue=1-pchisq(LR, 2)