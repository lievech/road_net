

set -ex



test -f $PREFIX/share/proj/conus
echo -105 40 | proj +proj=utm +zone=13 +ellps=WGS84
echo -117 30 | cs2cs +proj=latlong +datum=NAD27 +to +proj=latlong +datum=NAD83
echo -105 40 | cs2cs +init=epsg:4326 +to +init=epsg:2975
exit 0
