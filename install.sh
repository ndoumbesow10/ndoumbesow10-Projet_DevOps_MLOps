#!/bin/bash

# Update et install les dépendances nécessaires pour Docker
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Ajout de la clé GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Ajout du dépôt Docker à APT
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Update et install Docker
sudo apt-get update
sudo apt-get install -y docker-ce

# Installer Git
sudo apt-get install -y git

# Cloner le dépôt de notre API API_POKEDEX
git clone https://github.com/PAPEBDIA/API_POKEDEX.git
cd API_POKEDEX

# Construction et exécution du conteneur Docker pour notre API
sudo docker build -t myapi .
sudo docker run -d -p 80:80 myapi

# Installation Nginx
sudo apt-get install -y nginx

# Configuration Nginx pour faire du proxy_pass vers le conteneur Docker
sudo bash -c 'cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;

    location / {
        proxy_pass http://localhost:80;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF'

# Redémarrer Nginx pour appliquer les changements
sudo systemctl restart nginx