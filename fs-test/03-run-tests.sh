#!/bin/bash

# First test: admins and customer-a-devs can create things in
# customerA-project.

su -c 'mkdir customerA-project/adams_dir' adam
su -c 'mkdir customerA-project/alices_dir' alice
su -c 'mkdir customerA-project/dba1s_dir' dba1

# Each user can delete one of the dirs just created by someone else.
su -c 'rm -r customerA-project/dba1s_dir' adam
su -c 'rm -r customerA-project/alices_dir' dba1
su -c 'rm -r customerA-project/adams_dir' alice

# The anonymous user can read adam's files.
su -c 'touch customerA-project/foo' adam
su -c 'cat customerA-project/foo' anonymous
