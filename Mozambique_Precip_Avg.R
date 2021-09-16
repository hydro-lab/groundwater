library(readr)
library(dplyr)
library(lubridate)

x <- read_csv("MOZ_Precip.csv")

y <- x %>%
  filter(NAME == "MAPUTO, MZ") %>% # NAME == "XAI XAI, MZ" "MAPUTO, MZ"
  select(DATE,PRCP,TAVG) %>%
  mutate(dt=fast_strptime(DATE,'%m/%d/%Y'))
z <- y %>% 
  mutate(m=month(dt),y=year(dt)) %>%
  mutate(ym=y*100+m) %>%
  group_by(ym) %>%
  summarize(pm=sum(PRCP, na.rm=TRUE))
m <- z %>%
  mutate(m=ym-100*floor(ym/100)) %>%
  group_by(m) %>%
  summarize(p=mean(pm))
plot(m$m,m$p)
