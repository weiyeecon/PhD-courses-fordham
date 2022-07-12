library(tidyverse)
library(stargazer)
library(margins)
######################
### Wei Ye ###########
## Creaded on Feb 13,2022#
## HW2 ###################
hprice <- read_csv("hprice.csv")
head(hprice)
attach(hprice)
nlsout=nls(price~exp(b0+b1*rooms+b2*baths),start = list(b0=10,b1=0.04321,b2=.9))
summary(nlsout)
stargazer(nlsout)

summary(margins(nlsout))
