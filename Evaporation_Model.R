# Advection-Aridity Model for Evapotranspiration (Brutsaert 1979)
# Data pulled from Medike Weather Station
# August 23rd, 2019 - July 15th, 2021; 15 minute

library(devtools)
install_github("LimpopoLab/hydrostats", force = TRUE)
library(hydrostats)
library(readr)

data <- read_csv('Medike_All.csv')
temp <- data$`degree_C Air Temperature`
radiation <- read_csv('Medike_SolarR.csv')
tempK <- temp +273.15

netr <- radiation$`Net Radiation`
estar <- e_star(temp, unit = 'C')
u <- mean(data$`m/s Wind Speed`, na.rm = TRUE)
e <- (data$`kPa Vapor Pressure`)*1000 #convert from KPa to Pa
tr <- 1 -(373.15/tempK)
delta <- ((373.15*estar)/(tempK^2))*((13.3815 - (3.952*tr) - (1.9335*tr^2)- (0.5196*tr^3)))
gamma <- ((4.9289e-7)*(tempK^2)) + ((3.4717e-4)*tempK) + 0.51443

Evap <- (1.56*(delta/(delta + gamma))*0.8*netr) - ((gamma/(gamma+delta))*(0.35*(1+0.54*u)*(estar - e)))
E <- as.data.frame(Evap)
evaporation <- write.csv(E,"C:/Users/bakar/Documents/Masters Research - GRACE/Data/Radiation/Evaporation.csv")

e_star <- function(temp, unit = "C") {
  if (unit == "C") {
    t <- temp + 273.15 # ensure t for calculation is in Kelvin
  } else if (unit == "K") {
    t <- temp
  } else if (unit == "F") {
    t <- 273.15 + 5*(temp-32)/9
  } else if (unit == "R") {
    temp <- temp - 459.67
    t <- 273.15 + 5*(temp-32)/9
  } else {
    print("Please select a valid unit.")
  }
  a0 <- 6984.505294
  a1 <- -188.9039310
  a2 <- 2.133357675
  a3 <- -1.288580973e-2
  a4 <- 4.393587233e-5
  a5 <- -8.023923082e-8
  a6 <- 6.136820929e-11
  if (exists("t")) {
    e_star <- array(NA, dim = length(t))
    for (i in 1:length(t)) {
      e_star[i] <- (a0 + t[i] *(a1 + t[i] *(a2 + t[i] *(a3 + t[i] *(a4 + t[i] *(a5 + t[i]*a6)))))) * 100
    }
    return(e_star)
  }
}