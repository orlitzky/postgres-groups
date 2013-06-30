#!/bin/bash

source ../die.sh

# Ignore expected errors.
exec 2>/dev/null

# The admins and customer-devs can create files in customer-project.

psql -q -U alice -d customer_project -c 'CREATE TABLE alice ( id int );'
psql -q -U bob -d customer_project -c 'CREATE TABLE bob ( id int );'
psql -q -U dba1 -d customer_project -c 'CREATE TABLE dba1 ( id int );'

# Each user can insert into the tables created by the others.
psql -q -U bob -d customer_project -c 'INSERT INTO dba1 VALUES (1);' \
    || die "bob can't modify dba1's table."

psql -q -U dba1 -d customer_project -c 'INSERT INTO alice VALUES (1);' \
    || die "dba1 can't modify alice's table."

psql -q -U alice -d customer_project -c 'INSERT INTO bob VALUES (1);' \
    || die "alice can't modify bob's table."

# The anonymous user can read bob's table.
psql -o /dev/null -q -U anonymous -d customer_project \
    -c 'SELECT * FROM bob;' \
    || die "The anonymous user can't read bob's table."

# The admins' databases are accessible only to themselves.
psql -q -U dba1 -d dba_project -c 'CREATE TABLE dba1 ( id int );'

psql -q -U alice -d dba_project -c 'INSERT INTO dba1 VALUES (1);' \
    && die "alice can modify dba1's table."

