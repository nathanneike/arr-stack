#!/usr/bin/env bash

set -euo pipefail

OUTPUT="/volume1/homelab/appdata/monitoring/textfile/vpn.prom"
TMP="${OUTPUT}.tmp"

GLUETUN_IP=$(docker exec gluetun wget -qO- https://ipinfo.io/ip 2>/dev/null || true)
QBIT_IP=$(docker exec qbittorrent wget -qO- https://ipinfo.io/ip 2>/dev/null || true)
NETWORK_MODE=$(docker inspect qbittorrent --format '{{.HostConfig.NetworkMode}}' 2>/dev/null || true)

GLUETUN_CONNECTED=0
QBITTORRENT_USING_GLUETUN=0
QBITTORRENT_VPN_OK=0

# Can qBittorrent reach the Internet?
if [[ -n "$QBIT_IP" ]]; then
    GLUETUN_CONNECTED=1
fi

# Is qBittorrent configured to use Gluetun?
if [[ "$NETWORK_MODE" == "container:gluetun" ]]; then
    QBITTORRENT_USING_GLUETUN=1
fi

# Does qBittorrent actually exit through the same VPN as Gluetun?
if [[ -n "$GLUETUN_IP" && "$GLUETUN_IP" == "$QBIT_IP" ]]; then
    QBITTORRENT_VPN_OK=1
fi

cat > "$TMP" <<EOF
# HELP gluetun_connected Whether Gluetun provides Internet connectivity.
# TYPE gluetun_connected gauge
gluetun_connected $GLUETUN_CONNECTED

# HELP qbittorrent_using_gluetun Whether qBittorrent is configured to use Gluetun's network namespace.
# TYPE qbittorrent_using_gluetun gauge
qbittorrent_using_gluetun $QBITTORRENT_USING_GLUETUN

# HELP qbittorrent_vpn_ok Whether qBittorrent is using Gluetun's VPN connection.
# TYPE qbittorrent_vpn_ok gauge
qbittorrent_vpn_ok $QBITTORRENT_VPN_OK

# HELP qbittorrent_exit_ip Current public IP used by qBittorrent.
# TYPE qbittorrent_exit_ip_info gauge
qbittorrent_exit_ip_info{ip="$QBIT_IP"} 1
EOF

mv "$TMP" "$OUTPUT"
