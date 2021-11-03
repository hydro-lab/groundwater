# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import os
import re
import glob
import zipfile
import numpy as np
from pathlib import Path
from osgeo import gdal
from mintpy import view, tsview


fnames = glob.glob(os.path.join('/Volumes/hydro3-raid/Sentinel_Imagery/ASFXaiXai/interferograms', '*/*.tif'))

# determine the smallest area covered by all input files
corners = [gdal.Info(f, format='json')['cornerCoordinates'] for f in fnames]
ulx = max(corner['upperLeft'][0] for corner in corners)
uly = min(corner['upperLeft'][1] for corner in corners)
lrx = min(corner['lowerRight'][0] for corner in corners)
lry = max(corner['lowerRight'][1] for corner in corners)

# subset all input files to these common coordinates
for fname in fnames:
    fname_out = fname.replace('.tif', '_clip.tif')
    gdal.Translate(destName=fname_out, srcDS=fname, projWin=[ulx, uly, lrx, lry])
