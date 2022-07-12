######################
###These are the codes for HW-5
### All the codes are written by Wei Ye
## Date: Oct 18, 2021
install.packages("ivreg")
library(tidyverse)
library(stargazer)
library(ivreg)

#For Question 5.3
bwght<-read_csv('bwght.csv')
head(bwght,head=5)
bwght_ols<- lm(bwghtlbs~male+parity+lfaminc+packs,data=bwght)
summary(bwght_ols)
bwght_2sls<- ivreg(bwghtlbs~male+parity+lfaminc+packs | male+parity+lfaminc+cigprice,data=bwght)
summary(bwght_2sls)
stargazer(bwght_ols,bwght_2sls)
### 5.3 part(d) Reduced form
pack_ols <- lm(packs~male+parity+lfaminc+cigprice,data=bwght)
summary(pack_ols)
stargazer(pack_ols)




####################
###Question 5.7#####
####################
nls80 <- read_csv('nls80.csv')
head(nls80,head=5)
nls2sls1 <- ivreg(lwage~exper+tenure+educ+married+south+urban+black | exper+
                    tenure+married+south+urban+black+iq+meduc+feduc+sibs,
                  data=nls80)
summary(nls2sls1)
stargazer(nls2sls1)

