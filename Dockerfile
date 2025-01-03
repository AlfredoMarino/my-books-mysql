FROM mysql:8

COPY ./scripts/ /docker-entrypoint-initdb.d/