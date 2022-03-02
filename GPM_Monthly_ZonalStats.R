library(raster)

raster_files <- list.files(path='/Volumes/hydro3-raid/Precipitation/Imerg_Accumulated_Precip/GPM_data/Cropped', pattern='*.tif$', full.names = T) #use pattern = '.tif$' or something else if you have multiple files in this folder

r_name <- list.files(path='/Volumes/hydro3-raid/Precipitation/Imerg_Accumulated_Precip/GPM_data', full.names = F)

rList <- list() # to save raster values
statList <- list() # to save data.frame with statistics

for(i in 1:length(raster_files)){
  PRCP <- raster(raster_files[i])
  rList[[i]] <- values(PRCP) # extract values for each raster
  
  # name
  Name <- r_name[i]
  mx= raster::cellStats(PRCP,'max', na.rm=T)
  mn= raster::cellStats(PRCP, 'min', na.rm=T)
  sum=raster::cellStats(PRCP, 'sum', na.rm=T)
  avg=raster::cellStats(PRCP,'mean',na.rm=T)
  stdev=raster::cellStats(PRCP,'sd',na.rm=T)
  
  statList[[i]] <- data.frame(Name,mx,mn,sum,avg,stdev) # create a data.frame to save statistics
}

df <- do.call(rbind.data.frame,statList) # final data.frame with all statistics

write.csv(df,"/Volumes/hydro3-raid/Precipitation/Imerg_Accumulated_Precip/GPM_data/Cropped/GPM_PRCP_MonthlyAvg.csv", row.names = T)