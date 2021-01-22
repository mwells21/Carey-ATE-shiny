setwd("~/GitHub/Carey-ATE-shiny")

library(grf)
library(tidyverse)


# ---- Min Drinking Age Data ----
dat = read_csv("https://raw.githubusercontent.com/mwells21/CareyDataScience/master/econometrics/lecture1/Module1.csv")


# ---- Linear Regression ----
lm = lm(claims ~ dcbt + age + female + salary + exp + score + hq ,data = dat)
summary(lm)



# ---- Casual Forest ----
set.seed(1839)
cases <- sample(seq_len(nrow(dat)), round(nrow(dat) * .6))
train <- dat[cases, ]
test <- dat[-cases, ]

cf <- causal_forest(
  X = model.matrix(~ ., data = train[,c("age","female","salary","exp","score","hq")]),
  Y = train$claims,
  W = as.numeric(train$dcbt),
  num.trees = 5000,
  seed = 1839
)


# generate predictions
preds <- predict(
  object = cf, 
  newdata = model.matrix(~ ., data = test[,c("age","female","salary","exp","score","hq")]), 
  estimate.variance = TRUE
)
test$preds <- preds$predictions



average_treatment_effect(cf, target.sample = "all")


