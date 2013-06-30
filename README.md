== Overview ==

We have a postgres server for a shared hosting environment, or an
organization with semi-autonomous business units. For the rest of the
discussion, we'll use the shared hosting scenario to simplify things.

The primary security concern is that hosting customers should not be
able to see or modify each other's data. This is non-negotiable.

Of secondary importance is that each customer should be able to have
one or more groups, consisting of its employees and (potentially) our
employees who are able to modify everything in that customers
databases. These databases will eventually be used for something, so
let's additionally require that there will be a read-only user
assigned to each database.

Finally, our tertiary concern is that of convenience and
maintainability. The addition of a new database or user should be
accomplished in constant time. In other words, if there are 100
databases and 100 users already, adding another of each should be just
as fast as it was when there was 1 database and 1 user.

I believe these constraints can be demonstrated with only two groups:
the admins (us), and customer's developers. If I've made a mistake, it
will have to be amended with an additional customer (and group).

== Running the Tests ==

These two tests will create system and postgres users on your
machine. They are designed to run as root, with local trust
authentication to a Postgres instance on localhost.

They should clean up after themselves, and I don't think they'll
damage anything, but you'd be nuts to run the scripts without reading
what they do first.

== Groups ==

We will use a few groups to illustrate the requirements.

  * admins

    These guys can modify anything on the server, but the objects
    they create should not necessarily be shared to others.

  * customer-devs

    All employees of our customer, as well as the server admins (the
    DBAs). They should be able to access anything in their own
    databases.

== Users ==

The following users will be used to illustrate the examples.

  * dba1 (admins, customer-devs)

    The first system administrator. He can do whatever he wants on the
    server, but if he creates an object in one of the customer's
    databases, it should be visible to and writable by their group.

  * dba2 (admins, customer-devs)

    Same as dba1.

  * anonymous

    The website user that will be used to read (only) data from the
    customer's databases. In reality, this would be several different
    users, but that would only unnecessarily complicate things.

  * alice (customer-devs)

    An employee of our customer. Everything she creates in one of the
    customer's databases should be writable by bob and vice-versa.

  * bob (customer-devs)

    Another customer employee. Everything he creates in one of their
    databases should be writable by alice and vice-versa.

== Filesystem Examples ==

=== Windows ===

In Windows, to accomplish everything above, you only need to create
those three groups. When you create a new directory for the customer,
you,

  1. Grant read/write permissions to the customer-devs group.
  2. Grant read-only permissions to the anonymous user.
  3. Replace all entries on child objects with the default (in case
     the directory was non-empty).

=== Unix ===

With Linux, it's a little more work to meet the full requirements. The
setgid strategy will fall apart if you have more than one group with
different requirements. But we can use POSIX ACLs to achieve the same
thing. When you create a new directory for the customer,

  1. Grant read/write permissions to the customer-devs group:

     setfacl -m group:customer-devs:rwx <dir>

  2. Grant read-only permissions to the anonymous user:

     setfacl -m user:anonymous:rx <dir>

  3. Set customer-devs defaults for newly-created files:

     setfacl -d -m group:customer-devs:rwx <dir>

  4. Set anonymous defaults for newly-created-files:

     setfacl -d -m user:anonymous:rx <dir>

If the directory is non-empty here, find/xargs can be used.

== Database Examples ==

=== Microsoft SQL Server ===

This sort of arrangement can be achieved easily in MSSQL, although
there are three different ways to do it.

If you're using Active Directory authentication, you can simply grant
the permissions to an Active Directory group. So if you have AD groups
"admins" and "customer-devs", you can right click on a database and
grant those groups permission to whatever you want.

If you're using SQL logins, in MSSQL 2012 and later you can create new
roles at the server level. Then it's no more difficult than with AD
logins: right click on the database, hit properties, and grant
permissions to the (server-level) role.

=== Postgres ===

Postgres has no (obvious?) way to achieve this. The closest I was able
to come can be found in the pg-tests/02-create-permissions.sh file. It
is not pretty; and doesn't fully work besides. When a new user is
created in 04-add-new-user-and-retest.sh, some manual work is required
to grant him the correct permissions.

If there are 100 databases on the server already, that could be a lot
of error-prone work.