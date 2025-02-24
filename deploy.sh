#!/bin/bash

vmName=$1
ip=$2


#On crée la VM, et on y déploie notre clé SSH
echo "Création de la machine $vmName"
vmiut create $vmName 
vmiut start $vmName > /dev/null

echo "Machine $vmName" démarrée

# On boucle tant que l'ip n'est pas attribuée
while [[ -z "$(vmiut info $vmName | tail -n 2 | head -n1 | cut -d '=' -f 2)" ]];
do
    sleep 1
done

echo "ip obtenue"

oldIp=$(vmiut info $vmName | tail -n 2 | head -n1 | cut -d '=' -f 2)

ssh-keygen -f .ssh/id_rsa_"$vmName"
echo "entrer yes entrer entrer yes user"

printf "\n\nPour déployer votre clé publique dans $vmName, entrez le mot de passe suivant :\nuser\n\n"
ssh-copy-id -i .ssh/id_rsa_"$vmName" user@$oldIp
echo "Clé publique déployée"


#On écrit le fichier qui va remplacer le /etc/network/interfaces de la VM
printf "source /etc/network/interfaces.d/*\n\nauto lo\niface lo inet loopback\n\nallow-hotplug enp0s3\niface enp0s3 inet static\n  address $ip/16\n gateway 10.42.0.1\n" > interfaces

printf "127.0.0.1       localhost\n127.0.1.1       $vmName\n\n::1     localhost ip6-localhost ip6-loopback\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters\n" > hosts

echo $vmName > hostname

echo "Les fichiers hostname, hosts et interfaces sont prêts"

# On transfère nos fichiers sur la machine
printf "\n\nSi on vous le demande le mot de passe de user, entrez :\nuser\n\n"
scp interfaces user@$oldIp:~
scp hosts user@$oldIp:~
scp hostname user@$oldIp:~
scp move_conf.sh user@$oldIp:~

echo "Tous les fichiers sont envoyés"

printf "\nEntrez le mot de passe suivant pour changer l'IP, le hostname :\n\nroot\n\n"
ssh user@$oldIp "su -c 'source move_conf.sh'"

echo "Maintenant, on va redémarrer la machine $vmName"

# On attend pour être sur que la derniére commande est executé, puis on redemarre
sleep 10
vmiut stop $vmName > /dev/null
echo "Machine arrêtée"
sleep 5
vmiut start $vmName > /dev/null
echo "Machine redémarrée"

#On attend pour que la machine soit bien démarrée
sleep 15
scp superuser.conf user@$ip:~
ssh user@$ip "su -c '/home/user/superuser.conf'"

if [ "$vmName" = 'odoo' ]
then
    echo "Le script a reconnu odoo, il va donc installer docker "
    scp odoo.sh user@$ip:~
    scp generateur.sh user@$ip:~
    ssh user@$ip ./odoo.sh
    fail 2> /dev/null # Pour initialiser la variable
    while [[ $? -gt 0 ]];
    do
        scp traefik.sh user@$ip:~
    done
    ssh user@$ip ./traefik.sh
elif [ "$vmName" = 'backup' ]
then
    echo "Le script a reconnu backup, il va donc installer rsync "
    ssh user@$ip "sudo apt install rsync -y" > /dev/null
    echo "rsync installé"
    scp restore.sh user@$ip:~
elif [ "$vmName" = 'psql' ]
then
    echo "Le script a reconnu psql, il va donc installer psql et rsync "
    scp make_backup.sh user@$ip:~
    scp psql.sh user@$ip:~
	ssh user@$ip ./psql.sh
else
    echo "Le programme arrête la configuration ici car le nom de la VM n'est pas connu"
fi

printf "La machine $vmName est prête \n\n"
