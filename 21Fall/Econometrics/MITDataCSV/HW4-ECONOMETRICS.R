#This file is for homework 4-Econometrics
###########################################
##All the codes are written by Wei Ye #####
###########################################
library(tidyverse)
library(stargazer)
library(car)# In order to use linearHypothesis function
library(margins)

#Import data from csv file
NLS80 <- read_csv('nls80.csv')
head(NLS80,n=5)

#Question 4.11(a)
with_iq_kww<-lm(lwage~exper+tenure+married+south+urban+black+educ+kww+iq,data=NLS80)
summary(with_iq_kww)
with_iq_only<- lm(lwage~exper+tenure+married+south+urban+black+educ+iq,data=NLS80)
summary(with_iq_only)
stargazer(with_iq_kww,with_iq_only,title = 'Compare Different Proxy of Ability in 4.11')
#Question 4.11 (b)
linearHypothesis(with_iq_kww,c('iq=0','kww=0'),white.adjust = 'hc1')

#Question 4.11 (c)
summary(margins(with_iq_kww,variables = 'black'))

#Question 4.11 (d)
NLS80<- NLS80%>%
  mutate(mean_kww=mean(kww))
NLS80<-NLS80%>%
  mutate(iq_diff=iq-100,
         kww_diff=kww-mean_kww)
with_all_terms_required<- lm(lwage~exper+tenure+married+south+urban+black+educ+kww+iq+educ:iq_diff+educ:kww_diff,data=NLS80)
summary(with_all_terms_required)
stargazer(with_iq_kww,with_iq_only,with_all_terms_required,titile='Regression table for 4.11 (c)')
## 4.11 DONE!






##########4.12 
train<- read_csv('jtrain1.csv')
head(train)
new_var_with_lag <- lm(lscrap~grant+lscrap_1+union,data=train)
summary(new_var_with_lag)
new_var_without_lag<- lm(lscrap~grant+union,data=train)
summary(new_var_without_lag)
stargazer(new_var_with_lag,new_var_without_lag,title="4.12 Regression Results")



###4.13
crime1 <- read_csv('cornwell.csv')
head(crime1,n=5)
crime2 <- crime1%>%
  filter(year==87)
logcrm_87 <- lm(lcrmrte~lprbarr+lprbconv+lprbpris+lavgsen,data=crime2)
summary(logcrm_87)
crime3 <- crime1 %>%
  filter(year==86)
logcrm_joint <- lm(lcrmrte~lprbarr+lprbarr+lprbconv+lprbpris+lavgsen+
                     crime3$lcrmrte,
                   data=crime2)
summary(logcrm_joint)
stargazer(logcrm_87,logcrm_joint,title = "4.13 part (a) and (b) Regression Results")
library(lmtest)
bptest(logcrm_joint)


### 4.14
#part(a)
attend1 <- read_csv('attend.csv')
head(attend1,n=5)
fgrade_1 <- lm(stndfnl~atndrte+frosh+soph,data=attend1)
summary(fgrade_1)
#part(c)
fgrade_2 <- lm(stndfnl~atndrte+frosh+soph+ACT+priGPA,data=attend1)
summary(fgrade_2)
stargazer(fgrade_1,fgrade_2,title="4.14 Regression Results")
#part(e)
attend2 <- attend1%>%
  mutate(priGPAsq=priGPA^2,
         ACTsq=ACT^2)
fgrade_3 <- lm(stndfnl~atndrte+frosh+soph+priGPAsq+ACTsq,data=attend2)
summary(fgrade_3)
stargazer(fgrade_3,title="4.14 Part(e) Regression Results")
#part(f)
attend3 <- attend2%>%
  mutate(atndrtesq=atndrte^2)
fgrade_4 <- lm(stndfnl~atndrte+frosh+soph+priGPAsq+ACTsq+atndrtesq,data=attend3)
summary(fgrade_4)
stargazer(fgrade_4,title = "4.14 part(f) Regression Results")
