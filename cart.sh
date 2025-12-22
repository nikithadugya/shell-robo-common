#!/bin/bash
source ./common.sh
app_name=cart

check_root
nodejs_setup
app_setup
systemd_setup
systemctl restart mongod
print_total_time
