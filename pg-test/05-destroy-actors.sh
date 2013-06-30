#!/bin/bash

source ../default_psql_opts.sh

# Ignore "does not exist" errors.
exec 2>/dev/null

#
# Destroy the users/groups created for the test.
#

DROP_OPTS="-U ${PSQL_USER} --if-exists"

dropuser $DROP_OPTS anonymous
dropuser $DROP_OPTS dba1
dropuser $DROP_OPTS dba2
dropuser $DROP_OPTS alice
dropuser $DROP_OPTS bob

dropuser $DROP_OPTS admins
dropuser $DROP_OPTS customer_devs

#
# Remove the databases and tables created during the test.
#
dropdb $DROP_OPTS customer_project
dropdb $DROP_OPTS dba_project
