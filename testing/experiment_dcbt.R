setwd("~/GitHub/Carey-ATE-shiny")

library(grf)
library(tidyverse)
library(caret)

# ---- Min Drinking Age Data ----
dat = read_csv("https://raw.githubusercontent.com/mwells21/CareyDataScience/master/econometrics/lecture1/Module1.csv")


# ---- Linear Regression ----
lm = lm(claims ~ dcbt + age + female + salary + exp + score + hq ,data = dat)
summary(lm)



# ---- Casual Forest ----
set.seed(1839)
cases <- sample(seq_len(nrow(dat)), round(nrow(dat) * .6))


# Partition data 
trainIndex = createDataPartition(dat$dcbt, p = .7, list = F, times = 1)

train <- dat[trainIndex, ]
test <- dat[-trainIndex, ]


# K - folds Dist 
folds <- createFolds(trainIndex, 10)
hist(dat$claims[folds[[9]]])
hist(dat$claims)


# Tune Model 
# Find the optimal tuning parameters.
X = model.matrix(~ ., data = train[,c("age","female","salary","exp","score","hq")])
W = as.numeric(train$dcbt)
Y = train$claims
Y.hat <- predict(regression_forest(X, Y))$predictions
W.hat <- predict(regression_forest(X, W))$predictions

# Tuned Parameters
params <- tune_causal_forest(X, Y, W, Y.hat, W.hat)$params



# Train Model 
cf <- causal_forest(
  X = X,
  Y = Y,
  W = W,
  num.trees = 500,
  seed = 1839
  
)


# Tuned Forest 
cf_tuned <- causal_forest(
  X = X,
  Y = Y,
  W = W,
  num.trees = 500,
  seed = 1839,
  Y.hat = Y.hat, 
  W.hat = W.hat, 
  min.node.size = as.numeric(params["min.node.size"]),
  sample.fraction = as.numeric(params["sample.fraction"]),
  mtry = as.numeric(params["mtry"]),
  alpha = as.numeric(params["alpha"]),
  imbalance.penalty = as.numeric(params["imbalance.penalty"])
  
)


# generate predictions
preds <- predict(
  object = cf, 
  newdata = model.matrix(~ ., data = test[,c("age","female","salary","exp","score","hq")]), 
  estimate.variance = TRUE
)
test$preds <- preds$predictions


# Linear Projection 
best_linear_projection(cf,model.matrix(~ ., data = train[,c("age","female","salary","exp","score","hq")]))


average_treatment_effect(cf, target.sample = "all")

average_treatment_effect(cf_tuned, target.sample = "all")





