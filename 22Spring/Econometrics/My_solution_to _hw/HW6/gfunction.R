gfunction<-function(y,x,z1,theta){
m=(x%*%theta) #define the function m()
g=t(z1)%*%(y-m) #construct moment conditions using IVs z1
out=g
}