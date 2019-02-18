--- QUERY 1 --> 30829
SELECT COUNT(*)
FROM didok
INNER JOIN geometries ON didok.uic_ref = geometries.uic_ref;

--- QUERY 2
SELECT didok.name,
       ST_AsText(geometries.geom) AS location,
       geometries.name,
       didok.x_koord,
       didok.y_koord
FROM didok
INNER JOIN geometries ON didok.uic_ref = geometries.uic_ref
LIMIT 100;


--- QUERY 3 --- Stations in Walenstadt (Bounding Box)
SELECT didok.name,
       ST_AsText(geometries.geom) AS location
FROM didok
INNER JOIN geometries ON didok.uic_ref = geometries.uic_ref
WHERE ST_Intersects(ST_MakeEnvelope(1034818, 5960244, 1040199, 5964068, 3857),geom:: GEOMETRY);

--- QUERY 4 --- Stations with name like Walenstadt in Didok
SELECT didok.name,
       ST_AsText(geometries.geom) AS location
FROM didok
INNER JOIN geometries ON didok.uic_ref = geometries.uic_ref
WHERE didok.name LIKE '%Walenstadt%';


--- QUERY 5 --- Stations with name like Walenstadt in Didok and OSM
SELECT didok.name AS didok_name,
       geometries.name AS osm_name,
       ST_AsText(geometries.geom) AS location
FROM didok
INNER JOIN geometries ON didok.uic_ref = geometries.uic_ref
WHERE didok.name LIKE '%Walenstadt%' AND geometries.name LIKE '%Walenstadt%';


--- QUERY 6 --- Stations with name like Walenstadt in Didok and OSM
SELECT didok.name AS didok_name,
       geometries.name AS osm_name,
       ST_AsText(geometries.geom) AS location
FROM didok
INNER JOIN geometries ON didok.uic_ref = geometries.uic_ref
WHERE didok.name LIKE '%Walenstadt%' AND geometries.name LIKE '%Walenstadt%';


--- QUERY 7 --- Different Names
SELECT didok.name AS didok_name,
       geometries.name AS osm_name,
       ST_AsText(geometries.geom) AS location
FROM didok
INNER JOIN geometries ON didok.uic_ref = geometries.uic_ref
WHERE didok.name != geometries.name;


--- QUERY 8 --- All Stations in ST.Gallen
SELECT didok.name AS didok_name,
       geometries.name AS osm_name,
       ST_AsText(geometries.geom) AS location
FROM didok
INNER JOIN geometries ON didok.uic_ref = geometries.uic_ref
WHERE didok.kt LIKE 'SG';