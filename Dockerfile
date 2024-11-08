# Use an official Ubuntu image
FROM ubuntu:latest

# Install system dependencies for VPN, mitmproxy, and Flask
RUN apt-get update && apt-get install -y \
    strongswan \
    xl2tpd \
    iproute2 \
    net-tools \
    curl \
    mitmproxy \
    python3 \
    python3-pip \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies (Flask and SocketIO)
RUN pip3 install Flask Flask-SocketIO

# Create directories for app, certs, vpn, and mitmproxy
RUN mkdir -p /app /vpn /mitmproxy /certs /etc/mitmproxy

# Copy VPN and mitmproxy configuration files into the container
COPY ./vpn/ipsec.conf /etc/ipsec.conf
COPY ./vpn/xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
COPY ./vpn/chap-secrets /etc/ppp/chap-secrets
COPY ./vpn/ipsec.secrets /etc/ipsec.secrets
COPY ./mitmproxy/mitmproxy.conf /etc/mitmproxy/mitmproxy.conf
COPY ./certs/vpn-cert.crt /certs/vpn-cert.crt

# Copy the Flask application files
COPY ./app /app

# Set working directory to /app (Flask app location)
WORKDIR /app

# Expose required ports for VPN, mitmproxy, and Flask
EXPOSE 5000 8080 1701/udp 4500/udp 500/udp

# Start the VPN, mitmproxy, and Flask app
CMD bash -c "
    # Start the VPN services (IPSec and L2TP)
    service strongswan start && \
    service xl2tpd start && \
    
    # Start mitmproxy in transparent mode to capture traffic
    mitmproxy --mode transparent --listen-port 8080 & \
    
    # Start the Flask app for the dashboard
    python3 /app/app.py
"
