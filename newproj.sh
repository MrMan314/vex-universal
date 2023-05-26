#!/bin/bash

# Exit if error
set -e

# Download the Windows installer
if test ! -f ./vexcode-v5text-msi; then
	# Remove any remnants
	rm -rf msisrc
	# Download the file, set user agent because website will think we are sussy otherwise
	wget -U "AMOGUS" "https://link.vex.com/vexcode-v5text-msi"
fi

# Create a work directory if not already done
if test ! -d msisrc; then
	mkdir msisrc
fi

# Go to work directory
cd msisrc

# Check if current directory is empty (if it isn't it probably already got extracted)
if test -z "$(ls -A)"; then
	# Extract installer package
	msiextract ../vexcode-v5text-msi
	# Remove any remnants
	rm -rf exesrc
fi

# Create another directory for extraction of the exe (contains sample projects)
if test ! -d exesrc; then
	mkdir exesrc
fi

# Go to exe extraction directory
cd exesrc

# Check if current directory is empty
if test -z "$(ls -A)"; then
	# Remove exit if error temporarily, unzip will freak out because it is an exe and has extra info
	set +e
	unzip "../Program Files/VEX Robotics/VEXcode Pro V5/VEXcode Pro V5.exe"
	# Set exit if error again
	set -e
fi

# Go to previous directory
cd ../../

# Ask for project name
PROJPATH=`gum input --placeholder=my_project --value=my_project --header="Enter the project name or desired path"`

# Exit if directory exists (don't want to mess anything up)
if test -d $PROJPATH; then
	echo Directory already exists
	exit 1
fi

# Chose starter template
STARTER=`gum choose \`ls -d msisrc/exesrc/build/templates/*/\` --header="Select the starter template"`

# Create project base
cp -r $STARTER/ $PROJPATH/
# Import SDK
cp -r "msisrc/Program Files/VEX Robotics/VEXcode Pro V5/sdk/" $PROJPATH/
# Apply patches to makefile
patch -Np1 $PROJPATH/makefile < makefile.patch
