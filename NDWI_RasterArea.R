# Limpopo Resilience Lab
# Sophia Bakar
# Remote Sensing Image Analysis with GDAL (Part 2)
# Measure area of water based on NDWI values within pre-programmed areas

#This work was supported by the United States Agency for International 
# Development, Southern Africa Regional Mission, Fixed Amount Award 
# 72067419FA00001. This work reflects the work of the authors and does not 
# necessarily reflect the views of USAID or the United States Government.  
# Further information is available at: 
# www.duq.edu/limpopo 
# https://github.com/LimpopoLab 

library(rgdal) # must change to GDAL and PROJ: sf/stars/terra, by 2023
library(PROJ)
library(raster)
library(rgeos)
library(XML)
library(methods)
library(sp)
library(parallel)
library(MASS)
library(doParallel)
library(foreach)
library(stringr)
library(dplyr)
library(lubridate)
library(readr)
library(ggplot2)

im <- list.files(path = ".",
                 pattern = "harmonized_clip.tif$", 
                 full.names = TRUE, 
                 recursive = TRUE, 
                 ignore.case=TRUE, 
                 include.dirs = TRUE)
di <- array(NA, dim = length(im))
for (i in 1:length(im)) {
  a <- str_split(im[i],"/")
  b <- str_split(a[[1]][length(a[[1]])],"_")
  c <- as.character(b[[1]][1])
  d <- as.character(b[[1]][2])
  f <- paste0(c,"T",d)
  di[i] <- ymd_hms(f)
}

# Metadata List
md <- list.files("./", 
                 pattern = "metadata_clip.xml$", 
                 full.names = TRUE, 
                 recursive = TRUE, 
                 ignore.case=TRUE, 
                 include.dirs = TRUE)
dm <- array(NA, dim = length(md))
for (i in 1:length(md)) {
  a <- strsplit(md[i],"/")
  b <- strsplit(a[[1]][length(a[[1]])],"_")
  c <- as.character(b[[1]][1])
  d <- as.character(b[[1]][2])
  f <- paste0(c,"T",d)
  dm[i] <- ymd_hms(f)
}

rm(a,b,c,d,f)
id <- array(NA, dim = length(im))  # will match metadata filenames to image filenames and dates
for (i in 1:length(im)) {
  for (j in 1:length(md)) {
    if (di[i]==dm[j]) { # if image date matches metadata date,
      id[i] <- md[j] # store metadata filename matched to image filename and date
    }
  }
}
imagebank <- data.frame(di,im,id)
rm(di,dm,im,md,id,i,j)
imagebank <- imagebank %>% 
  rename(dt=di,md=id) %>% 
  filter(is.na(md)==FALSE) # will contain imagebank data frame with date (dt), image (im), and metadata (md)

output <- array(NA, dim = 5) # output array - will be filled in if data are valid
output[1] <- date(as_datetime(imagebank$dt[q]))
  
  #Import raw Planet metadata to get the reflectance coefficients
  fn <- imagebank$md[q]
  fl <- xmlParse(fn)
  rc <- setNames(xmlToDataFrame(node=getNodeSet(fl, "//ps:EarthObservation/gml:resultOf/ps:EarthObservationResult/ps:bandSpecificMetadata/ps:reflectanceCoefficient")),"reflectanceCoefficient")
  dm <- as.matrix(rc)
  # 1 Red
  # 2 Green
  # 3 Blue
  # 4 Near infrared
  rc2 <- as.numeric(dm[2]) # Green
  rc4 <- as.numeric(dm[4]) # NIR
  #rc <- c(1,1,1,1);
  # Import raster image, crops to chosen extent
  fn <- imagebank$im[q]
  pic <- stack(fn)
  
  # set extent from QGIS analysis:
  # extent format (xmin,xmax,ymin,ymax)
  ## Sand River
  e <- as(extent(  759337.75181152, 769953.81802531, 7456555.52600303, 7465089.435583732), 'SpatialPolygons')
  crs(e) <- "+proj=utm +zone=35 +datum=WGS84" # may need negative y values
  test <- as(extent(pic), 'SpatialPolygons') # Extent of image
  crs(test) <- "+proj=utm +zone=35 +datum=WGS84"
  if (gOverlaps(test,e)) { # returns TRUE if no point in spgeom2 (e, needed) is outside spgeom1 (test, image extent) # used to be (gWithin(e, test, byid = FALSE))
    r <- crop(pic, e)
    rm(pic) # remove rest of image from RAM
    rbrick <- brick(r)
    # calculate NDWI using the green (band 2) and nir (band 4) bands
    ndwi <- ((rc2*r[[2]]) - (rc4*r[[4]])) / ((rc2*r[[2]]) + (rc4*r[[4]]))
    # plot(ndwi) # for viewing during development
    
    # To export cropped NDWI as a new file and create filename root
    p <- strsplit(imagebank$im[q], "_3B_AnalyticMS.tif")
    r <- strsplit(p[[1]], "/")
    lr <- tolower(r[[1]])
    len <- length(lr)
    root <- lr[[len]]
    rm(p,r,lr,len)
    writeRaster(x = ndwi, ## this does not need to be done, just a nice record.
                filename= paste(root, "cndwi.tif", sep="."),
                format = "GTiff", # save as a tif, save as a FLOAT if not default, not integer
                overwrite = TRUE)  # OPTIONAL - be careful. This will OVERWRITE previous files.
    
    output[2] <- root #for output file: root name of image
    
    h = hist(ndwi, # built-in histogram function.  To find values only.  Plotting is at the end of this loop.
             breaks=seq(-1,1,by=0.01),
             plot=FALSE) 
    bins <- h$mids # positions    number
    v <- h$counts # counts        integer
    
    # Allocate arrays used in analysis
    avg <- array(0, dim = c(200,10))
    peaks <- array(0, dim = c(200,10))
    nop <- array(0, dim = c(1,10))
    for (w in 1:10){
      # filter values (v=h$counts) with the averaging window size 2*w+1
      for (k in (w+1):(200-w)){
        avg[k,w] <- ((sum(v[(k-w):(k+w)]))/((2*w)+1))
      }
      # identify and number peaks
      cnt <- 0
      for (j in (w+1):(200-w)){
        if ((avg[j-1,w])<(avg[j,w])){
          if ((avg[j+1,w])<(avg[j,w])){
            cnt <- (cnt+1)
            peaks[j,w] <- cnt
            nop[1,w] <- cnt
          }
        }
      }
    }
    
    # set error values for the result vectors in case neither two nor three peaks are found:
    threepeak <- -1 # revised error values so the histogram visualization is acceptable; however, after debugging, should go back to -9999
    twopeak <- -1
    
    for (w in 1:10){
      # testing in three peaks
      # due to the order of the w variable, only the 'smoothest' result will be kept
      if ((nop[w])==3){
        # finds the second and third peak
        for (j in 1:200){
          if ((peaks[j,w])==2){
            sec <- j # stores the index of the second peak
          }
          if ((peaks[j,w])==3){
            thr <- j # stores the index of the third peak
          }
        }
        # finds minimum between second and third peak
        m <- max(v) # create variable for minimum, initially set higher than any value
        for (j in (sec):(thr)){
          if ((avg[j,w])<m){
            goal <- j
            m <- avg[j,w]
          }
        }
        threepeak <- (bins[(goal)])
      }
      # test in case exactly three peaks were not found
      if ((nop[w])==2){
        # find the position of the first and second (the only) peaks
        for (j in 1:200){
          if ((peaks[j,w])==1){
            fst <- j # stores the index of the second peak
          }
          if ((peaks[j,w])==2){
            sec <- j # stores the index of the third peak
          }
        }
        # finds minimum between first and second peak
        m <- max(v) # create variable for minimum, initially set higher than any value
        for (j in (fst):(sec)){
          if ((avg[j,w])<m){
            goal <- j
            m <- avg[j,w]
          }
        }
        twopeak <- (bins[(goal)])
      }
    }
    
    # Used in issue #1: Recheck histogram values.  Will comment out after diagnostics
    ndwi_values <- data.frame(ndwi@data@values)
    ndwi_values <- rename(ndwi_values, data=ndwi.data.values)
    
    output[3] <-threepeak #for output file: value for the edge of water (3 peak)
    output[4] <-twopeak #for output file: value for the edge of water (2 peak)
    
   
    # Testing three-peak and two-peak water threshold
    # Three-peak is theoretically superior; however, is not always found or there are problems (e.g., =-1) 
    # when it is found.  Test to determine if three-peak threshold is acceptable, otherwise, use two-peak.
    if ((threepeak > -0.65) & (threepeak < 0.4)) {
      ndwi_threshold <- threepeak
    } else {
      ndwi_threshold <- twopeak # consider QC on two-peaks and a default value with QC flag
    }
    output[5] <- ndwi_threshold
    
  print(output)
}
  no_of_pixels <- sum(ndwi[] >= ndwi_threshold, na.rm = TRUE)