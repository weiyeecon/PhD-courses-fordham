#This file is for my Homework 7
###############
## Wei Ye  ####
##Nov,27,2021##
###############
source("ivregh.R")
library(tidyverse)
library(stargazer)
library(ivreg)
corrupt <- read_csv('corrupt.csv')


### For question b.
head(corrupt,n=5)
growth_1_ols <- lm(AvgGrowth~cored+corjud+GDPPCInit,data=corrupt)#z=GDPPCInit
summary(growth_1_ols)
stargazer(growth_1_ols)

## For question d.
growth_2_iv <- ivreg(AvgGrowth~cored+GDPPCInit|edext+GDPPCInit,data=corrupt)
summary(growth_2_iv)
cored_1st_stage <- lm(cored~edext+GDPPCInit,data=corrupt)
summary(cored_1st_stage)
4.517^2

## For question f.
summary(growth_2_iv,diagonistics=TRUE)

## For question h.
#we use (GDPPCInit-E(GDPPCInit))*u_{i2} as our generated IV
attach(corrupt)
gdp_iv_before <- GDPPCInit-mean(GDPPCInit)
corred_ols <- lm(cored~AvgGrowth+corjud+CPI2010)
u2=residuals(corred_ols)
gdp_iv_after <- gdp_iv_before*u2
corred_ols_first <- lm(cored~corjud+gdp_iv_after+CPI2010)
summary(corred_ols_first)
gdp_new_iv_t_value <- summary(corred_ols_first)$coefficients[3,3]
F_value <- gdp_new_iv_t_value^2
F_value
