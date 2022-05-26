state_crime = read.csv("/Users/user/Documents/MA Courses/Causal Inference/LottMustard1997-revamp/data/UpdatedStateLevelData-2010.csv")

state_crime = state_crime %>% 
  filter(year>=1977 & year<=1992)

treat_table = state_crime %>% 
  group_by(state) %>% 
  summarize(cnt = sum(shalll)) %>% 
  na.omit()

state_crime = left_join(state_crime, treat_table, by = c("state" = "state")) 

state_crime <- state_crime %>%
  select(cnt, everything())

state_crime <- state_crime %>%
  select(shalll, everything())

state_crime = state_crime %>% 
  mutate(treat_year = ifelse(cnt == 16, 'pre 1977', ifelse(cnt <= 16 & cnt > 0, 1992 - (cnt - 1), 0)))

state_crime <- state_crime %>%
  select(treat_year, everything())

state_crime = state_crime %>% 
  mutate(pre_treat = ifelse(treat_year == 'pre 1977',1,0))

state_crime <- state_crime %>%
  select(pre_treat, everything())

rollout = state_crime %>%
  distinct(state, treat_year) %>% 
  arrange(treat_year)

pre_1977 = rollout %>% 
  filter(treat_year == 'pre 1977')

post_1977 = rollout %>% 
  filter(treat_year != 'pre 1977') %>% 
  filter(treat_year != 0)

rollout_table = rbind(pre_1977, post_1977)

rollout_table
