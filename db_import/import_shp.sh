#!/bin/bash
set -e

echo "Set password"
export PGPASSWORD=$POSTGRES_PASSWORD

# Wait for PostgreSQL to start
until pg_isready -h atkisdb -p 5432 -U "$POSTGRES_USER"
do
  echo "Waiting for PostgreSQL to start..."
  sleep 2
done

# Import all SHP files
for shp in /shp_data/*.shp
do
  filename=$(basename "$shp")
  tablename="${filename%.*}"

  echo "Importing $filename to table $tablename"

  #shp2pgsql -s 31467 -I "$shp" "$tablename" | psql -h atkisdb -U "$POSTGRES_USER" -d "$POSTGRES_DB"
  # Use sed to replace commas with periods in numeric fields
  shp2pgsql -s 31467 -I "$shp" "$tablename" | \
    # For US data, replace commas with periods in numeric fields
    sed -E 's/([0-9]),([0-9])/\1.\2/g' | \
    # For data quality issues, remove extra dots in numeric fields i.e. "839.0.0" in gew01_f.shp
    sed -E 's/([0-9]+\.[0-9]+)\.([0-9]+)/\1\2/g' | \
    psql -h atkisdb -U "$POSTGRES_USER" -d "$POSTGRES_DB"
  sleep 3
done

echo "All SHP files imported successfully!"

sleep 3

echo "Materialize tables with ehInside/within relations"
echo "Update missing values from 9998/9999 to NULL"
echo "Add tables from OK AAA-Anwendungsschema 7.1.2 (ATKIS-Basis-DLM) - the ATKIS application schema"
psql -h atkisdb -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f addtables.sql