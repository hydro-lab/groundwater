library(readr)
library(stringr)
library(lubridate)
library(ggplot2)
library(doParallel)
registerDoParallel(detectCores())


in2017cells <- read_csv("/Users/davidkahler/Documents/Hydrology_and_WRM/Limpopo_Basin_Study/Land_Movement_Gabi/2017_AllPixelsInRV.dbf.csv", n_max = 73521)
days <- read_csv("/Users/davidkahler/Documents/Hydrology_and_WRM/Limpopo_Basin_Study/Land_Movement_Gabi/2017_AllPixelsInRV.dbf.csv", col_names = FALSE, n_max = 1)
dt <- array(NA, dim = 15)
for (i in 8:22) {
     spl <- strsplit(days[i][[1]], "D")
     spl <- spl[[1]][2]
     dt[i-7] <- as.numeric(ymd(spl))
}

lin <- foreach (i = 1:nrow(in2017cells), .combine = rbind) %dopar% { # parallel
# for (i in 1:nrow(in2017cells)) { # not parallel
     y <- lm(as.numeric(in2017cells[i,8:22])~dt)
     s <- y$coefficients[2] # should be in linear unit per time, days?
     c <- confint(y)
     c1 <- c[2,1]
     c2 <- c[2,2]
     print(c(s, c1, c2))
}
