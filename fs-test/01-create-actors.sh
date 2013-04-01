#!/bin/bash

#
# Create the users/groups needed for the example
#

groupadd admins
groupadd customer-devs

useradd anonymous
useradd -M -G admins,customer-devs dba1
# dba2 omitted on purpose for now
useradd -M -G customer-devs alice
useradd -M -G customer-devs bob

#
# Create the three directories that we will use.
#

mkdir customer-project
mkdir dba-project

# Disallow access to everything.
chmod 700 *-project
