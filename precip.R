library(readr)
library(ggplot2)
library(dplyr)
library(tidyr)

precip <- read_csv("https://duq.box.com/shared/static/5k19ri7z6qq6h02bwpycl60vbk4qz3f9.csv", col_names = TRUE, col_types = "ccnnncncncncnc")
# Additional information on read_csv {readr} is found at: https://readr.tidyverse.org/reference/read_delim.html

Maputo_precip <- filter(precip, NAME == "MAPUTO, MZ")
Map_date <- strsplit(as.character(Maputo_precip$DATE[1], "/"))

# testing random change