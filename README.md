# workspace-api

Ruby on Rails REST API for workspace app.

## Technologies

Project is created with:

* ruby version: 2.7.4
* rails version: 6.1.4.1

## Installation and running the app inside docker container

Install docker and docker-compose

```bash
git clone
cd workspace-api
```

### Set parameters:<br />

docker-compose.yml:<br />
POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB<br />
---
config\database.yml:<br />
production: database, username, password (same as in docker-compose.yml)

```bash
docker-compose up -d --build
```