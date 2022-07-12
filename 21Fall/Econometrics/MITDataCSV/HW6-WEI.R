library(tidyverse)
library(stargazer)
library(AER)
library(plm)
#

#6.1 parta
card <- read_csv('card.csv')
head(card,n=5)
iv1 <- ivreg(lwage~exper+expersq+black+south+smsa+reg661+educ|exper+expersq+
               black+south+smsa66+reg661+reg662+reg663+reg664+reg665+reg666+reg667+
               reg668+nearc2+nearc4,data=card)
summary(iv1)
olseduc <- lm(educ~exper+expersq+black+south+smsa+reg661+nearc2+nearc4,
              data=card)
summary(olseduc)
educhat <- fitted.values(olseduc)
olslwage <- lm(lwage~exper+expersq+black+south+smsa+reg661+educhat,data=card)
summary(olslwage)
stargazer(iv1,olslwage)
stargazer(olseduc)

#6.1 part b
u_hat1 <- resid(iv1)
# Then we regress estimated u1 on all the variables with educ replacing by IVs
lm61b = lm(u_hat1 ~ exper + expersq + black + south + smsa + reg661 + reg662 + reg663 + reg664 + reg665 + reg666 + reg667 + reg668 + smsa66 + nearc2 + nearc4, data=card)

# Obtain R square value
Rsq = summary(lm61b)$r.squared
pchisq(Rsq * nrow(card), df=1, lower.tail=FALSE)






#6.3
# Read the data
NLS80 = read_csv("NLS80.csv")
# Run the reduced forms
lm_rd1 = lm(educ ~ exper + tenure + married + south + urban + black + kww + meduc + feduc + sibs, data=NLS80)
v21_hat = resid(lm_rd1)
length(NLS80$educ)
length(v21_hat)
# Since the lengths of the response variable and the predictor are not the same, there might be NA values in the data
NLS80omit = na.omit(NLS80)
# Run the regression again
lm_rd1 = lm(educ ~ exper + tenure + married + south + urban + black + kww + meduc + feduc + sibs, data=NLS80omit)
v21_hat = resid(lm_rd1)

lm_rd2 = lm(iq ~ exper + tenure + married + south + urban + black + kww + meduc + feduc + sibs, data=NLS80omit)
v22_hat = resid(lm_rd2)

# Run the 2nd stage regression
lm_2s = lm(lwage ~ exper + tenure + married + south + urban + black + educ + iq + v21_hat + v22_hat, data=NLS80omit)
summary(lm_2s )

linearHypothesis(lm_2s , c("v21_hat=0", "v22_hat=0"))




###6.8 
##part a
FERTIL1 = read_csv("FERTIL1.csv")

# Run the OLS
lm68a= lm(kids ~ educ+age+agesq+black+east+northcen+west+farm+othrural+town+smcity+y74+y76+y78+y80+y82+y84, data = FERTIL1)
summary(lm68a)

#partb
lm68b= lm(educ ~ age+agesq+black+east+northcen+west+farm+othrural+town+smcity+y74+y76+y78+y80+y82+y84+meduc+feduc, data = FERTIL1)
summary(lm68b)
stargazer(lm68a,lm68b)

#Test exogeneity.
v2_hat = resid(lm68b)

lm_2nd = lm(kids ~ educ+age+agesq+black+east+northcen+west+farm+othrural+town+smcity+y74+y76+y78+y80+y82+y84+v2_hat, data = FERTIL1)
summary(lm_2nd)

# Generate the estimated educ
educ_hat = fitted.values(lm68b)

# Run the 2nd stage regression
lm_2nd = lm(kids ~ educ_hat+age+agesq+black+east+northcen+west+farm+othrural+town+smcity+y74+y76+y78+y80+y82+y84, data = FERTIL1)
summary(lm_2nd)


##partc
lm_68c1 = lm(kids ~ educ+age+agesq+black+east+northcen+west+farm+othrural+town+smcity+y74+y76+y78+y80+y82+y84+y74educ+y76educ+y78educ+y80educ+y82educ+y84educ, data = FERTIL1)
summary(lm_68c1)

linearHypothesis(lm_68c1, c("y74educ=0", "y76educ=0", "y78educ=0", "y80educ=0", "y82educ=0", "y84educ=0"))

lm_68c2= ivreg(kids ~ age+agesq+black+east+northcen+west+farm+othrural+town+smcity+educ+y74+y76+y78+y80+y82+y84+y74educ+y76educ+y78educ+y80educ+y82educ+y84educ | age+agesq+black+east+northcen+west+farm+othrural+town+smcity+y74+y76+y78+y80+y82+y84+meduc+feduc+y74meduc+y76meduc+y78meduc+y80meduc+y82meduc+y84meduc+y74feduc+y76feduc+y78feduc+y80feduc+y82feduc+y84feduc, data = FERTIL1)
summary(lm_68c2)

linearHypothesis(lm_68c2, c("y74educ=0", "y76educ=0", "y78educ=0", "y80educ=0", "y82educ=0", "y84educ=0"))
