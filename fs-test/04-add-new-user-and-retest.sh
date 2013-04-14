#!/bin/bash

source ../die.sh

#
# Now we add another admin. He should be able to access everything
# without having to go back and set permissions manually. Likewise,
# other people should be able to modify his stuff.
#
useradd -G admins,customer-devs dba2

# dba2 is automatically allowed to modify alice's file.
su -c 'touch customer-project/alice' dba2 \
    || die "dba2 can't modify alice's file."

# Now dba2 creates a file in the customer's project.
su -c 'touch customer-project/dba2' dba2

# And alice can modify it.
su -c 'touch customer-project/dba2' alice \
    || die "alice can't modify dba2's file."

# The anonymous user can read dba2's file.
su -c 'cat customer-project/dba2' anonymous \
    || die "anonymous can't read dba2's file."

# dba2 should also be able to modify dba1's files
su -c 'touch dba-project/dba1' dba2 \
    || die "dba2 can't modify dba1's file."
