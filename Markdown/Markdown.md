# Sommaire
1. [Pra](#pra)
2. [Deploy](#deploy)
3. [La machine Backup](#la-machine-backup)
4. [La machine Postgresql](#la-machine-postgresql)
5. [La machine odoo](#la-machine-odoo)


## Pra
C'est ce script que l'on va éxécuter afin de déployer l'infrastructure

Le but de ce fichier est de passer l'entièreté des fichiers en 755 si ils ni sont pas déjà puis d'éxécuter le script deploy.sh avec les bons paramètres

## Deploy

Ce script permet de créer des machines virtuelles qui contiendront posgresql, odoo et une machine de backup

En fonction du nom et l'ip passée en paramètre, il va s'occuper de la configuration réseau de la machine.
Il permet aussi de créer des clés ssh  et de les intégrés aux machines afin de s'y connecter plus facilement ensuite.

En fonction du nom passé en paramètre, le script exécutera ensuite différents autres scripts afin de configurer spécifiquement les machines aux différentes taches qui les attendent

## La machine Backup

La machine backup permet de stocker des backups de la base postgresql quotidiennement.
Il suffit de lui installer rsinc pour qu'elle fonctionne convenablement.


## La machine Postgresql

La machine Postgresl contient la base de donnée postgres.
On y fera quotidiennment des backups que l'on stockera dans la machine backup.
Il faut donc lui installer psql et rsinc, et lui donner un script permettant de faire des backups.

### make_backup
Ce script permet de créer des backups

Expliquer make_backup


### psql.sh 
Ce script permet de mettre en place psql sur la machine.

On commence par installer psql et rsinc. Ensuite, on configure les addresses. Après redémarrage du service, on peut finalement ajouter au crontab l'usage de make_backup.sh quotidiennement à 4h00.

## La machine odoo

Cette machine contient odoo.

On va exécuter odoo.sh puis traefik.sh.

### odoo.sh

Ce script permet l'installation de odoo sur la machine.

On y installe une ppa pour vérifier les fichiers, puis docker.

Ensuite on ajoute user au groupe docker afin qu'il puisse l'utiliser.

On créer un dossier traefik/config si il n'existe pas

On écrit traefik.yaml et docker-compose.yml puis on restart la machine

### traefik.sh

On créer un réseau docker nommé rtaefik.net puis on lance le docker compose créer précédement grçace au script odoo.s

## move_conf.sh

Dans ce script, on set les variable d'env, les hosts et hostname, les bons paramétres réseau. On met grub-pc en hold sinon on ne peut pas mettre a jour les machines de maniére automatisé

