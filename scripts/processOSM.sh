#!/bin/bash

# Simple script to create .osm files based on areas of interest from a shapefile. 
# OSM data is clipped to the area of interest polygon. 
# Assumes input AOI shapefile only contains polygons
# Assumes you have downloaded OSM data. See getOSM.sh for downloading via Overpass.

# Start with AOI extent and corresponding data from a shapefile
# Adapted from https://github.com/clhenrick/shell_scripts/blob/master/get-extent.sh
SHPFILE=$1
OSM=$2
# field in and out are attributes for naming temp and output files
FIELDIN=$3
FIELDOUT=$4

BASE=`basename $SHPFILE .shp`
EXTENT=`ogrinfo -so $SHPFILE $BASE | grep Extent | sed 's/Extent: //g' | \
   sed 's/(//g' | sed 's/)//g' | sed 's/ - /, /g'`
EXTENT=`echo $EXTENT | awk -F ',' '{print $2 " " $1 " " $4 " " $3}'`
echo $EXTENT

FEATURES=`ogrinfo -so $SHPFILE $BASE | grep Feature`
FEATURES=`echo $FEATURES | awk '{print $3}'`
echo $FEATURES

# TODO: Run getOSM.sh based on extent
# Alternative: Use HOT Export tool to generate .pbf file

# convert input shapefiles to POLY type
# creates a .poly file for each feature within shapefile
# pass shapefile field name as -f
python scripts/ogr2poly.py -f $3 $1
# script only saves files in current directory

# loop through each AOI feature and clip the OSM file
for i in $(eval echo {0..$FEATURES})
do
   # get feature attribute data for file IDs
   getID=`ogrinfo -geom=NO -where FID=$i $SHPFILE $BASE | grep $FIELDIN`
   getOUTPUTID=`ogrinfo -geom=NO -where FID=$i $SHPFILE $BASE | grep $FIELDOUT`
   sprayID=`echo $getID | awk '{print $7'}`
   outputID=`echo $getOUTPUTID | awk '{print $7'}`
   # concatenate to get name of poly file needed
   polyFILE="${BASE}_${sprayID}"

   # uses osmconvert to clip based on .poly border
   # --complete-ways flag keeps polygons that cross the border
   ~/osmconvert $2 -B=$polyFILE.poly --complete-ways -o=output/$outputID.osm

   # clean up
   rm $polyFILE.poly

done
