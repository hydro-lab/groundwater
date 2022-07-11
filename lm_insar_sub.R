library(readr)
library(ggplot2)
library(doParallel)
registerDoParallel(detectCores())


in2017cells <- read_csv("/Users/davidkahler/Documents/Hydrology_and_WRM/Limpopo_Basin_Study/Land_Movement_Gabi/2017_AllPixelsInRV.dbf.csv")
days <- read_csv("/Users/davidkahler/Documents/Hydrology_and_WRM/Limpopo_Basin_Study/Land_Movement_Gabi/2017_AllPixelsInRV.dbf.csv", col_names = FALSE, n_max = 1)
dt <- array(NA, dim = 15)
for (i in 8:22) {
     dt[i-7] <- strsplit(days[i][[1]], "D")
     dt[i-7] <- as.numeric(dt[[i-7]][2])
}

lin <- foreach (i = 1:nrow(in2017cells), .combine = cbind) %dopar% {
     y <- lm(as.numeric(in2017cells[i,8:22])~as.numeric(dt))
     print(y)
}
