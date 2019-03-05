--- QUERY 1 --> 30829
SELECT COUNT(*)
FROM didok
INNER JOIN osm_stops ON didok.uic_ref = osm_stops.uic_ref;

--- QUERY 2
SELECT didok.name,
       ST_AsText(osm_stops.geom) AS location,
       osm_stops.name,
       didok.x_koord,
       didok.y_koord
FROM didok
INNER JOIN osm_stops ON didok.uic_ref = osm_stops.uic_ref
LIMIT 100;


--- QUERY 3 --- Stations in Walenstadt (Bounding Box)
SELECT didok.name,
       ST_AsText(osm_stops.geom) AS location
FROM didok
INNER JOIN osm_stops ON didok.uic_ref = osm_stops.uic_ref
WHERE ST_Intersects(ST_MakeEnvelope(1034818, 5960244, 1040199, 5964068, 3857),geom:: GEOMETRY);

--- QUERY 4 --- Stations with name like Walenstadt in Didok
SELECT didok.name,
       ST_AsText(osm_stops.geom) AS location
FROM didok
INNER JOIN osm_stops ON didok.uic_ref = osm_stops.uic_ref
WHERE didok.name LIKE '%Walenstadt%';


--- QUERY 5 --- Stations with name like Walenstadt in Didok and OSM
SELECT didok.name AS didok_name,
       osm_stops.name AS osm_name,
       ST_AsText(osm_stops.geom) AS location
FROM didok
INNER JOIN osm_stops ON didok.uic_ref = osm_stops.uic_ref
WHERE didok.name LIKE '%Walenstadt%' AND osm_stops.name LIKE '%Walenstadt%';


--- QUERY 6 --- Stations with name like Walenstadt in Didok and OSM
SELECT didok.name AS didok_name,
       osm_stops.name AS osm_name,
       ST_AsText(osm_stops.geom) AS location
FROM didok
INNER JOIN osm_stops ON didok.uic_ref = osm_stops.uic_ref
WHERE didok.name LIKE '%Walenstadt%' AND osm_stops.name LIKE '%Walenstadt%';


--- QUERY 7 --- Different Names
SELECT didok.name AS didok_name,
       osm_stops.name AS osm_name,
       ST_AsText(osm_stops.geom) AS location
FROM didok
INNER JOIN osm_stops ON didok.uic_ref = osm_stops.uic_ref
WHERE didok.name != osm_stops.name;


--- QUERY 8 --- All Stations in ST.Gallen
SELECT didok.name AS didok_name,
       osm_stops.name AS osm_name,
       ST_AsText(osm_stops.geom) AS location
FROM didok
INNER JOIN osm_stops ON didok.uic_ref = osm_stops.uic_ref
WHERE didok.kt LIKE 'SG';