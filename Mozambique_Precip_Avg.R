library(readr)
library(dplyr)
library(lubridate)
library(hydrostats)

x <- read_csv("MOZ_Precip.csv")

y <- x %>%
  filter(NAME == "XAI XAI, MZ") %>% # NAME == "XAI XAI, MZ" "MAPUTO, MZ"
  select(DATE,PRCP,TAVG) %>%
  mutate(dt=fast_strptime(DATE,'%m/%d/%Y')) %>%
     mutate(hy=hyd.yr(dt, h = "S"))

y$cprcp <- NA
if (is.na(y$PRCP[1])) {
     y$cprcp[1] <- 0
} else {
     y$cprcp[1] <- y$PRCP[1]
}
for (i in 2:nrow(y)) {
     if (y$hy[i]==y$hy[i-1]) {
          if (is.na(y$PRCP[i])) {
               y$cprcp[i] <- y$cprcp[i-1] # will assume no precip if precip=NA
          } else {
               y$cprcp[i] <- y$cprcp[i-1] + y$PRCP[i]
          }
     } else {
          if (is.na(y$PRCP[i])) {
               y$cprcp[i] <- 0
          } else {
               y$cprcp[i] <- y$PRCP[i]
          }
     }
}

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
