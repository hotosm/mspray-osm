#!/bin/bash
# -----------------------------
# Download individual OSM files
# based on a bounding box
# -----------------------------

# Takes a text file input:
# aoiName -12.4246,29.2446,-11.1772,29.5734

while IFS='' read -r line || [[ -n "$line" ]]; do
    name=$(echo $line | awk '{print $1}')
    echo $name
    bb=$(echo $line | awk '{print $2}')
    echo $bb
    wget -O ${name}.osm "http://overpass-api.de/api/interpreter?data=(way[building](${bb});>;);out body;"
done < list_of_bboxes.txt

# overpass limits the size and number of requests that can be made
