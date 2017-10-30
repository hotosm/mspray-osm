# mspray-osm

Instructions and scripts to download and process OSM files for mSpray. 

### Inputs: 

1. Shapefile with one or more polygon features. Shapefile should include a attribute field for naming output files (i.e ID field).
2. OSM PBF file. Easily downloaded from [HOT Export Tool](https://export.hotosm.org). [Example public export](https://export.hotosm.org/en/v3/exports/29de937e-7f82-41cd-ae69-891e034de5d8) of Eastern Province in Zambia. 

### Requirements: 

  - Python 2.7+
  - [ogr2ogr (GDAL)](http://www.gdal.org/ogr2ogr.html)
  - [OSMConvert](http://wiki.openstreetmap.org/wiki/Osmconvert)

### Run: 

1. Create an export job on the HOT Export Tool. Select and download the `.pbf` file format.
2. Mark AOI and OUTPUT IDs within your shapefile.
3. Run the script: 

  `./scripts/processOSM.sh /path/to/shapefile /path/to/osm.pbf AOI_ID OUTPUT_ID`
