setwd("~/GitHub/Carey-ATE-shiny")

library(grf)
library(tidyverse)

dat <- read.table("https://raw.githubusercontent.com/markhwhiteii/blog/master/hte_intro/broockman_kalla_replication_data.tab", header = T, sep = "\t", fill = TRUE)%>%
  filter(respondent_t1 == "1" & contacted == "1") %>% 
  transmute(
    treatment = factor(ifelse(treat_ind == "1", "Treatment", "Control")),
    trans_therm_post = as.numeric(therm_trans_t1),
    trans_therm_pre = as.numeric(therm_trans_t0),
    age = vf_age,
    party = factor(vf_party),
    race = factor(vf_racename),
    voted14 = vf_vg_14,
    voted12 = vf_vg_12,
    voted10 = vf_vg_10,
    sdo = as.numeric(sdo_scale),
    canvass_minutes = as.numeric(canvass_minutes)
  ) %>% 
  filter(complete.cases(.))

# make lgl for middle
tiles <- quantile(dat$trans_therm_pre)
lgl <- dat$trans_therm_pre >= tiles[[2]] & dat$trans_therm_pre <= tiles[[4]]
dat$middle <- lgl * 1

set.seed(1839)
cases <- sample(seq_len(nrow(dat)), round(nrow(dat) * .6))
train <- dat[cases, ]
test <- dat[-cases, ]

cf <- causal_forest(
  X = model.matrix(~ ., data = train[, 3:ncol(train)]),
  Y = train$trans_therm_post,
  W = as.numeric(train$treatment) - 1,
  num.trees = 5000,
  seed = 1839
)

# generate predictions
preds <- predict(
  object = cf, 
  newdata = model.matrix(~ ., data = test[, 3:ncol(test)]), 
  estimate.variance = TRUE
)
test$preds <- preds$predictions

cf %>% 
  variable_importance() %>% 
  as.data.frame() %>% 
  mutate(variable = colnames(cf$X.orig)) %>% 
  arrange(desc(V1))

average_treatment_effect(cf, target.sample = "all")


# Compare to Linear Regresion Model 
test1 = lm(trans_therm_post ~ treatment,data = dat)
summary(test1)

test2 = lm(trans_therm_post ~ treatment  + age + party + race + voted14 + voted12 + voted10 + sdo + canvass_minutes + middle ,data = dat)
summary(test2)



