#!/bin/bash
# Update system packages
echo "Updating system packages..."
sudo apt update

# Install Apache2 web server
echo "Installing Apache2..."
sudo apt install -y apache2

# Stop Apache service
echo "Stopping Apache2 service..."
sudo service apache2 stop

echo "ENABLING BASIC APACHE SECURITY RECOMMENDATIONS..."

# Restrict permissions on Apache conf files
echo "Securing Apache configuration files..."
sudo chmod -R go-rwx /etc/apache2/*

# Hiding Server Version and Banner 
echo "Configuring security settings in security.conf..."
sudo sed -i '/ServerSignature/c\ServerSignature Off' /etc/apache2/conf-available/security.conf
sudo sed -i '/ServerTokens/c\ServerTokens Prod' /etc/apache2/conf-available/security.conf

# Restart Apache service
echo "Restarting Apache2 service..."
sudo service apache2 start