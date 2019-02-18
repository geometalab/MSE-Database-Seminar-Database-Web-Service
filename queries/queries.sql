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
LIMIT 10;