#This script runs simulations for 2SLS with heteroskedasticity generated IVs
rm(list=ls())

source("ivregh.R")
N=200 #sample size
b0=1 #intercept term in the structural equation
b1=0 #slope parameter for y2 in structural equation
b2=0 #slope parameter for z1 in the structural equation
kz=1 #number if IVs
pi12=1 #coefficient for z1 in the reduced form equation
pi22=0 #coefficient for z2 (IV) in the reduced form equation
trials=10000 #number of trials
betaIV=vector(,trials) #allocating space
betaTIV=vector(,trials) #allocating space

betaOLS=vector(,trials) #allocating space
fstore=vector(,trials) #allocating space
rejectIV=vector(,trials) #allocating space
rejectTIV=vector(,trials) #allocating space
rejectOLS=vector(,trials) #allocating space
rejectSS=vector(,trials) #allocating space

#construction of generated instruments below
for (i in 1:trials){
muz=25 #average value for z1
sigmaz=10 #standard deviation for z1
z1=muz+rnorm(N,0,sigmaz) #exogenous z1
z2=rnorm(N) #potential IV z2
delta0=1 #intercept parameter for heteroskedasticity equation
delta1=3 #slope parameter for heteroskedasticity equation
p=2 #power of the function in heteroskedasticity equation

#calculating expected value for z1^p in the heteroskedasticity equation
integrand <- function(x) {x^p*dnorm(x, mean = muz, sd = sigmaz, log = FALSE)}
Ezp=integrate(integrand, lower = -Inf, upper = Inf)
Ezp=as.numeric(Ezp[1])#expected value for z1^p

v2=vector(,N) #creating space
#loop for construction of conditional variance for v2 as a function of z1
for (j in 1:N){
sigma2=delta0+delta1*z1[j]^p+rnorm(1,0,.25)
v2[j]=rnorm(1,0,sigma2^(1/2))
}

alpha1=20 #parameter for common factor u in epsilon 1 equation
alpha2=20 #parameter for common factor u in epsilon 2 equation

u=rnorm(N,0,1) #generating common factor u
v1=rnorm(N,0,1) #generating v1
eps1=alpha1*u+v1 #generating epsilon 1
eps2=alpha2*u+v2 #generating epsilon 2
#based on parameter values population correlation between eps1 and eps2 below
rho=(alpha1*alpha2)/((alpha2^2+delta0+delta1*Ezp[1])^(1/2)*(alpha1^2+1)^(1/2))
y2=pi12*z1+pi22*z2+eps2 #reduced form equation
y1=b0+b1*y2+b2*z1+eps1 #structural equation
output=lm(y1~y2+z1) #OLS estimation
bols2=output$coef #OLS coefficient
betaOLS[i]=bols2[2] #storing OLS estimate of b1 across trials
out=ivregh(y1,y2,z1,z2) #IV estimation with generated IVs
betaIV[i]=out$B[3,1] #storing IV estimates over trials
betaTIV[i]=out$BIV[3,1] #storing traditional IV estimates
fstore[i]=out$F[1,1] #storing first-stage F-stat for generated IVs
SSpval=out$S[1,2]
tols=coef(summary(output))[, "t value"]
rejectOLS[i]=(abs(tols[2])>1.96) #reject under zero null for OLS
rejectIV[i]=(abs(out$B[3,3])>1.96) #reject under zero null for IV
rejectTIV[i]=(abs(out$BIV[3,3])>1.96) #reject under zero null for TIV
rejectSS[i]=(SSpval<.05)
}

par(mfrow=c(3,1))
hist(betaOLS,main="Distribution of OLS Estimator",xlab="OLS Estimator",ylab="Frequency")
hist(betaIV,main="Distribution of Gen. IV Estimator",xlab="Gen. IV Estimator",ylab="Frequency")
hist(betaTIV,main="Distribution of Trad. IV Estimator",xlab="Trad. IV Estimator",ylab="Frequency")


print("MSE of OLS to Generated IV")
mean((betaOLS)^2)/mean((betaIV)^2)
print("MSE of Standard IV to Generated IV")
mean((betaTIV)^2)/mean((betaIV)^2)
print("Empirical Size Under OLS")
sum(rejectOLS)/trials
print("Empirical Size Under Traditional IV")
sum(rejectTIV)/trials
print("Empirical Size Under Generated IV")
sum(rejectIV)/trials
print("Empirical Size for Sargan-Stat")
sum(rejectSS)/trials






