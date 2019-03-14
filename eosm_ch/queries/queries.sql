-- Queries for database eosm_ch (PostgreSQL). 
-- Source: Samuel and Stefan

--- QUERY 1 - Counting Didok stations matching stations in OSM.
SELECT COUNT(*)
FROM didok_stops
INNER JOIN osm_stops ON didok_stops.uic_ref = osm_stops.uic_ref;
--> 30829, fast


--- QUERY 2 - List first 100 Didok stations matching stations in OSM.
SELECT d.uic_ref,
       d.name,
       ST_AsText(ST_Transform(o.geom,21781),0) AS wkt, -- 0 dec. places
       o.name,
       replace(d.y_koord,',','') AS easting,
       replace(d.x_koord,',','') AS northing
FROM didok_stops d
INNER JOIN osm_stops o ON d.uic_ref = o.uic_ref
ORDER BY d.name
LIMIT 100;
--> ...


--- QUERY 3 - All Didok stations not identifiable by uic_ref in OSM.
SELECT uic_ref, name, x_koord, y_koord
FROM didok_stops
WHERE uic_ref NOT IN (
  SELECT d.uic_ref 
  FROM didok_stops d 
  JOIN osm_stops o ON d.uic_ref = o.uic_ref)
ORDER BY name;
--> 6278 ...


--- QUERY 4 - Stations in Walenstadt by Bounding Box.
SELECT didok_stops.name, ST_AsText(osm_stops.geom) AS geom
FROM didok_stops
INNER JOIN osm_stops ON didok_stops.uic_ref = osm_stops.uic_ref
WHERE ST_Intersects(ST_MakeEnvelope(9.294699,47.110339,9.333789,47.132881, 4326),geom:: GEOMETRY)
ORDER BY 1;
--> 3 rows...


--- QUERY 5 - Stations with name like Walenstadt in Didok.
SELECT didok_stops.name, ST_AsText(osm_stops.geom) AS geom
FROM didok_stops
INNER JOIN osm_stops ON didok_stops.uic_ref = osm_stops.uic_ref
WHERE didok_stops.name LIKE '%Walenstadt%'
ORDER BY 1;
--> 7 rows...


--- QUERY 6 - Stations with name like Walenstadt in Didok and OSM.
SELECT didok_stops.name AS didok_name,
       osm_stops.name AS osm_name,
       ST_AsText(osm_stops.geom) AS geom
FROM didok_stops
INNER JOIN osm_stops ON didok_stops.uic_ref = osm_stops.uic_ref
WHERE didok_stops.name LIKE '%Walenstadt%' 
AND osm_stops.name LIKE '%Walenstadt%'
ORDER BY 1;
--> 7 rows ...


--- QUERY 7 - Stations with name like Walenstadt in Didok and OSM.
SELECT didok_stops.name AS didok_name,
       osm_stops.name AS osm_name,
       ST_AsText(osm_stops.geom) AS geom
FROM didok_stops
INNER JOIN osm_stops ON didok_stops.uic_ref = osm_stops.uic_ref
WHERE didok_stops.name LIKE '%Walenstadt%' 
AND osm_stops.name LIKE '%Walenstadt%'
ORDER BY 1;
--> 7 rows


--- QUERY 8 - Names that are differ from Didok to OSM. 
SELECT didok_stops.name AS didok_name,
       osm_stops.name AS osm_name,
       ST_AsText(osm_stops.geom) AS geom
FROM didok_stops
INNER JOIN osm_stops ON didok_stops.uic_ref = osm_stops.uic_ref
WHERE didok_stops.name != osm_stops.name
ORDER BY 1;
--> 16138 rows ...


--- QUERY 9 - All stations in canton of St.Gallen in Didok.
SELECT didok_stops.name AS didok_name,
       osm_stops.name AS osm_name,
       ST_AsText(osm_stops.geom) AS geom
FROM didok_stops
INNER JOIN osm_stops ON didok_stops.uic_ref = osm_stops.uic_ref
WHERE didok_stops.kt LIKE 'SG'
ORDER BY 1;
--> 1631 rows...


--- QUERY 10 - All stations in canton of St.Gallen in OSM.
SELECT count(*) AS cnt 
FROM
  osm_point, 
  (SELECT geom  
  FROM osm_polygon 
  WHERE osm_id=-1687006) as perimeter -- Canton SG in OSM
WHERE tags->'uic_ref' IS NOT NULL 
AND ST_Within(osm_point.geom, perimeter.geom);
--> 1672 


--- QUERY 11 - All named OSM objects in canton of St.Gallen.
WITH perimeter AS (
  SELECT geom  
  FROM osm_polygon 
  WHERE osm_id=-1687006 -- Canton St- Gallen
)
SELECT sum(cnt)
FROM (
  SELECT count(*) AS cnt 
  FROM osm_point, perimeter
  WHERE name IS NOT NULL 
  AND ST_Within(osm_point.geom, perimeter.geom) 
  UNION ALL
  SELECT count(*)
  FROM osm_line, perimeter 
  WHERE name IS NOT NULL 
  AND ST_Within(osm_line.geom, perimeter.geom) 
  UNION ALL
  SELECT count(*)
  FROM osm_polygon, perimeter 
  WHERE name IS NOT NULL 
  AND ST_Within(osm_polygon.geom, perimeter.geom) 
)
all_counts;
--> 37691; slow!


--- QUERY 12 - Objekte rund 47.22679/8.81652 im Umkreis 15m.
SELECT
  osm_id, 
  name, 
  ST_AsText(geom) AS geom
FROM
  osm_point
WHERE 
  ST_DWithin(ST_GeomFromText('POINT(8.81652 47.22679)',4326), geom, 15)
ORDER BY name;
--> 4280011859|"Jakob"|"POINT(8.81651 47.22679)"
--> 1355269682|"Jakob Hotel am Hauptplatz"|"POINT(8.8165 47.22685)"


-- QUERY 13 - Restaurants 5000m rund ums Zentrum von Rapperswil-Jona
SELECT
  osm_id, 
  name, 
  ST_AsText(osm_point.geom,0) AS geom 
FROM
  osm_point, 
  (SELECT ST_Centroid(geom) AS geom  
  FROM osm_polygon 
  WHERE osm_id=-1683921) as perimeter -- Rapperswil-Jona in OSM
WHERE (tags @> 'amenity=>restaurant'::hstore) 
AND ST_Within(osm_point.geom, ST_Buffer(perimeter.geom,5000))
ORDER BY name;
--> 54...
