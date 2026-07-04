#!/usr/bin/env bash

set -euo pipefail

OUTPUT="/volume1/homelab/appdata/monitoring/textfile/vpn.prom"

if IP=$(docker exec gluetun wget -qO- https://ipinfo.io/ip 2>/dev/null); then
cat > "$OUTPUT" <<EOF
# HELP vpn_connected Whether the VPN is connected
# TYPE vpn_connected gauge
vpn_connected 1

# HELP vpn_exit_ip Current VPN exit IP
# TYPE vpn_exit_ip_info gauge
vpn_exit_ip_info{ip="$IP"} 1
EOF

else
cat > "$OUTPUT" <<EOF
# HELP vpn_connected Whether the VPN is connected
# TYPE vpn_connected gauge
vpn_connected 0
EOF
fi
