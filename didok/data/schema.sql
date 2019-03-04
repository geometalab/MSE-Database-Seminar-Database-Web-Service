CREATE EXTENSION postgis;
CREATE EXTENSION hstore;
CREATE EXTENSION dblink;

CREATE DATABASE seminar;

CREATE TABLE osm_stops(
  geom geometry(Point,3857),
  name TEXT,
  osm_id BIGINT,
  uic_ref BIGINT REFERENCES didok(uic_ref)
);

CREATE TABLE didok(
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
  way geometry(Point,3857),
  tags hstore
);

CREATE TABLE osm_line(
  osm_id BIGINT,
  name TEXT,
  way geometry(LineString,3857),
  tags hstore
);

CREATE TABLE osm_line(
  osm_id BIGINT,
  name TEXT,
  way geometry(LineString,3857),
  tags hstore
);


CREATE TABLE osm_polygon(
  osm_id BIGINT,
  name TEXT,
  way geometry(Geometry,3857),
  tags hstore
);

