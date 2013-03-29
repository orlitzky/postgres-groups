#!/bin/bash

#
# Destroy the users/groups created for the test.
#

# Ignore "does not exist" errors.
exec 2>/dev/null

userdel anonymous
userdel dba1
userdel dba2
userdel alice
userdel bob

groupdel admins
groupdel customer-devs

#
# Remove the files/directories created during the test.
#
rm -rf customer-project
rm -rf dba-project
