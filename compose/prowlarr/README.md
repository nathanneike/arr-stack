# Prowlarr
## Purpose

Prowlarr is the index manager for the arr stack. 

It takes care of the indexers and shares them with lidarr and radarr. An indexer is nothing more then a search engine assume we want a movie or season we ask Prowlarr for "the Last of us" it will send that search to multiple indexers (that maintain a catalogue off of available results) and those will then be returned by prowlarr. 

## Docker

### Image

lscr.io/linuxserver/prowlarr:latest

### Container 

prowlarr

### Ports 

| Host | Container | Purpose |
| --- | --- | ---|
| 9696 | 9696 | Web interface |

Acess at : 
``` bash
http://<NAS-IP>:9696 

### Volumes 

| Host | Container | Purpose |
| --------- | ---| --- |
| /volume1/homelab/appdata/prowlarr | /config | Persistent configuration |




