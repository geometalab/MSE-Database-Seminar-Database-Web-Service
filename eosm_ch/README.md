# Data Preparation
OSM id Switzerland: 51701


### SELECT
```sql
SELECT ST_AsText(way) AS geom, name, osm_id, (tags->'uic_ref') AS uic_ref
FROM osm_poi
WHERE (tags->'uic_ref') IS NOT NULL 
AND ST_Within(way, (SELECT way FROM osm_polygon WHERE osm_id=-51701))
```
Note this optimized, faster query:
```sql
WITH ch AS ( 
  SELECT ST_Simplify(way,5) AS way FROM osm_polygon WHERE osm_id=-51701
)
SELECT ST_AsText(way) AS geom, name, osm_id, (tags->'uic_ref') AS uic_ref
FROM osm_poi
WHERE (tags->'uic_ref') IS NOT NULL  
AND ST_Within(way, (SELECT way FROM ch))
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
psql -h 172.17.02 -p 5432 -U postgres -d eosm_ch -c "\COPY geometries(geom,name,osm_id,uic_ref) FROM 'geomexport.csv' DELIMITER ',' CSV HEADER;"
psql -h 172.17.02 -p 5432 -U postgres -d eosm_ch -c "\COPY didok(uic_ref, ld, dst_nr, kz, name, laenge, namel, dst_abk, go_nr, go_abk, gde_nr, gemeinde, kt, bp, vp, vg, vd, y_koord, x_koord, hoehe, karte1, karte2) FROM 'didok.csv' DELIMITER ',' CSV HEADER;"
```
Find bad rows: grep -n "Bern Brünnen Westside" geomexport.csv
Delete bad rows: sed -i "24375d" geomexport.csv


### Dump
```bash
docker exec geom-postgis pg_dump -U postgres eosm_ch > eosm_ch.sql
docker exec geom-postgis pg_dump -U postgres sakila > sakila.sql
psql -h 172.17.02 -p 5432 -U postgres -d eosm_ch -d eosm_ch -f eosm_ch.sql
```


### Docker
```bash
docker run --name geom-postgis -e POSTGRES_PASSWORD=mysecretpassword -d mdillon/postgis:11
docker run -it --rm --link geom-postgis:postgres postgres psql -h postgres -U postgres
docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Name }}' | sed 's/ \// /'
psql -h 172.17.02 -p 5432 -U postgres
```

### Table COPY
```bash
INSERT INTO osm_point select * from dblink('host=152.96.80.44 port=8080 user=*** password=*** dbname=gis_db', 'select osm_id, name, way, tags from osm_point') tt(osm_id bigint, name text, way geometry(Point,3857), tags hstore);
INSERT INTO osm_line select * from dblink('host=152.96.80.44 port=8080 user=*** password=*** dbname=gis_db', 'select osm_id, name, way, tags from osm_line') tt(osm_id bigint, name text, way geometry(LineString,3857), tags hstore);
INSERT INTO osm_polygon select * from dblink('host=152.96.80.44 port=8080 user=*** password=*** dbname=gis_db', 'select osm_id, name, way, tags from osm_polygon') tt(osm_id bigint, name text, way geometry(Geometry,3857), tags hstore);

INSERT INTO osm_point select * from dblink('host=152.96.80.44 port=8080 user=*** password=*** dbname=gis_db', 'select osm_id, name, way, tags from osm_point WHERE ST_Within(way,
    (SELECT way FROM osm_polygon WHERE osm_id=-51701))') tt(osm_id bigint, name text, geom geometry(Point,3857), tags hstore);

INSERT INTO osm_line select * from dblink('host=152.96.80.41 port=8080 user=*** password=*** dbname=gis_db', 'select osm_id, name, way, tags from osm_line WHERE ST_Within(way,
    (SELECT ST_RemoveRepeatedPoints(way, 100.0) FROM osm_polygon WHERE osm_id=-51701))') tt(osm_id bigint, name text, geom geometry(LineString,3857), tags hstore);
```


### Alter SRID
```bash
SELECT UpdateGeometrySRID('osm_point','geom',4326);
SELECT UpdateGeometrySRID('osm_point','geom',3857);
```


### Alter Text (with ,) to Numberic
```bash
ALTER TABLE didok_stops
ALTER COLUMN x_koord TYPE numeric USING translate(x_koord, ',', '.')::numeric;
```


### Geometry to Geography
http://postgis.net/workshops/postgis-intro/geography.html
```bash
ALTER TABLE osm_stops
ALTER COLUMN geom type GEOGRAPHY(POINT)
USING (ST_Transform(geom,4326));

ALTER TABLE osm_point
ALTER COLUMN geom type GEOGRAPHY(POINT)
USING (ST_Transform(geom,4326));
```
