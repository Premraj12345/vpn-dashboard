#!/bin/bash

# Start VPN services (strongSwan and xl2tpd)
echo "Starting strongSwan..."
strongswan start &

echo "Starting xl2tpd..."
xl2tpd start &

# Start mitmproxy in transparent mode to capture traffic
echo "Starting mitmproxy..."
mitmproxy --mode transparent --listen-port 8080 &

# Start the Flask app for the dashboard using the virtual environment's Python
echo "Starting Flask app..."
/env/bin/python3 /app/app.py
