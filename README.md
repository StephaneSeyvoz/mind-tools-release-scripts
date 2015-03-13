# mind-tools-release-scripts
Scripts to build a full integrated release of MIND tools - compiler / doc / plugins

## Pre-requisites

### Tools:
* python 2.7+
* git 1.7.2+
* curl or wget download utility

### Proxy configuration:

If behind a proxy, you must set/export the "http_proxy" and "https_proxy" environment variables before running the scripts.

On Linux, this should be done in your command line or in your /home/user_id/.bashrc file, as follows:
* export http_proxy=http://proxyuser:proxypwd@proxy_url_or_ip:proxy_port
* export https_proxy=https://proxyuser:proxypwd@proxy_url_or_ip:proxy_port

See in the sh/mind-tools-create-workspace-linux.sh file for more details.

Your Git and Maven tools should be configured to handle the proxy as well, otherwise "repo" (handling multiple Git repositories) and the build will fail.

For Git,

* Either:
    git config --global http.proxy http://proxyuser:proxypwd@proxy.server.com:8080
    git config --global https.proxy https://proxyuser:proxypwd@proxy.server.com:8080

* Or edit your $(HOME)/.gitconfig file 

    Add [http] and [https] sections with the same keys and values.

See http://stackoverflow.com/questions/783811/getting-git-to-work-with-a-proxy-server for further details

For Maven:
Either edit the conf/settings.xml file of your Maven installation for system setting, or your user $(HOME)/.m2/settings.xml: Search for "proxy" in it, uncomment it and provide your configuration in the according fields.

## Build

Linux users:
* Simply go to the sh folder: "cd sh"
* And run "./mind-tools-install-release-full-linux.sh"

## Linux Details

Use the sh/ scripts, and:

### sh/mind-tools-install-release-full-linux.sh

USAGE: mind-tools-install-release-full-linux.sh [manifest_branch_name] [manifest_url]

Runs both following scripts in a sequence, to create a full build.

### sh/mind-tools-create-workspace-linux.sh

USAGE: mind-tools-create-workspace-linux.sh [workspace_folder] [manifest_branch_name] [manifest_url]

This script generates a full workspace into provided workspace_folder folder.
It checks that all required tools are available, then gets the "repo" tool with curl/wget, uses repo with the https://github.com/MIND-Tools/mind-tools-release-manifest XML configuration that clones all desired Git repositories to the target folder.

### sh/mind-tools-install-release.sh

Runs the Maven build of the full release construction.
See https://github.com/MIND-Tools/mind-tools for more details.

## Windows Details

Use the win32/ scripts - To be delivered.
