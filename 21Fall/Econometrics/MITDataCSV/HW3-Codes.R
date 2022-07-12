library(tidyverse)
library(stargazer)
library(margins)
#Question1-4.1(d)
wage_1<- read_csv('nls80.csv')
head(wage_1,n=5)
lwage_reg<-lm(lwage~married+educ+(exper+tenure+south+urban+black),data=wage_1)
summary(lwage_reg)
stargazer(lwage_reg)
#For estimating the margin effect of educ with 4, need to dig out.
summary(margins(lwage_reg,variables='educ'))




#####