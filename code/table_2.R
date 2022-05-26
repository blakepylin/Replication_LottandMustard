# lott = read.csv("/Users/jonathanbowman/Desktop/Repos/Causal/LottMustard1997-Expansion/LottMustard1997-Expansion/data/Lott_Dataset.csv")

# nrc = read.csv("/Users/jonathanbowman/Desktop/Repos/Causal/LottMustard1997-Expansion/LottMustard1997-Expansion/data/NRCData-Corrected.csv")

library(data.table)
library(fixest)
library(caret)
library(tidyverse)
library(ggplot2)
library(glmnet)
library(gbm)
library(ggmap)
library(rpart)
library(rpart.plot)
library(randomForest)
library(rsample)
library(modelr)
library(fastDummies)
library(scales)
library(here)
library(knitr)
library(kableExtra)

# rpcpi: real per capita Personal Income
# rpcim: " " Income Maintenance
# rpcui: " " unemployment insurance

state_crime = read.csv("/Users/jonathanbowman/Desktop/Repos/Causal/LottMustard1997-Expansion/LottMustard1997-Expansion/data/UpdatedStateLevelData-2010.csv")

state_crime = state_crime %>% 
  filter(year>=1977 & year<=1992)

# crimes = c(murder, rape, assult, rob, auto, burg, larc)

# create table 2

short_state_crime = state_crime %>% select(ratrap, rataga, rataut,ratrob, ratbur,  ratlar)

short_state_crime = short_state_crime %>% select(!(rpcpi:density))

long_con = short_state_crime %>% 
  pivot_longer(ratrap:ratlar, "crimes", "number")

long_con = na.omit(long_con)

crime_table = long_con %>% 
  group_by(crimes) %>% 
  summarize(count = sum(value),
            mean = mean(value),
            standard_d = sd(value)) 
  # kbl(
  #             caption = "sample\\_n(10) gives me ten random rows",
  #             format = "latex"
  #           ) 
# %>%
#   kable_styling(latex_options = c("striped", "hold_position"))
