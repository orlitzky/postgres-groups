#!/bin/bash

source ../default_psql_opts.sh

#
# Are there any Postgres commands that you can insert here to make the
# tests work? Note that this is already completely insane compared to
# the filesystem example.
#

DATABASES="customer_project dba_project"

ADMIN_QUERY="
SELECT usename
FROM (pg_user INNER JOIN pg_group
      ON pg_user.usesysid = any(pg_group.grolist))
WHERE pg_group.groname = 'admins';
"
ADMINS=$(psql $PSQL_OPTS        \
              --no-align        \
              --tuples-only     \
              --dbname postgres \
              <<< "${ADMIN_QUERY}" )

DEV_QUERY="
SELECT usename
FROM (pg_user INNER JOIN pg_group
      ON pg_user.usesysid = any(pg_group.grolist))
WHERE pg_group.groname = 'customer_devs';
"
CUSTOMER_DEVS=$(psql $PSQL_OPTS        \
                     --no-align        \
                     --tuples-only     \
                     --dbname postgres \
                    <<< "${DEV_QUERY}" )

ALL_USERS="${ADMINS} ${CUSTOMER_DEVS}"

for database in $DATABASES; do
    for user in $ALL_USERS; do
	SQL="
        GRANT ALL PRIVILEGES ON SCHEMA public TO admins;

        ALTER DEFAULT PRIVILEGES FOR ROLE \"${user}\"
          GRANT ALL PRIVILEGES ON TABLES TO admins;

        ALTER DEFAULT PRIVILEGES FOR ROLE \"${user}\"
          GRANT ALL PRIVILEGES ON SEQUENCES TO admins;

        ALTER DEFAULT PRIVILEGES FOR ROLE \"${user}\"
          GRANT ALL PRIVILEGES ON FUNCTIONS TO admins;

        ALTER DEFAULT PRIVILEGES FOR ROLE \"${user}\"
          GRANT ALL PRIVILEGES ON TYPES TO admins;
        "
	psql -q -U "${PSQL_USER}" -d "${database}" <<< "${SQL}"
    done
done


for user in $ALL_USERS; do
    SQL="
    GRANT ALL PRIVILEGES ON SCHEMA public TO customer_devs;

    ALTER DEFAULT PRIVILEGES FOR ROLE \"${user}\"
      GRANT ALL PRIVILEGES ON TABLES TO customer_devs;

    ALTER DEFAULT PRIVILEGES FOR ROLE \"${user}\"
      GRANT ALL PRIVILEGES ON SEQUENCES TO customer_devs;

    ALTER DEFAULT PRIVILEGES FOR ROLE \"${user}\"
      GRANT ALL PRIVILEGES ON FUNCTIONS TO customer_devs;

    ALTER DEFAULT PRIVILEGES FOR ROLE \"${user}\"
      GRANT ALL PRIVILEGES ON TYPES TO customer_devs;
    "

    psql -q -U "${PSQL_USER}" -d customer_project <<< "${SQL}"

    SQL="
GRANT USAGE ON SCHEMA public TO anonymous;

ALTER DEFAULT PRIVILEGES FOR ROLE \"${user}\"
  GRANT SELECT ON TABLES TO anonymous;

ALTER DEFAULT PRIVILEGES FOR ROLE \"${user}\"
  GRANT SELECT ON SEQUENCES TO anonymous;
"
    psql -q -U "${PSQL_USER}" -d customer_project <<< "${SQL}"

done

