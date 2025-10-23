# Docker Deployment Guide for Captuvix Wildcard

This guide explains how to use Docker to deploy the Captuvix Wildcard SvelteKit application as a static site.

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

The application will be available at http://localhost:8080

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

## Production Deployment

For production deployment, consider:

1. Using a reverse proxy (like Traefik) for SSL/TLS
2. Setting appropriate environment variables
3. Configuring proper networking and security

Example for enabling the Traefik configuration:

1. Uncomment the Traefik service in docker-compose.yml
2. Update the email address for Let's Encrypt
3. Add labels to the web service:

```yaml
services:
  web:
    # ... existing configuration ...
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.wildcard.rule=Host(`wildcard.captuvix.com`)"
      - "traefik.http.routers.wildcard.entrypoints=websecure"
      - "traefik.http.routers.wildcard.tls.certresolver=myresolver"
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