#!/bin/bash

#
# Create the ACLs that make the filesystem tests work.
#

# Admins can do anything.
setfacl -m    group:admins:rwx *-project
setfacl -d -m group:admins:rwx *-project

# CustomerA's developers can access their own projects.
setfacl -m    group:customer-a-devs:rwx customerA-project
setfacl -d -m group:customer-a-devs:rwx customerA-project

# Same for customerB's devs.
setfacl -m    group:customer-b-devs:rwx customerB-project
setfacl -d -m group:customer-b-devs:rwx customerB-project

# The anonymous user can only read things.
setfacl -m    user:anonymous:rx customerA-project
setfacl -d -m user:anonymous:rx customerA-project
setfacl -m    user:anonymous:rx customerB-project
setfacl -d -m user:anonymous:rx customerB-project
