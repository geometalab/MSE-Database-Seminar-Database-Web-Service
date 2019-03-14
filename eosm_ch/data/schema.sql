CREATE EXTENSION postgis;
CREATE EXTENSION hstore;
CREATE EXTENSION dblink;

CREATE DATABASE eosm_ch;

CREATE TABLE osm_stops(
  geom geometry(Point, 4326),
  name TEXT,
  osm_id BIGINT,
  uic_ref BIGINT REFERENCES didok(uic_ref)
);

CREATE TABLE didok_stops(
  uic_ref BIGINT PRIMARY KEY,
  ld INT,
  dst_nr INT,
  kz INT,
  name TEXT,
  laenge INT,
  namel TEXT,
  dst_abk TEXT,
  go_nr INT,
  go_abk TEXT,
  gde_nr INT,
  gemeinde TEXT,
  kt TEXT,
  bp TEXT,
  vp TEXT,
  vg TEXT,
  vd TEXT,
  y_koord TEXT,
  x_koord TEXT,
  hoehe REAL,
  karte1 TEXT,
  karte2 TEXT
);



CREATE TABLE osm_point(
  osm_id BIGINT,
  name TEXT,
  geom geography(Point, 4326),
  tags hstore
);

CREATE TABLE osm_line(
  osm_id BIGINT,
  name TEXT,
  geom geography(LineString, 4326),
  tags hstore
);

CREATE TABLE osm_polygon(
  osm_id BIGINT,
  name TEXT,
  geom geography(Geometry, 4326),
  tags hstore
);


CREATE INDEX osm_polygon_gist_idx ON osm_polygon USING gist (geom);
CREATE INDEX osm_point_gist_idx ON osm_point USING gist (geom);
CREATE INDEX osm_line_gist_idx ON osm_line USING gist (geom);

CREATE INDEX osm_polygon_gin_idx ON osm_polygon USING gin (tags);
CREATE INDEX osm_line_gin_idx ON osm_line USING gin (tags);
CREATE INDEX osm_point_gin_idx ON osm_point USING gin (tags);

CREATE INDEX osm_polygon_name_idx ON osm_polygon USING btree (name);
CREATE INDEX osm_line_name_idx ON osm_line USING btree (name);
CREATE INDEX osm_point_name_idx ON osm_point USING btree (name);

