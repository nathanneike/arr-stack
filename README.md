```bash
# Verify NAS public IP
wget -qO- https://api.ipify.org

# Verify Gluetun public IP
docker exec gluetun wget -qO- https://api.ipify.org

# Verify qBittorrent public IP
docker exec qbittorrent wget -qO- https://api.ipify.org
```
