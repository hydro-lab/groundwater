# pull sea level data from gridded product
# NASA. (2022). MEaSUREs Gridded Sea Surface Height Anomalies Version 2205 [Data set]. NASA Physical Oceanography Distributed Active Archive Center. https://doi.org/10.5067/SLREF-CDRV3

library(dplyr)
library(readr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(ncdf4) # see more: https://www.r-bloggers.com/2016/08/a-netcdf-4-in-r-cheatsheet/
library(sp)
library(parallel)
library(doParallel)
library(latex2exp)
library(hydrostats) # function is already included in this code

## OBTAIN DATA ##
# [https://sealevel.nasa.gov/data](https://sealevel.nasa.gov/data)  
# Find MEaSUREs:  
# - Select "MEaSUREs" from "Mission" on right  
# - Find "MEaSUREs Gridded Sea Surface Height Anomalies Version 2205"  
# - Download via EarthData  
# - Recommend downloading via shell script  
loc <- "/Volumes/T7/slr/"
files <- list.files(loc, pattern = "ssh*", full.names = TRUE, recursive = FALSE, ignore.case=TRUE, include.dirs = FALSE)

## Open first file
nc <- ncdf4::nc_open(files[1])
# attributes(slr$var)
slrData <- ncvar_get(nc, attributes(nc$var)$names[4])
slrLon <- ncvar_get(nc, attributes(nc$var)$names[1])
slrLat <- ncvar_get(nc, attributes(nc$var)$names[2])

## Find reference pixel
# Durban -29.867, 031.050
# Xai-Xai -25.214, 033.522
# Xai-Xai offshore -25.852, 34.318, out one in both directions: iLat=324, iLon=207
LatSearch <- -25.852
LonSearch <- 034.318

for (i in (1:ncol(slrLat))) {
     if ( (LatSearch >= slrLat[1,i]) & (LatSearch <= slrLat[2,i]) ) {
          print(paste0("Searched for latitude ", LatSearch))
          print(paste0("Found between ", slrLat[1,i], " and ", slrLat[2,i]))
          print(paste0("at index ", i))
          iLat <- i
          break
     }
}
for (i in (1:ncol(slrLon))) {
     if ( (LonSearch >= slrLon[1,i]) & (LonSearch <= slrLon[2,i]) ) {
          print(paste0("Searched for longitude ", LonSearch))
          print(paste0("Found between ", slrLon[1,i], " and ", slrLon[2,i]))
          print(paste0("at index ", i))
          iLon <- i
          break
     }
}
## Check for data, determine alternatives
if (is.na(slrData[iLon,iLat])) {
     print("Element found returns NA.")
} else {
     print("Position appears to have data.")
}
# test neighbors
test <- array(NA, dim = c(3,3))
testLat <- array(NA, dim = 3)
testLon <- testLat
# populate latitude
if (iLat > 1) {
     testLat[3] <- iLat - 1
} else {
     testLat[3] <- ncol(slrLat) # wraps around to other side
}
testLat[2] <- iLat
if (iLat < ncol(slrLat)) {
     testLat[1] <- iLat + 1
} else {
     testLat[1] <- 1
}
# populate longitude
if (iLon > 1) {
     testLon[1] <- iLon - 1
} else {
     testLon[1] <- ncol(slrLon)
}
testLon[2] <- iLon
if (iLon < ncol(slrLon)) {
     testLon[3] <- iLon + 1
} else {
     testLon[3] <- 1
}
for (i in 1:3) {
     for (j in 1:3) {
          test[i,j] <- slrData[testLon[i],testLat[j]]
     }
}
print("Neighbors")
print(test)

registerDoParallel(detectCores())
out <- foreach (i = 1:(length(files)), .combine = 'rbind') %dopar% {
     output <- array(NA, dim = 5)
     
     nc <- ncdf4::nc_open(files[i])
     slrData <- ncvar_get(nc, attributes(nc$var)$names[4])
     slrErr <- ncvar_get(nc, attributes(nc$var)$names[5])
     
     # Parse time
     output[1] <- ymd(strsplit(strsplit(files[i], "_")[[1]][4], "12.nc")[[1]][1])
     
     # Extract data
     # units are meters per user guide from: https://podaac.jpl.nasa.gov/dataset/SEA_SURFACE_HEIGHT_ALT_GRIDS_L4_2SATS_5DAY_6THDEG_V_JPL2205
     
     ## primary pixel
     output[2] <- slrData[iLon,iLat]
     output[3] <- slrErr[iLon,iLat]
     
     ## average neighbors
     test <- array(NA, dim = c(3,3))
     error <- test
     for (i in 1:3) {
          for (j in 1:3) {
               test[i,j] <- slrData[testLon[i],testLat[j]]
               error[i,j] <- slrErr[testLon[i],testLat[j]]
          }
     }
     output[4] <- mean(test, na.rm = TRUE)
     output[5] <- mean(error, na.rm = TRUE)
     
     print(output) # passes to parallel rbind
}

# Label and plot data
out <- data.frame(out) %>%
     rename(dat = X1, slr_1 = X2, error_1 = X3, slr_9 = X4, error_9 = X5) %>%
     mutate(dt=as_date(dat)) %>%
     select(dt,slr_1,error_1,slr_9,error_9)
ggplot(out) +
     geom_point(aes(x=dt, y=slr_1), color = "black") +
     stat_smooth(aes(x=dt, y=slr_1), method = "lm") +
     xlab("Date") +
     ylab("Sea-level Anomaly (m)") +
     theme(panel.background = element_rect(fill = "white", colour = "black")) + 
     theme(aspect.ratio = 1) +
     theme(axis.text = element_text(face = "plain", size = 14)) +
     theme(axis.title = element_text(face = "plain", size = 14))
mod1 <- lm(slr_1~dt, data = out)
summary(mod1)
# Coefficients:
#      Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -1.033e-01  6.372e-03  -16.20   <2e-16 ***
#      dt           9.082e-06  4.489e-07   20.23   <2e-16 ***
#      ---
#      Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.06718 on 2205 degrees of freedom
# Multiple R-squared:  0.1565,	Adjusted R-squared:  0.1562 
# F-statistic: 409.3 on 1 and 2205 DF,  p-value: < 2.2e-16
ggplot(out) +
     geom_point(aes(x=dt, y=slr_9), color = "black") +
     stat_smooth(aes(x=dt, y=slr_9), method = "lm") +
     xlab("Date") +
     ylab("Sea-level Anomaly (m)") +
     theme(panel.background = element_rect(fill = "white", colour = "black")) + 
     theme(aspect.ratio = 1) +
     theme(axis.text = element_text(face = "plain", size = 14)) +
     theme(axis.title = element_text(face = "plain", size = 14))
mod9 <- lm(slr_9~dt, data = out)
summary(mod9)
# Coefficients:
#      Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -1.035e-01  6.186e-03  -16.73   <2e-16 ***
#      dt           9.095e-06  4.358e-07   20.87   <2e-16 ***
#      ---
#      Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 0.06522 on 2205 degrees of freedom
# Multiple R-squared:  0.1649,	Adjusted R-squared:  0.1646 
# F-statistic: 435.5 on 1 and 2205 DF,  p-value: < 2.2e-16
confint(mod9)
#                   2.5 %        97.5 %
#      (Intercept)  -1.156059e-01 -9.134307e-02
#         dt        8.240007e-06  9.949252e-06

write_csv(out, "MEaSUREs_XaiXai.csv")

# NOTE:
# The statistical trend is significant and the two methods are insignificantly different.  Regardless, the trend should be reported as 
# an increase of 9.095e-06 m/d, or

365.25 * mod9$coefficients[2]
# 0.003321813 
8.240007e-06 * 365.25
# 0.003009663
9.949252e-06 * 365.25
# 0.003633964

# 3.3 mm/a (95% CI: 3.0 to 3.6 mm/a)
