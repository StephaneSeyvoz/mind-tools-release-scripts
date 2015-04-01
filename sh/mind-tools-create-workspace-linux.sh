#!/bin/bash

# *******************************************************************************
# USAGE: mind-tools-create-workspace-linux.sh [workspace_folder] [manifest_branch_name] [manifest_url]
#
# DETAILS:
# This script generates a full workspace into provided workspace_folder folder.
#
# WARNING:
# Parameters are specified by order of importance.
# You *MUST* specify "workspace_folder" and "manifest_branch_name" if "manifest_url" need to be changed.
#
# REQUIREMENTS:
# Need installed and in the path:
# 	- python 2.7+
# 	- git 1.7.2+
# 	- curl or wget download utility
# *******************************************************************************

# PRIVATE - HTTP PROXY
#export proxy_url=proxyname:port
#export http_proxy=http://$proxy_url
#export https_proxy=https://$proxy_url
# PRIVATE - REPO TOOL
export repo_tool_url=http://commondatastorage.googleapis.com/git-repo-downloads/repo
export repo_tool_dir=repo_tool
# PRIVATE - WORKSPACE
export release_default_workspace=mind-tools-release
# PRIVATE - MANIFEST
export mind_tools_manifest_default_url=https://github.com/StephaneSeyvoz/mind-tools-release-manifest
export mind_tools_manifest_default_branch=master
export local_release_manifest_file=src/assemble/resources/manifest.xml
# PRIVATE - TOOLS MINIMAL VERSION
export python_minimal_version_required=2.7
export git_minimal_version_required=1.7.2

printf '\n'
printf '===============================================================================\n'
printf '== MIND-Tools Release script: CREATE WORKSPACE\n'
printf '===============================================================================\n'
printf '\n'

if [ "$1" == "-h" ]; then
	printf '*******************************************************************************\n'
	printf 'USAGE: %s [workspace_folder] [manifest_branch_name] [manifest_url]\n' $0
	printf '\n'
	printf 'DETAILS:\n'
	printf 'This script generates a full workspace into provided workspace_folder folder.\n'
	printf '\n'
	printf 'DEFAULT PARAMS VALUES:\n'
	printf '	workspace_folder\t= %s/%s\n' $PWD $release_default_workspace
	printf '	manifest_branch_name\t= %s\n' $mind_tools_manifest_default_branch
	printf '	manifest_url\t\t= %s\n' $mind_tools_manifest_default_url
	printf '\n'
	printf 'WARNING:\n'
	printf 'Parameters are specified by order of importance.\n'
	printf 'You *MUST* specify "workspace_folder" and "manifest_branch_name" if "manifest_url" need to be changed.\n'
	printf '\n'
	printf 'REQUIREMENTS:\n'
	printf 'Need installed and in the path:\n'
	printf '	- python %s+\n' $python_minimal_version_required
	printf '	- git %s+\n' $git_minimal_version_required
	printf '	- curl or wget download utility\n'
	printf '*******************************************************************************\n'
	exit 0
fi

printf '*******************************************************************************\n'
printf '[STEP 1] Checking parameter\n'
printf '\n'

if [ -z "$1" ]; then
	printf '\t[INFO] No release workspace folder provided. Using default worskpace "%s".\n' $release_default_workspace
	export release_workspace=$release_default_workspace
	printf 'Press any key to continue...\n' && read
else
	export release_workspace=$1
fi

if [ -z "$2" ]; then
	printf '\t[INFO] No manifest branch name specified. Using default branch "%s".\n' $mind_tools_manifest_default_branch
	export mind_tools_manifest_branch=$mind_tools_manifest_default_branch
	printf 'Press any key to continue...\n' && read
else
	export mind_tools_manifest_branch=$2
fi

if [ -z "$3" ]; then
	printf '\t[INFO] No manifest url specified. Using default url "%s".\n' $mind_tools_manifest_default_url
	export mind_tools_manifest_url=$mind_tools_manifest_default_url
	printf 'Press any key to continue...\n' && read
else
	export mind_tools_manifest_url=$3
fi

printf '\n'
printf '\t[CONFIG] release_workspace = %s\n' $release_workspace
printf '\t[CONFIG] mind_tools_manifest_branch = %s\n' $mind_tools_manifest_branch
printf '\t[CONFIG] mind_tools_manifest_url = %s\n' $mind_tools_manifest_url
printf '\n'

printf '\n'
printf '*******************************************************************************\n'
printf '[STEP 2] Checking environment\n'
printf '\n'
printf '[STEP 2.1] Checking Tools availability into path\n'
printf '\n'

if ! which python > /dev/null 2>&1; then
	printf '[ERROR] PYTHON not found in the path. PYTHON %s+ is needed to download source code. Exiting.\n' $python_minimal_version_required
	exit 1
fi
printf '\t[INFO] PYTHON found\n'

if ! which git > /dev/null 2>&1; then
	printf '[ERROR] GIT not found in the path. GIT %s+ is needed to download source code. Exiting.\n' $git_minimal_version_required
	exit 1
fi
printf '\t[INFO] GIT found\n'

if which curl > /dev/null 2>&1; then
	export curl_available=1
	printf '\t[INFO] CURL found\n'
fi
if which wget > /dev/null 2>&1; then
	export wget_available=1
	printf '\t[INFO] WGET found\n'
fi

if [ ! $curl_available ] && [ ! $wget_available ]; then
	printf '[ERROR] CURL or WGET not found in the path. Needed to download repo tool. Exiting.\n'
	exit 1
fi

printf '\n'
printf '[STEP 2.2] Checking Tools versions\n'
printf '\n'

. util_vercomp.sh

python --version > output.tmp 2>&1
export python_version=$(cat output.tmp | sed 's/Python \([0-9\.]*\)/\1/')
rm -f output.tmp
printf '\t[INFO] PYTHON version %s.\n' $python_version
vercomp "$python_minimal_version_required" "$python_version"
if (($? == 1 )); then
	printf '[ERROR] PYTHON version %s+ is required. Exiting.\n' $python_minimal_version_required
	exit 1
fi

git --version > output.tmp 2>&1
export git_version=$(cat output.tmp | sed 's/git version \(.*\)/\1/')
rm -f output.tmp
printf '\t[INFO] GIT version %s.\n' $git_version
vercomp "$git_minimal_version_required" "$git_version"
if (($? == 1 )); then
	printf '[ERROR] GIT version %s+ is required. Exiting.\n' $git_minimal_version_required
	exit 1
fi

printf '\n'
printf '*******************************************************************************\n'
printf '[STEP 3] Repo tool install\n'
printf '\n'
printf '[STEP 3.1] Downloading repo tool\n'
printf '\n'

rm -rf $repo_tool_dir > /dev/null 2>&1
mkdir $repo_tool_dir
export https_proxy=$proxy_url
if [ $curl_available ]; then
	printf '\t[INFO] Downloading repo tool from "%s" into folder "%s/%s" using curl' $repo_tool_url $PWD $repo_tool_dir
	curl -x $proxy_url --insecure --output $repo_tool_dir/repo $repo_tool_url
fi
if [ ! $curl_available ] && [ $wget_available ]; then
	printf '\t[INFO] Downloading repo tool from "%s" into folder "%s/%s" using wget' $repo_tool_url $PWD $repo_tool_dir
	wget -e https_proxy=$proxy_url --no-check-certificate $repo_tool_url -O $repo_tool_dir/repo
fi
chmod a+x $repo_tool_dir/repo

printf '\n'
printf '[STEP 3.2] Installing repo tool in the path\n'
printf '\n'

export PATH=$PATH:$PWD/$repo_tool_dir

printf '\n'
printf '*******************************************************************************\n'
printf '[STEP 4] Downloading the MIND-Tools source code using repo tool\n'
printf '\n'
printf '[STEP 4.1] Create the release workspace "%s"\n' $release_workspace
printf '\n'

rm -rf $release_workspace > /dev/null 2>&1
mkdir $release_workspace
pushd $release_workspace > /dev/null 2>&1

printf '\n'
printf '[STEP 4.2] Initialize the workspace using manifest file available at\n'
printf '"%s" (branch %s)\n' $mind_tools_manifest_url $mind_tools_manifest_branch
printf '\n'

repo init -u $mind_tools_manifest_url -b $mind_tools_manifest_branch || exit 1

printf '\n'
printf '[STEP 4.3] Synchronize the workspace by downloading source code\n'
printf '\n'

repo sync -c --no-clone-bundle --jobs=4 || exit 1

printf '\n'
printf '[STEP 4.4] Generate release specific manifest file into "%s"\n' $local_release_manifest_file
printf '\n'

repo --no-pager manifest -r -o $local_release_manifest_file || exit 1

popd > /dev/null 2>&1
