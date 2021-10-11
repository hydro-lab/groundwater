## ARM SGP Data
# Plot solar vs net radiation and observe relationship
# Data Citation/Source: Atmospheric Radiation Measurement (ARM) user facility. 1997, updated hourly. 
# Data Quality Assessment for ARM Radiation Data (QCRAD1LONG). 2014-05-01 to 2019-08-29, Southern Great Plains (SGP) Central Facility, Lamont, OK (C1). Compiled by L. Riihimaki, Y. Shi and D. Zhang. ARM Data Center. Data set accessed 2021-09-13 
# "Data were obtained from the Atmospheric Radiation Measurement (ARM) Program sponsored by the U.S. Department of Energy, Office of Science, Office of Biological and Environmental Research, Climate and Environmental Sciences Division."

library(dplyr)
library(readr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(ncdf4) # see more: https://www.r-bloggers.com/2016/08/a-netcdf-4-in-r-cheatsheet/
library(Hmisc)

files <- list.files(pattern = "sgpqcrad1longC1*", full.names = TRUE, recursive = TRUE, ignore.case=TRUE, include.dirs = TRUE)

for(i in 1:length(files)){
  fn <- files[i]
  data <- nc_open(fn)
  BaseTime <- ncvar_get(data, attributes(data$var)$names[1])
  rsd <- ncvar_get(data, attributes(data$var)$names[6])
  rsu <- ncvar_get(data, attributes(data$var)$names[17])
  rld <- ncvar_get(data, attributes(data$var)$names[20])
  rlu <- ncvar_get(data, attributes(data$var)$names[26])
  radiation <- data.frame(BaseTime,rsd,rsu,rlu,rld)
  nc_close(files[i])
}

# write to a csv file; write_csv(".csv", APPEND = TRUE)
# correlate shortwave radiation to net radiation


netr <- mutate(radiation,net = radiation$rsd + radiation$rld - radiation$rsu - radiation$rlu )
x <- rcorr(radiation$rsd,netr$net, type=c("pearson","spearman"))

