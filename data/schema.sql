CREATE EXTENSION postgis;
CREATE DATABASE seminar;

CREATE TABLE geometries(
  geom geometry(Geometry,3857),
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