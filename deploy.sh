#!/bin/bash

# Configuration
DEPLOY_ENV=$1
APP_NAME="melbet-clone"
DEPLOY_PATH="/var/www/html"
BACKUP_PATH="/var/backups/$APP_NAME"

# Create backup
echo "Creating backup..."
timestamp=$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_PATH"
tar -czf "$BACKUP_PATH/backup_$timestamp.tar.gz" "$DEPLOY_PATH"

# Build application
echo "Building application..."
npm install
npm run build

# Deploy based on environment
case $DEPLOY_ENV in
  "vercel")
    echo "Deploying to Vercel..."
    vercel --prod
    ;;
    
  "docker")
    echo "Deploying with Docker..."
    docker-compose up -d --build
    ;;
    
  "vps")
    echo "Deploying to VPS..."
    # Copy files to server
    rsync -avz --delete dist/ user@your-server:$DEPLOY_PATH
    # Restart Nginx
    ssh user@your-server "sudo systemctl restart nginx"
    ;;
    
  *)
    echo "Please specify deployment environment (vercel/docker/vps)"
    exit 1
    ;;
esac

echo "Deployment completed successfully!" 