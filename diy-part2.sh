#!/bin/bash

# Actions-OpenWrt: runs after feeds are installed

# Keep Moby from copying host executables on GitHub runners
if [ -x /usr/local/bin/runc ]; then
	sudo mv /usr/local/bin/runc /usr/local/bin/runc.disabled
fi
