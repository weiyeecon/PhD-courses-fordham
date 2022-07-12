#function that computes traditional and heteroskedasticiy generated regressors
ivregh<-function(y1,y2,x,z){
yall=as.matrix(cbind(y1,y2,x,z)) #combine all data into a single matrix
newdata=na.omit(yall) #find all nas in the data and omit them
dall=dim(newdata) #calculates the rows and columns of the new data matrix
n=dall[1] #sample size
output=lm(y1~x+y2)
nm=names(output$coefficients) #get variable names
x=as.matrix(x)
y1=as.matrix(y1)
z=as.matrix(z)
y2=as.matrix(y2)
kx=dim(x)
kx=kx[2]#as the first term is 0
kz=dim(z)
kz=kz[2]# same reason with the above
#compute the traditional IV estimates
outputur=lm(y2~x+z)
outputr=lm(y2~x)
uhatur=residuals(outputur)
uhatr=residuals(outputr)
SSRur=sum(uhatur^2)
SSRr=sum(uhatr^2)
F=((SSRr-SSRur)/kz)/(SSRur/(n-(kx+kz)-1)) #first-stage F-stat
FIV=as.matrix(F)
Z=as.matrix(cbind(x,z))
X=as.matrix(cbind(rep(1, n),x,y2))#n is sample size
y2hat=fitted(outputur)
Xhat=as.matrix(cbind(rep(1, n),x,y2hat))
BIV=solve(t(Xhat)%*%Xhat)%*%t(Xhat)%*%y1 #compute IV estimates,transpose
uhat=y1-X%*%BIV #compute residuals
uhat2=uhat^2
ZZ=(Xhat[1,])%*%t(Xhat[1,])
sigma2=sum(uhat^2)/(n)
dxhat=dim(Xhat)
dxhat=dxhat[2]
Omega=matrix(0, nrow = dxhat, ncol = dxhat)#ALL 0 MATRIX,like empty matrix
Xhatt=t(Xhat)
#if (robust==1) {
#for (i in 1:n){
#Omega1=Omega+(Xhatt[,i])%*%t(Xhat[i,])*uhat2[i]
#Omega=Omega1
#}

#VarCov=solve(t(Xhat)%*%Xhat)*sigma2
#VarCovIV=(n/(n-dxhat))*solve(t(Xhat)%*%Xhat)*Omega%*%solve(t(Xhat)%*%Xhat)
#SE=as.matrix(diag(VarCovIV^(1/2)))
#Tstats=BIV/SE
#
#} else {
VarCov=solve(t(Xhat)%*%Xhat)*sigma2
SE=as.matrix(diag(VarCov^(1/2)))
Tstats=BIV/SE

#}


#declare output for traditional IV estimates
BIV<-cbind(BIV,SE,Tstats)
colnames(BIV) <- c("Coefficients","Standard-Errors","T-stats")
colnames(FIV) <- c("First-stage F-stat")
rownames(FIV) <- c("F-stat")
options(scipen=999)
rownames(BIV) <- c(nm)


#generating instruments based on the exogenous x variables
z1  <- NULL;
for (i in 1:kx){
tmp=(x[,i]-mean(x[,i]))*uhatr# 2012 paper
z1=cbind(z1,tmp)
}

#computing IV estimates using both generated instruments z1 and traditional IVs z
kx=dim(x)
kx=kx[2]
kz=dim(z1)
kz=kz[2]
kzz=dim(z)
kzz=kzz[2]
outputur=lm(y2~x+z1+z)
outputr=lm(y2~x)
X1=as.matrix(cbind(rep(1, n),x,y2))
y2hat2=fitted(outputur)
Xhat1=as.matrix(cbind(rep(1, n),x,y2hat2))
B=solve(t(Xhat1)%*%Xhat1)%*%t(Xhat1)%*%y1
uhat=y1-X1%*%B
df=kz+kzz-1
outputs=lm(uhat~x+z1+z)
R=summary(outputs)$r.squared
SS=n*R #compute Sargan statistic of test of IV validity
SSpval=1-pchisq(SS, df, ncp = 0, lower.tail = TRUE, log.p = FALSE) #Sargan p-value

#computing generated IV results below
outputur=lm(y2~x+z1)
outputr=lm(y2~x)
uhatur=residuals(outputur)
uhatr=residuals(outputr)
SSRur=sum(uhatur^2)
SSRr=sum(uhatr^2)
F=((SSRr-SSRur)/kz)/(SSRur/(n-(kx+kz)-1))
F=as.matrix(F)
Z1=as.matrix(cbind(x,z1))
X1=as.matrix(cbind(rep(1, n),x,y2))
kx=dim(X1)
kx=kx[2]
y2hat2=fitted(outputur)
Xhat1=as.matrix(cbind(rep(1, n),x,y2hat2))
B=solve(t(Xhat1)%*%Xhat1)%*%t(Xhat1)%*%y1
uhat=y1-X1%*%B

sigma2=sum(uhat^2)/(n)
VarCov=solve(t(Xhat1)%*%Xhat1)*sigma2
SE=as.matrix(diag(VarCov^(1/2)))
Tstats=B/SE
print("Generated IV Instruments Only")
B<-cbind(B,SE,Tstats)
S=cbind(SS,SSpval)
colnames(S) <- c("Sargan Statistic (Using ALL IVs)","P-val")
rownames(S) <- c("Sargan Statistic")
colnames(B) <- c("Coefficients","Standard-Errors","T-stats")
colnames(F) <- c("First-stage F-stat")
rownames(F) <- c("F-stat")
options(scipen=999)
rownames(B) <- c(nm)
return(list(B=B,F=F,S=S,"Standard IV Results",BIV=BIV,FIV=FIV))
#return(list(uhat=uhat,B=B,F=F))
}