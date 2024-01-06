#!/bin/bash

# Your JSON string
json_string='["18.207.152.41","54.159.7.127","184.72.86.103"]'

# Extract IP addresses using jq
ip_addresses=$(echo $json_string | jq -r '.[]')

# Write IP addresses to ip.txt
echo "$ip_addresses" > ip.txt

echo "IP addresses written to ip.txt"
