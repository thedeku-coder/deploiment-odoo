#!/bin/bash

# si le dossier n'existe pas on le crée
sudo mkdir -p /var/lib/postgresql/backups

DATE=$(date +"%d_%m_%y-%H_%M")

# cd ~ pour être sur d'être au bon endroit
sudo su postgres -c "cd ~ && pg_dumpall -f /var/lib/postgresql/backup_db_$DATE.sql"
sudo mv /var/lib/postgresql/backup_db_$DATE.sql /var/lib/postgresql/backups/backup_db_$DATE.sql
rsync -a /var/lib/postgresql/backups user@10.42.129.60:/home/user/
