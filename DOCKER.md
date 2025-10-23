# Docker Deployment Guide for Captuvix Wildcard

This guide explains how to use Docker to deploy the Captuvix Wildcard SvelteKit application as a subdomain fallback service.

## Purpose

The Captuvix Wildcard application serves as a fallback for when a subdomain that would normally be redirected to the main Captuvix web application doesn't have proper DNS configuration. Instead of showing a generic browser error, it displays a user-friendly error page indicating that the organization wasn't found.

## Quick Start

The easiest way to run the application is with Docker Compose:

```bash
# Build and start the container
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

The application will be available at http://localhost:8081

## Wildcard Subdomain Handling

To properly handle wildcard subdomains, you'll need to configure your web server or load balancer to direct all unmatched subdomains to this service. When using TrueNAS with Portainer, you can:

1. Configure the main Captuvix web application to handle known subdomains
2. Set up this wildcard service to catch all other `*.captuvix.com` requests

## Development Workflow

For local development with Docker:

1. Make changes to your SvelteKit application
2. Build your application: `bun run build`
3. Rebuild and restart the container: `docker-compose up -d --build`

## Manual Docker Commands

If you prefer not to use Docker Compose:

```bash
# Build the Docker image
docker build -t captuvix-wildcard:latest .

# Run the container
docker run -d -p 8080:80 --name captuvix-wildcard captuvix-wildcard:latest

# Stop and remove the container
docker stop captuvix-wildcard
docker rm captuvix-wildcard
```

## Docker Compose Configuration

The `docker-compose.yml` file includes:

- Basic web server configuration
- Health checks for container monitoring
- Network configuration
- Commented examples for additional services (reverse proxy, backend API)

Customize the Docker Compose file as needed for your specific deployment requirements.

## TrueNAS Deployment with Portainer

For deployment on TrueNAS using Portainer:

1. Upload the project files to your TrueNAS server or use Git integration in Portainer
2. In Portainer, go to "Stacks" and click "Add stack"
3. Name your stack (e.g., "captuvix-wildcard")
4. Either upload your docker-compose.yml file or paste its contents
5. Click "Deploy the stack"

### Port Conflict Resolution

If you encounter a port conflict error like:

```
Error response from daemon: driver failed programming external connectivity on endpoint:
Bind for 0.0.0.0:8081 failed: port is already allocated
```

Simply edit the docker-compose.yml file to use a different port:

```yaml
ports:
  - "8082:80"  # Or any other available port
```

### Wildcard DNS Configuration for TrueNAS

To handle wildcard subdomains on TrueNAS:

1. **Configure DNS**: Set up a wildcard DNS record for your domain
   - Add a `*.captuvix.com` CNAME or A record pointing to your TrueNAS server

2. **Configure Reverse Proxy**: Use either:
   - **Traefik**: Uncomment and configure the Traefik service in docker-compose.yml
   - **NGINX Proxy Manager**: Set up a "catch-all" rule for unmatched subdomains
   - **TrueNAS built-in proxy**: Configure a wildcard rule in the TrueNAS UI

3. **Priority Configuration**: Ensure that:
   - Specific subdomains (like `app.captuvix.com`) are handled by their respective services
   - All other subdomains fall back to this wildcard service

### Example Traefik Configuration

For wildcard domain handling with Traefik:

```yaml
services:
  wildcard:
    # ... existing configuration ...
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.wildcard.rule=HostRegexp(`{subdomain:[a-z0-9-]+}.captuvix.com`)"
      - "traefik.http.routers.wildcard.priority=1"  # Low priority (fallback)
      - "traefik.http.routers.wildcard.entrypoints=websecure"
      - "traefik.http.routers.wildcard.tls.certresolver=myresolver"
      - "traefik.http.services.wildcard.loadbalancer.server.port=80"
```

## Environment Variables

If your application needs environment variables:

1. Create a `.env` file with your variables
2. Uncomment the environment section in docker-compose.yml
3. Add your variables to the environment section

## Common Issues

### Static Site Navigation

If you encounter issues with page navigation (404 errors when directly accessing routes), ensure:

1. The `fallback` option is set to `index.html` in `svelte.config.js`
2. The Nginx configuration properly routes all requests to index.html

### Build Issues

If the build fails in the Docker container:

1. Try building locally first: `bun run build`
2. Check for any build errors and fix them
3. Ensure your build process is compatible with the Dockerfile