#!/bin/bash

##Script for clipping to a smaller sub area Xai-Xai _clip_rp.tif files
import glob
from osgeo import gdal
import numpy as np

ls = (glob.glob("/Volumes/hydro3-raid/TorminMineCollapse/hyp3/*/*_clip_rp.tif"))

for fn in ls:
    split = fn.split(".")
    out = split[0]+"_clip2.tif"
    shpin = "/Volumes/hydro3-raid/Sentinel_Imagery/ASFXaiXai/sample.shp"
    gdal.Warp(out,fn, cutlineDSName = shpin, cropToCutline = True, dstNodata = np.nan)


