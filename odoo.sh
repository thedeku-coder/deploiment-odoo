#!/bin/bash

############# TODO
# Ajout d'un ppa
sudo apt-get install ca-certificates curl gnupg lsb-release -y
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update puis installation de docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo apt install postgresql-client -y


# On met user dans le groupe docker
sudo usermod -aG docker user

mkdir -p ~/traefik/config

#############  config du odoo
sudo printf "[options]\naddons_path = /mnt/extra-addons\ndata_dir = /var/lib/odoo\n; admin_passwd = admin\n; csv_internal_sep = ,\n; db_maxconn = 64\n; db_name = False\n; db_template = template1\n; dbfilter = .*\n; debug_mode = False\n; email_from = False\n; limit_memory_hard = 2684354560\n; limit_memory_soft = 2147483648\n; limit_request = 8192\n; limit_time_cpu = 60\n; limit_time_real = 120\n; list_db = True\n; log_db = False\n; log_handler = [':INFO']\n; log_level = info\n; logfile = None\n; longpolling_port = 8072\n; max_cron_threads = 2\n; osv_memory_age_limit = 1.0\n; osv_memory_count_limit = False\n; smtp_password = False\n; smtp_port = 25\n; smtp_server = localhost\n; smtp_ssl = False\n; smtp_user = False\n; workers = 0\n; xmlrpc = True\n; xmlrpc_interface =\n; xmlrpc_port = 8069\n; xmlrpcs = True\n; xmlrpcs_interface =\n; xmlrpcs_port = 8071\ndb_host = 10.42.129.50\ndb_port = 5432\ndb_user = odoo\ndb_password = odoo\ndb_name = db_odoo\n" > ~/odoo.conf
############# traefik.yaml et docker-compose.yml
printf "version: '3'\n\nservices:\n\n  traefik:\n    image: traefik:v2.11\n    container_name: traefik\n    command:\n      - --api.insecure=true\n      - --providers.docker=true\n      - --providers.docker.exposedbydefault=false\n      - --entrypoints.web.address=:80\n    ports:\n      - 80:80\n      - 8080:8080\n    volumes:\n      - /var/run/docker.sock:/var/run/docker.sock:ro\n  odoo:\n    container_name: odoo\n    image: odoo:17\n    ports:\n      - 8069:8069\n    volumes:\n      - /home/user/odoo.conf:/etc/odoo/odoo.conf\n    labels:\n      - traefik.enable=true\n      - traefik.http.routers.odoo.rule=Host(\"odoo.localhost\")\n      - traefik.http.routers.odoo.entrypoints=web\n    restart: always\n" > ~/traefik/docker-compose.yml
#printf 'api:\n  dashboard: true\n  insecure: true\n\nentryPoints:\n  http:\n    address: ":80"\n  https:\n    address: ":443"\n\nproviders:\n  docker:\n    network: proxy\n' > ~/traefik/config/traefik.yml


# Faut restart la machine
sudo reboot
