#!/bin/bash

# Check if site is accessible
curl -s -o /dev/null -w "%{http_code}" https://your-domain.com

# Check SSL certificate
ssl_expiry=$(openssl s_client -connect your-domain.com:443 2>/dev/null | openssl x509 -noout -enddate)
echo "SSL Expiry: $ssl_expiry"

# Check server response time
curl -s -w "\nTime: %{time_total}s\n" https://your-domain.com 