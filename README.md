## ATKIS VKG

This project utilizes Virtual Knowledge Graphs (VKG) to query ATKIS (DLM250) data via SPARQL. The project runs through Docker.

## Dataset
ATKIS Dataset: https://gdz.bkg.bund.de/index.php/default/digitales-landschaftsmodell-1-250-000-ebenen-dlm250-ebenen.html

## Instructions to run
Keep ports `7777` (PostgreSQL) and `8083` (Ontop free). Modify the ports as needed via `.env` file.

Execute from the command line:
```
docker-compose up
```
Wait for 6-8 minutes for the dataset to get downloaded and all the shapefiles be imported in PostGIS. `shp2pgsql` is used to handle the import.

## Connect to Ontop
Go to http://localhost:8083/ and start running SPARQL queries.
