##############################################################################
## Filename:          C:\Autocaster\GH-EDK/drivers/screen_detector_v1_00_a/data/screen_detector_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Mon Sep 02 10:38:39 2013 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "screen_detector" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
