#!/bin/bash

service_name=""

until [ "$service_name" == "fini" ]; do
    # Demander le nom du service
    read -p "Entrez le nom du service Odoo à ajouter (ou 'fini' pour arrêter) : " service_name

    # Ajouter le service Odoo au Docker Compose
    cat <<EOF >> docker-compose.yml
  ${service_name}:
    image: "odoo:latest"
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.${service_name}.rule=Host(\`${service_name}.localhost\`)"
      - "traefik.http.services.${service_name}.loadbalancer.server.port=8069"
    ports:
      - "8069:8069" 
    volumes:
      - ./odoo.conf:/etc/odoo/odoo.conf               
    networks:
      - traefik_net
EOF

    echo "Service Odoo ${service_name} ajouté au Docker Compose."
done
