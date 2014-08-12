#!/bin/bash

set -e

# docker related... to get the gateway IP
export AHOST=$(netstat -nr | grep 'UG' | awk '{print $2}')
echo "AHOST:   $AHOST"

(
	echo "# Auto-generated : do not touch"
	echo ""
	# echo "upstream site.localhost {"
	# printf "    server ${AHOST}:5000;\n"
	# echo "}"
	echo "server {"
	echo ""
	echo "    listen 8080;"
	echo "    server_name dawg-nginx;"
	echo ""
	echo "    location / {"
	echo "        proxy_set_header        Host            \$host;"
	echo "        proxy_set_header        X-Real-IP       \$remote_addr;"
	echo "        proxy_set_header        X-Forwarded-For \$proxy_add_x_forwarded_for;"
	echo ""
	echo "        proxy_pass http://127.0.0.1:5000;"
	echo "    }"
	echo "}"
) > dlb.cfg

sudo cp dlb.cfg /etc/nginx/sites-enabled/default

nginx &
python app.py
