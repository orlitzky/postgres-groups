#!/bin/bash

#
# Create the users/groups needed for the example
#

groupadd admins
groupadd customer-a-devs
groupadd customer-b-devs

useradd anonymous
useradd -M -G admins,customer-a-devs,customer-b-devs dba1
# dba2 omitted on purpose for now
useradd -M -G customer-a-devs adam
useradd -M -G customer-a-devs alice
useradd -M -G customer-b-devs bob
useradd -M -G customer-b-devs brittany

#
# Create the three directories that we will use.
#

mkdir customerA-project
mkdir customerB-project
mkdir dba-project

# Disallow access to everything.
chmod 700 *-project
