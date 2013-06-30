#!/bin/bash

source ../default_psql_opts.sh
source ../die.sh

# Ignore expected errors.
exec 2>/dev/null

#
# Now we add another admin. He should be able to access everything
# without having to go back and set permissions manually. Likewise,
# other people should be able to modify his stuff.
#
psql $PSQL_OPTS -c 'CREATE USER dba2 in ROLE admins,customer_devs;'


# dba2 is automatically allowed to modify alice's table.
psql -q -U dba2 -d customer_project -c 'INSERT INTO alice VALUES (2);' \
    || die "dba2 can't modify alice's table."

# Now dba2 creates a file in the customer's project.
psql -q -U dba2 -d customer_project -c 'CREATE TABLE dba2 ( id int );'

# Alice can modify it.
psql -U alice -d customer_project -c 'INSERT INTO dba2 VALUES (2);' \
    || die "alice can't modify dba2's table."

# And the anonymous user can read it.
psql -o /dev/null -q -U anonymous -d customer_project \
    -c 'SELECT * FROM dba2;' \
    || die "The anonymous user can't read dba2's table."

# dba2 should also be able to modify dba1's table.
psql -q -U dba2 -d dba_project -c 'INSERT INTO dba1 VALUES (2);' \
    || die "dba2 can't modify dba1's table."
