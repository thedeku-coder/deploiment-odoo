#!/bin/bash
# Installation psql et rsync
sudo apt install docker.io docker-compose rsync postgresql-client -y

# Configuration des adresses
#echo 'host    all             all             10.42.0.1/16	md5' | sudo tee -a /etc/postgresql/15/main/pg_hba.conf
#echo "listen_addresses = '0.0.0.0'" | sudo tee -a /etc/postgresql/15/main/postgresql.conf
mkdir -p ~/postgres
printf 'version: "3.9"\n\nservices:\n  postgres:\n    image: postgres\n    container_name: psql\n    environment:\n      POSTGRES_USER: odoo  # Utilisateur de la base de données\n      POSTGRES_PASSWORD: odoo  # Mot de passe de la base de données\n      POSTGRES_DB: db_odoo  # Nom de la base de données\n    volumes:\n      - ./data:/var/lib/postgresql/data  # Volume pour persister les données de la base de données\n    ports:\n      - "5432:5432"  # Port PostgreSQL\n' > ~/postgres/docker-compose.yml
cd ~/postgres
mkdir data


sudo docker-compose up -d

# Redémarrer le service postgresql


# Ajouter au crontab l'usage de make_backup.sh
printf '0 4 * * * bash /home/user/make_backup.sh' | sudo tee /var/spool/cron/crontabs/user
