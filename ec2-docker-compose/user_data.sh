#!/usr/bin/env bash

# Install requirements
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates git curl jq software-properties-common docker-ce docker-ce-cli containerd.io

# Add ubuntu user to docker group (so we don't need sudo for docker commands after reboot/re-login)
sudo usermod -aG docker ubuntu
# Enable Docker to start on boot
sudo systemctl enable docker

# Install Docker Compose
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r ".tag_name" | cut -c2-)
sudo curl -L "https://github.com/docker/compose/releases/download/$${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone Storedog
APP_DIR=/home/ubuntu/storedog
git clone https://github.com/DataDog/storedog.git --depth=1 $${APP_DIR}
sudo chown -R ubuntu:ubuntu $${APP_DIR}

cd $${APP_DIR}
cp .env.template .env

# Update Datadog environment variables
sed -i 's/^DD_API_KEY=.*/DD_API_KEY=${dd_api_key}/' .env
sed -i 's/^DD_APP_KEY=.*/DD_APP_KEY=${dd_app_key}/' .env
sed -i 's/^DD_SITE=.*/DD_API_KEY=${dd_site}/' .env
sed -i 's/^DD_ENV=.*/DD_ENV=storedog-local/' .env
sed -i 's/^DATADOG_API_KEY=.*/DATADOG_API_KEY=${dd_api_key}/' .env
sed -i 's/^NEXT_PUBLIC_DD_APPLICATION_ID=.*/NEXT_PUBLIC_DD_APPLICATION_ID=${dd_storedog_rum_app_id}/' .env
sed -i 's/^NEXT_PUBLIC_DD_CLIENT_TOKEN=.*/NEXT_PUBLIC_DD_CLIENT_TOKEN=${dd_storedog_rum_client_token}/' .env
sed -i 's/NEXT_PUBLIC_DD_SERVICE_FRONTEND=store-frontend/NEXT_PUBLIC_DD_SERVICE_FRONTEND=storedog-frontend/' .env

sudo docker compose up -d