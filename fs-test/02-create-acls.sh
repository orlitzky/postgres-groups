#!/bin/bash

#
# Create the ACLs that make the filesystem tests work.
#

# Admins can do anything.
setfacl    -m group:admins:rwx *-project
setfacl -d -m group:admins:rwx *-project

# The customer's developers can access their own projects.
setfacl    -m group:customer-devs:rwx customer-project
setfacl -d -m group:customer-devs:rwx customer-project

# The anonymous user can only read things.
setfacl    -m user:anonymous:rx customer-project
setfacl -d -m user:anonymous:rx customer-project
