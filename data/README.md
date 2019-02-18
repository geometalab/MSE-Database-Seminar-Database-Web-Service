# Data Preparation
OSM id Switzerland: 51701

### SELECT
```bash
SELECT ST_AsText(way) AS geom, name, osm_id, (tags->'uic_ref') AS uic_ref
FROM osm_poi
WHERE (tags->'uic_ref') IS NOT NULL AND ST_Within(way,
    (SELECT way FROM osm_polygon WHERE osm_id=-51701))
```

### Export
```bash
psql -h sifs-80044 -p 8080 -U readonly -d gis_db -c "\COPY (SELECT way AS geom, name, osm_id, (tags->'uic_ref') AS uic_ref
FROM osm_poi
WHERE (tags->'uic_ref') IS NOT NULL
  AND ST_Within(way,(SELECT way FROM osm_polygon WHERE osm_id=-51701))) TO 'geomexport.csv' CSV HEADER DELIMITER ',';"
```


### Import
```bash
psql -h 172.17.02 -p 5432 -U postgres -d seminar -c "\COPY geometries(geom,name,osm_id,uic_ref) FROM 'geomexport.csv' DELIMITER ',' CSV HEADER;"
psql -h 172.17.02 -p 5432 -U postgres -d seminar -c "\COPY didok(uic_ref, ld, dst_nr, kz, name, laenge, namel, dst_abk, go_nr, go_abk, gde_nr, gemeinde, kt, bp, vp, vg, vd, y_koord, x_koord, hoehe, karte1, karte2) FROM 'didok.csv' DELIMITER ',' CSV HEADER;"
```
Find bad rows: grep -n "Bern Brünnen Westside" geomexport.csv
Delete bad rows: sed -i "24375d" geomexport.csv

### Dump
```bash
docker exec geom-postgis pg_dump -U postgres seminar > seminardb.sql
psql -h 172.17.02 -p 5432 -U postgres -d seminar -d seminar -f seminardb.sql
```


### Docker
```bash
docker run --name geom-postgis -e POSTGRES_PASSWORD=mysecretpassword -d mdillon/postgis:11
docker run -it --rm --link geom-postgis:postgres postgres psql -h postgres -U postgres
docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Name }}' | sed 's/ \// /'
psql -h 172.17.02 -p 5432 -U postgres
```






