library(tidyr)
library(ggplot2)
library(ncdf4)
library(dplyr)
library(ncdf4.helpers)
library(lubridate)

#Set working directory
setwd("C:/Users/zucco/Desktop/Academics/Duquesne/Zuccolotto_Thesis/GRACE-GLDAS/GRACE/NETCDF")

#Read in NETCDF file JPL GRACE and GRACE-FO Mascon Ocean, Ice, and Hydrology Equivalent Water Height JPL Release 06 Version 02 EarthDataSearch
GRACE <-nc_open('GRCTellus.JPL.200204_202110.GLO.RL06M.MSCNv02CRI.nc')

#Set variables
lon <-ncvar_get(GRACE, "lon")
lat <-ncvar_get(GRACE, "lat")
Days_Since_2002_01_01<- ncvar_get(GRACE,"time")
WET <- ncvar_get(GRACE, "lwe_thickness")
##Generate dates from days since 2002_01_01
D <- as.Date(Days_Since_2002_01_01, origin = '2002-01-01')
Date <- as_date(parse_date_time(D,"ymd"))

#Create new data frame with only WET values from lon: 33.8 (cell index 68), lat -24.8 (cell index 131)
Water_Equiv_Thickness_cm <- WET[68, 131, ]

#Create data frame with columns for time, dates and WET values
data.frame(Days_Since_2002_01_01,Date,Water_Equiv_Thickness_cm) -> WET_XaiXai_TS

#Write CSV with all WET values in the dataset
write.csv(WET_XaiXai_TS,file="XaiXaiGRACEdata.csv",row.names = TRUE)