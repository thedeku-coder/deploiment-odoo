#!/bin/bash
docker network create traefik_net
cd ~/traefik
docker compose up -d


sleep 50

sudo docker exec odoo odoo -d db_odoo -i base

docker compose down

docker compose up -d
