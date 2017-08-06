#!/usr/bin/bash

sudo apt-get update -y
sudo apt-get install -y --no-install-recommends nginx build-essential

sudo cat limits.conf.append >> /etc/security/limits.conf

cd filgen && make && ./generate_video_files_and_logs.sh /usr/share/nginx/html
