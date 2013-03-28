#!/bin/bash

#
# Now we add another admin. He should be able to access everything
# without having to go back and set permissions manually. Likewise,
# other people should be able to modify his stuff.
#
useradd -G admins,customer-a-devs,customer-b-devs dba2

# Adam creates a directory.
su -c 'mkdir customerA-project/adams_dir' adam

# And dba2 is allowed to remove it.
su -c 'rm -r customerA-project/adams_dir' adam

# Now dba2 creates a dir in customerA's project.
su -c 'mkdir customerA-project/dba2_dir' dba2

# And Alice can delete it.
su -c 'rm -r customerA-project/dba2_dir' alice
