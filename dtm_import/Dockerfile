FROM ubuntu:latest
RUN apt-get update
# Install postgresql-client for shp2pgsql
RUN apt-get install -y postgis && apt-get install -y postgresql-client
#RUN apt-get install -y wget unzip


# Download the zip file with the ATKIS data and copy to shp_data folder
#RUN wget https://daten.gdz.bkg.bund.de/produkte/dgm/dgm1000/aktuell/dgm1000.utm32s.geotiff.zip
#RUN unzip dgm1000.utm32s.geotiff.zip
RUN mkdir -p geotiff_data
COPY dgm1000_utm32s.tif geotiff_data/dgm1000_utm32s.tif

#RUN cp dgm1000_utm32s.tif geotiff_data/dgm1000_utm32s.tif

# Import shapefiles into PostGIS
COPY import_geotiff.sh .
RUN chmod +x import_geotiff.sh

# Copy SQL script to create tables with ehInside/within relation
#COPY addtables.sql .

# Load data
ENTRYPOINT ["/import_geotiff.sh"]