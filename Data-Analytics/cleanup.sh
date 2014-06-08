#!/bin/bash
#
# Clean up Data Analytics

echo "[Data-Analytics] Cleaning up ..."
killall java
rm -rf analytics-release
