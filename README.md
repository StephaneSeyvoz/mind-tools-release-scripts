# mind-tools-release-scripts
Scripts to build a full integrated release of MIND tools - compiler / doc / plugins

## Pre-requisites

Tools:
* python 2.7+
* git 1.7.2+
* curl or wget download utility

Proxy configuration:
If needed, you must set/export the "http_proxy" and "https_proxy" environment variables before running the scripts.

Note: Your Git and Maven tools should be configured to handle the proxy as well, otherwise "repo" (handling multiple Git repositories) and the build will fail.

## Build

Linux users: Simply run ./mind-tools-release-full-linux.sh

## Linux Details

Use the sh/ scripts, and:

### sh/mind-tools-release-full-linux.sh

Runs both following scripts in a sequence, to create a full build.

### sh/mind-tools-create-workspace-linux.sh

USAGE: mind-all-in-one-create-workspace-linux.sh [workspace_folder] [manifest_branch_name] [manifest_url]

This script generates a full workspace into provided workspace_folder folder.
It checks that all required tools are available, then gets the "repo" tool with curl/wget, uses repo with the https://github.com/MIND-Tools/mind-tools-release-manifest XML configuration that clones all desired Git repositories to the target folder.

### sh/mind-tools-install-release.sh

Runs the Maven build of the full release construction.
See https://github.com/MIND-Tools/mind-tools for more details.

## Windows Details

Use the win32/ scripts - To be delivered.
