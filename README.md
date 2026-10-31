# VPS Infrastructure

A lightweight self-hosted infrastructure setup for a VPS, built with Docker Compose and focused on reverse proxying, TLS termination, and system monitoring.

## Overview

This project provides a simple environment for hosting services on a VPS with:

- Nginx as a reverse proxy
- HTTPS support via Certbot and Let's Encrypt
- Prometheus for metrics collection
- Grafana for dashboards and visualization
- Node Exporter for host-level system monitoring

The goal is to create a small, maintainable homelab-style deployment that demonstrates practical DevOps skills such as container orchestration, observability, and secure service exposure.

## Architecture

- Nginx listens on ports 80 and 443 and routes traffic
- HTTP requests are redirected to HTTPS
- Certificates are managed through Certbot and Let's Encrypt
- Prometheus scrapes infrastructure metrics
- Grafana visualizes metrics using a provisioned dashboard
- Persistent Docker volumes are used for Prometheus and Grafana data

## Project Structure

```text
.
├── compose.yaml
├── nginx/
│   └── nginx.conf
├── monitoring/
│   ├── compose.yaml
│   ├── grafana/
│   │   ├── config/
│   │   │   └── grafana.ini
│   │   └── provisioning/
│   │       ├── dashboards/
│   │       │   ├── basic-vps.json
│   │       │   └── provider.yaml
│   │       └── datasources/
│   │           └── datasource.yaml
│   └── prometheus/
│       └── prometheus.yaml
└── README.md
```

## Prerequisites

Before deploying, ensure you have:

- A Linux VPS or similar server
- Docker and Docker Compose installed
- A registered domain and DNS configuration
- Open ports 80 and 443 exposed to the internet

## Deployment

1. Create the required Docker network:

```bash
docker network create web
```

2. Start the monitoring stack:

```bash
cd monitoring
docker compose up -d
```

3. Start the main stack:

```bash
cd ..
docker compose up -d
```

4. Verify that services are running:

```bash
docker compose ps
docker compose logs -f
```

5. Configure DNS so the domain points to the VPS.

## TLS and HTTPS

The stack is configured for certificate generation and HTTPS setup through Certbot and Let's Encrypt.

Important notes:

- Certificate files should be stored under the expected Let's Encrypt paths
- Nginx should be configured to reload after certificate renewal
- The renewal process should be verified regularly

## Monitoring

The monitoring stack includes:

- Node Exporter for host metrics
- Prometheus for scraping and storage
- Grafana for dashboards and visualization

The default Grafana dashboard is provisioned automatically and monitors:

- CPU usage
- RAM usage
- Disk usage

## Security Notes

The setup includes several hardening measures for monitoring containers, such as:

- read-only filesystems where possible
- dropped Linux capabilities
- no-new-privileges
- restricted mount access

This is a strong starting point for a secure homelab setup, with additional hardening recommended for production environments.

## Main Services

### Nginx

Nginx acts as the edge proxy and handles both HTTP-to-HTTPS redirection and reverse proxying to internal services.

### Certbot

Certbot manages HTTPS certificates and stores generated data in persistent volumes.

### Prometheus

Prometheus scrapes host metrics using Node Exporter and stores time-series data in a Docker volume.

### Grafana

Grafana is configured with a provisioned datasource and dashboard, making it easier to visualize infrastructure metrics.

## Roadmap

Planned improvements:

- stronger Grafana access control
- automated certificate renewal validation
- alert rules and Alertmanager
- backup and restore procedures
- CI checks for configuration validation
- improved documentation for production deployment

## Summary

This project demonstrates practical experience with:

- Docker and Docker Compose
- reverse proxy configuration
- HTTPS and TLS setup
- infrastructure monitoring
- metrics visualization
- self-hosted services on a VPS

## License

This project is intended for personal infrastructure experimentation and learning purposes.
