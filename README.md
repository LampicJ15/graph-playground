# Graph playground

This repository contains various datasets appropriate for graph exploration.
It is meant as a playground for testing Neo4j's query language, graph datascience algorithms and more.

## Setup & exploration

To run Neo4j in docker execute:

```
make run-docker
```

Neo4j then becomes available on http://localhost:7474 with 

username: `neo4j`
password: `test`

Specific datasets are located in the `playground` directory.
To load a specific dataset follow the `README` in their belonging directory.

To stop docker execute:

```
make run-docker
```