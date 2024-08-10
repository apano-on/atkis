## ATKIS VKG

This project utilizes Virtual Knowledge Graphs (VKG) to query ATKIS (DLM250) data via SPARQL. The project runs through Docker.

## Dataset
ATKIS Dataset: https://gdz.bkg.bund.de/index.php/default/digitales-landschaftsmodell-1-250-000-ebenen-dlm250-ebenen.html

## Instructions to run
Keep ports `7777` (PostgreSQL) and `8083` (Ontop) free. Modify the ports as needed via `.env` file.

Execute from the command line:
```
docker-compose up
```
Wait for 6-8 minutes for the dataset to get downloaded and all the shapefiles be imported in PostGIS. `shp2pgsql` is used to handle the import.

## Connect to Ontop
Go to http://localhost:8083/ and start running SPARQL queries.

## Optional: Using QGIS to visualize results
It is possible to visualize SPARQL results using QGIS. In order to do
that we use the [SPARQLing Unicorn QGIS plugin](https://plugins.qgis.org/plugins/sparqlunicorn/).

If you already have QGIS installed on your machine, just import the plugin via the zipfile. 
Alternatively, we provdide a simple docker setup below:

1. Depending on your machine, to run QGIS via docker you might first need to run:
``` 
xhost +local:docker
```

2. Then simply start the docker pipeline:
```
docker-compose -f docker-compose.qgis.yml up
```
Once QGIS is up and running, install the SPARQLing Unicorn plugin:
1. Navigate to Plugins > Manage and Install Plugins
2. Install from zip
3. Load SPARQLing Unicorn zip in the /home/qgis folder
4. Install plugin

Now you are ready to run SPARQL queries from QGIS.

### Visualizing ATKIS query results in QGIS
1. In QGIS navigate to Vector > SPARQL Unicorn Wikidata Plugin > Add a GeoJSON layer from a Wikidata
2. Click on "Quick Add RDF Resource"; Set "RDF Resource Name"="Ontop" and write as RDF Resource URL http://host.docker.internal:8083/sparql
(If a different port is used for Ontop modify as needed).
3. Unselect "Detect namespaces" (otherwise the process will take >1hr), click on "Quick Add" and wait ca. 5 minutes
4. Next, go to "Select Endpoint", choose "Ontop [Geosparql Endpoint]" and wait ca. 10 minutes (SPARQLing runs an spo LIMIT 1 query)
5. Finally, try running a query, e.g. 100 nature parks in Germany:
``` 
PREFIX : <http://example.org/ontologies/atkis#>
PREFIX geo: <http://www.opengis.net/ont/geosparql#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?item ?geo WHERE {
  ?item a :Protected .
  OPTIONAL {?item rdfs:label ?name .}

  # Find protected nature parks
  ?item :specificationType [rdfs:label ?landType ] .
  FILTER(LANG(?landType) = "de" && STR(?landType) = "Naturpark")

  ?item geo:hasGeometry/geo:asWKT ?geo .
}
```
and click "Add Layer"
6. Next visualize the results in QGIS
    * Set the project CRS: Go to "Project" > "Properties" > "CRS". Set the project CRS to EPSG:31467 (This is the CRS of your relief layer)
    * Add a background map: Go to "Browser" panel, Expand "XYZ Tiles", Double-click on "OpenStreetMap" (or another suitable background map)
    * Visualize the results by ensuring Layer Order places the GeoJSON layer on top of the background map. 
      * If needed go to View > Panel > Layer Order to adjust the layer order.
      * If needed set new layer CRS to EPSG:31467 (Right-click on the layer > Set Layer CRS)