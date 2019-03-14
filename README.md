# Database as a Web Service
Link to the wiki page: https://wiki.hsr.ch/Datenbanken/wiki.cgi?SeminarDatenbanksystemeFS19

## Queries
The queries used for the benchmark are listed in the queries.sql in the queries folder.

To get information about the execution time use the \timing command.
Further, the execution plan can be seen if you use the keyword EXPLAIN before a query.

## Data Import
To import the data into PostgreSQL create a database called eosm_ch.

For example, you can connect to your PostgreSQL server as follows and create the database needed.

```bash
psql -h <db_host> -p <port> -U <user>
CREATE DATABASE eosm_ch;
CREATE DATABASE sakila;
```


After the creation of the databases you can import the data.
The database dumps can be downloaded from:
  * eosm_ch: https://drive.switch.ch/index.php/s/GmghfzyjLm3BwQP
  * sakila: https://drive.switch.ch/index.php/s/LMnvH1fJlJvygHG

To import the data into PostgreSQL use the following commands.
```bash
psql -h <db_host> -p <port> -U <user> -d eosm_ch -f eosm_ch.sql
psql -h <db_host> -p <port> -U <user> -d sakila -f sakila.sql
```






