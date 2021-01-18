setwd("~/GitHub/Carey-ATE-shiny")

library(ATE)
library(rms)
library(prodlim)
library(data.table)
library(tidyverse)
library(riskRegression)


set.seed(10)


#### Survival settings  ####
#### ATE with Cox model ####

## generate data
n <- 100
dtS <- sampleData(n, outcome="survival")
dtS$time <- round(dtS$time,1)
dtS$X1 <- factor(rbinom(n, prob = c(0.3,0.4) , size = 2), labels = paste0("T",0:2))

## estimate the Cox model
fit <- cph(formula = Surv(time,event)~ X1+X2,data=dtS,y=TRUE,x=TRUE)

## compute the ATE at times 5, 6, 7, and 8 using X1 as the treatment variable
## standard error computed using the influence function
## confidence intervals / p-values based on asymptotic results
ateFit1a <- ate(fit, data = dtS, treatment = "X1", times = 5:8)
summary(ateFit1a)
summary(ateFit1a, short = TRUE, type = "meanRisk")
summary(ateFit1a, short = TRUE, type = "diffRisk")
summary(ateFit1a, short = TRUE, type = "ratioRisk")

## Not run: 
## same as before with in addition the confidence bands / adjusted p-values
## (argument band = TRUE)
ateFit1b <- ate(fit, data = dtS, treatment = "X1", times = 5:8,
                band = TRUE)
summary(ateFit1b)

## by default bands/adjuste p-values computed separately for each treatment modality
summary(ateFit1b, band = 1,
        se = FALSE, type = "diffRisk", short = TRUE, quantile = TRUE)
## adjustment over treatment and time using the band argument of confint
summary(ateFit1b, band = 2,
        se = FALSE, type = "diffRisk", short = TRUE, quantile = TRUE)

## confidence intervals / p-values computed using 1000 boostrap samples
## (argument se = TRUE and B = 1000) 
ateFit1c <- ate(fit, data = dtS, treatment = "X1",
                times = 5:8, se = TRUE, B = 50, handler = "mclapply")
## NOTE: for real applications 50 bootstrap samples is not enough 

## same but using 2 cpus for generating and analyzing the boostrap samples
## (parallel computation, argument mc.cores = 2) 
ateFit1d <- ate(fit, data = dtS, treatment = "X1",
                times = 5:8, se = TRUE, B = 50, mc.cores = 2)

## manually defining the cluster to be used
## useful when specific packages need to be loaded in each cluster
fit <- cph(formula = Surv(time,event)~ X1+X2+rcs(X6),data=dtS,y=TRUE,x=TRUE)

cl <- parallel::makeCluster(2)
parallel::clusterEvalQ(cl, library(rms))

ateFit1e <- ate(fit, data = dtS, treatment = "X1",
                times = 5:8, se = TRUE, B = 50,
                handler = "foreach", cl = cl)
