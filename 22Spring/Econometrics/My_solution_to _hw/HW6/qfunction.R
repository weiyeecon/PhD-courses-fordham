qfunction <- function(y,x,theta){
  N=length(y) #Find sample size
  #note that x should be N*K and theta should N*1
  m=(x %*% theta)#Define the function m(), %*% matrix mulplication, transpose of theta
  Q=(1/N)*sum((y-m)^2)# This is our objective function
  out=Q
}