#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Nov  3 10:18:02 2021

@author: hydroext
"""

import os

proj_dir = os.path.expanduser('/Volumes/hydro3-raid/Sentinel_Imagery/ASFXaiXai')
proj_name = os.path.basename(proj_dir)
hyp3_dir = os.path.join(proj_dir, 'hyp3')
mintpy_dir = os.path.join(proj_dir, 'mintpy')

config_txt = f'''
mintpy.load.processor        = hyp3
##---------interferogram datasets:
mintpy.load.unwFile          = {hyp3_dir}/*/*unw_phase_clip.tif
mintpy.load.corFile          = {hyp3_dir}/*/*corr_clip.tif
##---------geometry datasets:
mintpy.load.demFile          = {hyp3_dir}/*/*dem_clip.tif
mintpy.load.incAngleFile     = {hyp3_dir}/*/*lv_theta_clip.tif
mintpy.load.waterMaskFile    = {hyp3_dir}/*/*water_mask_clip.tif
##---------reference_point
mintpy.reference.minCoherence = 0.7
##---------mask_options
mintpy.networkInversion.maskDataset = coherence
mintpy.networkInversion.maskThreshold = auto
##---------invert_network
mintpy.networkInversion.weightFunc = no
mintpy.networkInversion.minNormVelocity = auto
##---------correct_troposphere
mintpy.troposhpericDelay.method = pyaps
mintpy.troposphericDelay.weatherModel = auto
##---------post_processing
mintpy.save.kmz = auto 
mintpy.plot = auto 

'''

# write to file
config_file = os.path.join(mintpy_dir, f'{proj_name}.txt')
with open(config_file, 'w') as fid:
    fid.write(config_txt)
print('write file:', config_file)
