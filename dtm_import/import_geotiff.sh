#!/bin/bash
set -e

echo "Set password"
export PGPASSWORD=$POSTGRES_PASSWORD

sleep 3

# Set variables
GEOTIFF_FILE="/geotiff_data/dgm1000_utm32s.tif"
TABLE_NAME="MYTABLE"
SRID="32632"  # UTM Zone 32S
#TODO: Be more deterministic with tile sizes?
TILE_SIZE="128"

sleep 3
echo "Enable PostGIS raster extension if not already enabled"
psql -h atkisdb -U $POSTGRES_USER -d $POSTGRES_DB -c "CREATE EXTENSION IF NOT EXISTS postgis_raster;"
sleep 3
# Convert GeoTIFF to SQL
#raster2pgsql -s $SRID -I -C -M $GEOTIFF_FILE -F -t ${TILE_SIZE}x${TILE_SIZE} public.$TABLE_NAME > raster_import.sql
# Convert raster to SQL and import into PostGIS
raster2pgsql -s $SRID -I -C -M $GEOTIFF_FILE -F -t auto $TABLE_NAME | PGPASSWORD=$POSTGRES_PASSWORD psql -h atkisdb -U $POSTGRES_USER -d $POSTGRES_DB

# Import to PostgreSQL
#PGPASSWORD=$POSTGRES_PASSWORD psql -h atkisdb -U $POSTGRES_USER -d $POSTGRES_DB -f raster_import.sql

# Clean up
#rm raster_import.sql

echo "GeoTIFF import completed."