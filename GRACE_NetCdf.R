# GRACE Data in netcdf format
# release version 06 v4
# Data extraction and use for Phalaborwa, Soutpansberg Mountains, and Ramotswa aquifer within the LRB
# resolution for these datasets: 1 degree by 1 degree

library(dplyr)
library(readr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(ncdf4) #https://www.rdocumentation.org/packages/ncdf4/versions/1.10/topics/ncdf4

setwd("~/Masters Research - GRACE/Code/GRACE_NetCdf") # make sure data files are located in working directory

data_file <- nc_open("GRCTellus.JPL.200204_202011.GLO.RL06M.MSCNv02CRI.nc") 
wet <- data_file$var$lwe_thickness # water equivalent thickness data frame
longitude <- data_file$dim$lon # longitude 
latitude <- data_file$dim$lat # latitude 
time <- data_file$dim$time # time


