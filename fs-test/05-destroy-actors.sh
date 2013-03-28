#!/bin/bash

#
# Destroy the users/groups created for the test.
#

# Ignore "does not exist" errors.
exec 2>/dev/null

userdel anonymous
userdel dba1
userdel dba2
userdel adam
userdel alice
userdel bob
userdel brittany

groupdel admins | grep -v 'does not exist'
groupdel customer-a-devs | grep -v 'does not exist'
groupdel customer-b-devs | grep -v 'does not exist'

#
# Remove the files/directories created during the test.
#
rm -rf customerA-project
rm -rf customerB-project
rm -rf dba-project
