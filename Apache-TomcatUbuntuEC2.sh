#!/bin/bash

# Update package lists and install Java (for Ubuntu systems)
echo "Installing Java..."
sudo apt update -y && sudo apt install -y default-jdk 
# sudo apt update - updates package lists for Ubuntu 
# && (and) command sudo apt install will execute only if apt update succeeds 
# || sudo yum install -y java-11-amazon-corretto for RHEL-based systems


# Define variables
TOMCAT_VERSION=10.1.39  # Tomcat version
TOMCAT_USER="tomcat"    # User to run Tomcat
TOMCAT_GROUP="tomcat"   # Group for Tomcat
INSTALL_DIR="/opt/tomcat"  # Installation directory



# Download and extract Apache Tomcat into /opt directory 
# we can also configure another palpathce to temporary download
echo "Downloading and installing Tomcat..."
mkdir -p "$INSTALL_DIR" && cd /opt/tomcat
wget https://downloads.apache.org/tomcat/tomcat-10/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz 
tar xz -f apache-tomcat-$TOMCAT_VERSION.tar.gz -C "$INSTALL_DIR" && rm apache-tomcat-$TOMCAT_VERSION.tar.gz.tar.gz


# Create a system user and group for Tomcat (if not already created)
echo "Creating Tomcat user and group..."
sudo groupadd --system $TOMCAT_GROUP
# Creates a system group, which is a group typically used for system services (like running Tomcat). 
#It has a lower group ID (GID) than regular groups and typically doesn't allow regular users to be part of it.
sudo useradd --system --shell /bin/false --home $INSTALL_DIR --gid $TOMCAT_GROUP $TOMCAT_USER
# Creates a system user. Similar to the group, system users are used for system services 
#and typically don't have login permissions or a home directory under /home/username
# --shell /bin/false ensure user cannot log in into the system (it is common for service accounts for extra security)

# Set proper ownership and permissions
echo "Setting up permissions..."
sudo chown -R $TOMCAT_USER:$TOMCAT_GROUP $INSTALL_DIR
sudo chmod -R 770 $INSTALL_DIR


# Create a systemd service file for Tomcat
echo "Creating systemd service for Tomcat..."
cat <<EOF | sudo tee /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Server
After=network.target

[Service]
Type=forking
User=$TOMCAT_USER
Group=$TOMCAT_GROUP
Environment="CATALINA_HOME=$INSTALL_DIR/apache-tomcat-$TOMCAT_VERSION"
ExecStart=$INSTALL_DIR/apache-tomcat-$TOMCAT_VERSION/bin/startup.sh
ExecStop=$INSTALL_DIR/apache-tomcat-$TOMCAT_VERSION/bin/shutdown.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start Tomcat service
echo "Enabling and starting Tomcat service..."
sudo systemctl daemon-reload
#reload systemd manager config
sudo systemctl enable tomcat
#enable tomcat to automatically start during system boot
sudo systemctl start tomcat
#start tomcat immdiately

# Allow port 8080 in the firewall
echo "Allowing communication for port 8080 which is recommended for Tomcat..."
sudo ufw allow 8080/tcp 

echo "Tomcat installed successfully."
