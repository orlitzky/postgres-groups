#!/bin/bash

# You can override these if you like.

if [[ -z "${PSQL_USER}" ]]; then
    PSQL_USER="postgres"
fi

if [[ -z "${PSQL_OPTS}" ]]; then
    PSQL_OPTS="-U ${PSQL_USER} -d postgres --quiet"
fi
