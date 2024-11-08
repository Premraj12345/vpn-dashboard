# Use an official Ubuntu image
FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    strongswan \
    xl2tpd \
    iproute2 \
    net-tools \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy VPN config files
COPY ./ipsec.conf /etc/ipsec.conf
COPY ./xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
COPY ./chap-secrets /etc/ppp/chap-secrets
COPY ./ipsec.secrets /etc/ipsec.secrets

# Expose VPN ports
EXPOSE 500/udp 4500/udp 1701/tcp

# Start the VPN services
CMD service strongswan start && service xl2tpd start && tail -f /dev/null
