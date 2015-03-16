#!/bin/bash

# *******************************************************************************
# USAGE: mind-tools-install-release-full-linux.sh [manifest_branch_name] [manifest_url]
#
# DETAILS:
# This script will create a workspace and then generate a MIND-Tools release.
# 
# WARNING:
# Parameters are specified by order of importance.
# You *MUST* specify "manifest_branch_name" if "manifest_url" need to be changed.
#
# REQUIREMENTS:
# Need installed and in the path:
# - python 2.6+
# - git 1.7.2+
# - curl or wget download utility
# - gcc
# - maven
# *******************************************************************************

# PRIVATE - WORKSPACE
export release_workspace=mind-tools-release

printf '\n'
printf '===============================================================================\n'
printf '== MIND-Tools Release script: INSTALL RELEASE FULL\n'
printf '===============================================================================\n'
printf '\n'

if [ "$1" == "-h" ]; then
	printf '*******************************************************************************\n'
	printf 'USAGE: %s [manifest_branch_name] [manifest_url]\n' $0
	printf '\n'
	printf 'DETAILS:\n'
	printf 'This script will create a workspace in "%s" and then generate a MIND-Tools release.\n' $release_workspace
	printf '\n'
	printf 'WARNING:\n'
	printf 'Parameters are specified by order of importance.\n'
	printf 'You *MUST* specify "manifest_branch_name" if "manifest_url" need to be changed.\n'
	printf '*******************************************************************************\n'
	printf '\nSee help file of sub-scripts for more details on requirements and parameters.\n\n'

	/bin/bash mind-tools-create-workspace-linux.sh -h
	
	/bin/bash mind-tools-install-release.sh -h
	
	exit 0
fi

printf '*******************************************************************************\n'
printf 'Workspace creation (calling script mind-tools-create-workspace-linux.sh)\n'
printf '\n'

/bin/bash mind-tools-create-workspace-linux.sh $release_workspace $1 $2 || exit 1

printf '\n'
printf '*******************************************************************************\n'
printf 'Maven install build (calling script mind-tools-install-release.sh)\n'
printf '\n'

/bin/bash mind-tools-install-release.sh $release_workspace || exit 1
