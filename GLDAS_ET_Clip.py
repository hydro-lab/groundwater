#!/bin/bash

##Script for clipping GLDAS evapotranspiration .tif files from Giovanni (originally for the entire LRB) to the portion of basin delineated from Chokwe to Beitbridge and Kruger
import os 
import glob
from osgeo import gdal
import numpy as np

ls = (glob.glob("/Volumes/hydro3-raid/Evapotranspiration/GLDAS_ET/*.tif"))

for fn in ls:
    base = os.path.splitext(fn)[0]
    out = base + "_clip.tif"
    shpin = "/Volumes/hydro3-raid/GIS/chokwe_erase_beitbridge_kruger/chokwe_erase_beitbridge_kruger.shp"
    gdal.Warp(out,fn, cutlineDSName = shpin, cropToCutline = True, dstNodata = np.nan)


