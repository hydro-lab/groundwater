#!/bin/bash

##Script for clipping GPM .tif files (originally for the entire LRB) to the LLRB
import os 
import glob
from osgeo import gdal
import numpy as np

ls = (glob.glob("/Volumes/hydro3-raid/Precipitation/Imerg_Accumulated_Precip/*/*.tif"))

for fn in ls:
    base = os.path.splitext(fn)[0]
    out = base + "_AOI.tif"
    shpin = "/Volumes/hydro3-raid/Precipitation/Imerg_Accumulated_Precip/LLRB_shpfile/LowerLimpopoSF_Dissolved.shp"
    gdal.Warp(out,fn, cutlineDSName = shpin, cropToCutline = True, dstNodata = np.nan)

