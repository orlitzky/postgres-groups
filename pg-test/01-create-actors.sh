#!/bin/bash

source ../default_psql_opts.sh

#
# Create the users/groups needed for the example
#

SQL="
CREATE ROLE admins;
CREATE ROLE customer_devs;

CREATE USER anonymous;
CREATE USER dba1 IN ROLE admins,customer_devs;
CREATE USER alice IN ROLE customer_devs;
CREATE USER bob IN ROLE customer_devs;

CREATE DATABASE customer_project;
CREATE DATABASE dba_project;
"

psql $PSQL_OPTS <<< "${SQL}";
