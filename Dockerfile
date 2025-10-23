FROM oven/bun:1 as builder

WORKDIR /app

# Copy package files and install dependencies
COPY package.json bun.lock .npmrc ./
RUN bun install

# Copy the rest of the application
COPY . .

# Build the application (this will create a static site in the build directory)
RUN bun run build

# Production stage - use nginx to serve static files
FROM nginx:alpine

# Copy nginx configuration
COPY --from=builder /app/build /usr/share/nginx/html

# Copy custom nginx config for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose the port the app will run on
EXPOSE 80

# Nginx will start automatically, no CMD needed