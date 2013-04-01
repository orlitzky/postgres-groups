#!/bin/bash

source ../die.sh

# The admins and customer-devs can create files in customer-project.

su -c 'touch customer-project/alice' alice
su -c 'touch customer-project/bob' bob
su -c 'touch customer-project/dba1' dba1

# Each user can modify one of the files just created by someone else.
su -c 'touch customer-project/dba1' bob \
    || die "bob can't modify dba1's file."

su -c 'touch customer-project/alice' dba1 \
    || die "dba1 can't modify alice's file."

su -c 'touch customer-project/bob' alice \
    || die "alice can't modify bob's file."

# The anonymous user can read bob's files.
su -c 'cat customer-project/bob' anonymous \
    || die "The anonymous user can't read bob's files."


# The admins' databases are accessible only to themselves.
su -c 'touch dba-project/dba1' dba1
su -c 'touch dba-project/dba1 2>/dev/null' alice \
    && die "alice can modify admin files."
