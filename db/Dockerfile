FROM postgis/postgis:16-3.4

COPY *.sql /docker-entrypoint-initdb.d/
COPY *.dat /docker-entrypoint-initdb.d/
USER postgres

