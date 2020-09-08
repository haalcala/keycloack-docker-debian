# Keycloak in Debian container

## Build

  docker build -t haalcala/keycloak-debian:11.0.2 -f Dockerfile .

## Run

  docker run --rm -d --hostname keycloak-debian --name keycloak-debian haalcala/keycloak-debian
