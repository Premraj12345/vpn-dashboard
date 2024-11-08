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
    python3-venv \  # Install the virtualenv package
    && rm -rf /var/lib/apt/lists/*

# Create a virtual environment for Python packages
RUN python3 -m venv /env

# Install Python dependencies (Flask and SocketIO) inside the virtual environment
RUN /env/bin/pip install Flask Flask-SocketIO

# Create directories for app, certs, vpn, mitmproxy, and scripts
RUN mkdir -p /app /vpn /mitmproxy /certs /etc/mitmproxy /scripts

# Copy VPN and mitmproxy configuration files into the container
COPY ./vpn/ipsec.conf /etc/ipsec.conf
COPY ./vpn/xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
COPY ./vpn/chap-secrets /etc/ppp/chap-secrets
COPY ./vpn/ipsec.secrets /etc/ipsec.secrets
COPY ./mitmproxy/mitmproxy.conf /etc/mitmproxy/mitmproxy.conf
COPY ./certs/vpn-cert.crt /certs/vpn-cert.crt

# Copy the Flask application files
COPY ./app /app

# Copy the startup script into the container
COPY ./scripts/start.sh /scripts/start.sh

# Give execution permissions to the start.sh script
RUN chmod +x /scripts/start.sh

# Set working directory to /app (Flask app location)
WORKDIR /app

# Expose required ports for VPN, mitmproxy, and Flask
EXPOSE 5000 8080 1701/udp 4500/udp 500/udp

# Run the startup script
CMD ["/scripts/start.sh"]
