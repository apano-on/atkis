FROM ubuntu:latest
RUN apt-get update
# Install postgresql-client for shp2pgsql
RUN apt-get install -y postgis && apt-get install -y postgresql-client
RUN apt-get install -y wget unzip


# Download the zip file with the ATKIS data and copy to shp_data folder
RUN wget https://daten.gdz.bkg.bund.de/produkte/dlm/dlm250/aktuell/dlm250.gk3.shape.ebenen.zip
RUN unzip dlm250.gk3.shape.ebenen.zip
RUN mkdir -p shp_data
RUN cp -R dlm250.gk3.shape.ebenen/dlm250_ebenen/* shp_data/

# Import shapefiles into PostGIS
COPY import_shp.sh .
RUN chmod +x import_shp.sh

# Copy SQL script to create tables with ehInside/within relation
COPY addtables.sql .

# Load data
ENTRYPOINT ["/import_shp.sh"]