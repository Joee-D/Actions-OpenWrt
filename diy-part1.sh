#!/bin/bash

# Actions-OpenWrt: runs before feeds are updated
echo "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main" >> "feeds.conf.default"
