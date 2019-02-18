# Database as a Web Service
Link to the wiki page: https://wiki.hsr.ch/Datenbanken/wiki.cgi?SeminarDatenbanksystemeFS19

## Data Import
To import the data into PostgreSQL create a database called seminar.

For example, you can connect to your PostgreSQL server as follows and create the database needed.

```bash
psql -h <db_host> -p <port> -U <user>
CREATE DATABASE seminar;
```

After the creation of the database you can import the data.
The file for the import is located into the data folder of this repository.

```bash
psql -h <db_host> -p <port> -U <user> -d seminar -d seminar -f seminardb.sql
```

The error "psql:seminardb.sql:60006: ERROR:  insert or update on table "geometries" violates foreign key constraint "geometries_uic_ref_fkey" can be ignored.





