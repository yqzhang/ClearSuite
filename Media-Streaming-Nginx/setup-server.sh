#!/usr/bin/env bash

sudo apt-get update -y
sudo apt-get install -y --no-install-recommends nginx build-essential

sudo bash -c "cat limits.conf.append >> /etc/security/limits.conf"

cd filegen && make && sudo ./generate_video_files_and_logs.sh /usr/share/nginx/html
