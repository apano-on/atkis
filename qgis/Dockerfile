FROM qgis/qgis:3.38.1

USER root

# Update package lists and install required packages
RUN apt-get update && apt-get install -y \
    zip \
    python3-shapely \
    python3-rdflib \
    python3-sparqlwrapper \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the plugin zip file
COPY sparqlunicorn-0.17.zip /tmp/
COPY sparqlunicorn-0.17.zip /home/qgis/.
# Extract the plugin
RUN mkdir -p /home/qgis/.local/share/QGIS/QGIS3/profiles/default/python/plugins/sparqlunicorn && \
    unzip /tmp/sparqlunicorn-0.17.zip -d /home/qgis/.local/share/QGIS/QGIS3/profiles/default/python/plugins/sparqlunicorn

# Set the working directory
WORKDIR /home/qgis