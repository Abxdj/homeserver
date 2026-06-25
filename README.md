# Aizen — Home Server

A self-hosted home server running on an HP Pavilion laptop with Ubuntu Server 24.04.

## Hardware

| Component | Spec |
|---|---|
| CPU | Intel Core i5 |
| RAM | 8GB |
| Storage | 1TB SSD |
| GPU | NVIDIA GeForce 940MX (2GB VRAM) |
| OS | Ubuntu Server 24.04.4 LTS |

## Architecture

All services run as Docker containers, accessible locally via static IP and remotely via Tailscale VPN.

## Services

| Service | Purpose | Port |
|---|---|---|
| Jellyfin | Media server with NVENC GPU transcoding | 8096 |
| Radarr | Automated movie downloads | 7878 |
| Sonarr | Automated TV show downloads | 8989 |
| Prowlarr | Torrent indexer management | 9696 |
| qBittorrent | Torrent download client | 8090 |
| Nextcloud | Self-hosted cloud storage | 8080 |
| Immich | Automatic photo backup | 2283 |
| Ollama + Open WebUI | Local AI (phi3:mini on 940MX) | 11434 / 3000 |
| Pi-hole | Network-wide ad blocking | 8053 |
| Nginx Proxy Manager | Reverse proxy | 80/443 |
| Portainer | Docker management UI | 9000 |
| Homepage | Unified service dashboard | 3001 |
| Tailscale | Secure remote access (WireGuard) | - |

## Setup

### Prerequisites
- Ubuntu Server 24.04 LTS
- NVIDIA GPU (optional, for transcoding and local AI)

### Installation

1. Clone the repo:
```bash
git clone https://github.com/Abxdj/homeserver.git
cd homeserver
```

2. Copy and fill in environment variables:
```bash
cp .env.example .env
nano .env
```

3. Run the setup script:
```bash
chmod +x setup.sh
./setup.sh
```

4. Reboot:
```bash
sudo reboot
```

5. Connect Tailscale:
```bash
sudo tailscale up --accept-dns=false
```

6. Deploy services:
```bash
cd docker/jellyfin && docker compose up -d
cd ../arr && docker compose up -d
cd ../nextcloud && docker compose up -d
cd ../immich && docker compose up -d
cd ../ollama && docker compose up -d
cd ../pihole && docker compose up -d
cd ../homepage && docker compose up -d
cd ../nginx-proxy-manager && docker compose up -d
```

## Network

- Local IP: static, set via netplan
- Remote access: Tailscale (no open ports on router)
- DNS: Pi-hole with Google DNS fallback (8.8.8.8)

## Skills Demonstrated

- Linux server administration (Ubuntu Server)
- Docker and container orchestration
- Networking (static IP, DNS, reverse proxy, VPN)
- NVIDIA GPU configuration (drivers, NVENC, container toolkit)
- Security (no exposed ports, env-based secrets, Tailscale)
