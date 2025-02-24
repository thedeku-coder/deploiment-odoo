#!/bin/bash

# Fonction pour restaurer la base de données à partir d'une sauvegarde
restore_database() {
    # Vérifier si le fichier de sauvegarde existe
    if [ -f "$1" ]; then
        # Demander confirmation à l'utilisateur
        read -p "Êtes-vous sûr de vouloir restaurer la base de données à partir de $1 ? (o/n) : " answer
        case $answer in
            [oO]) 
                # Restaurer la base de données à partir de la sauvegarde
                echo "Restauration de la base de données en cours..."
                5
                echo "La restauration de la base de données à partir de $1 est terminée."
                ;;
            *)
                echo "Opération annulée."
                ;;
        esac
    else
        echo "Le fichier de sauvegarde $1 n'existe pas."
    fi
}

# Demander le chemin vers le fichier de sauvegarde
read -p "Veuillez saisir le chemin complet du fichier de sauvegarde pg_dump :" backup_file

# Appeler la fonction pour restaurer la base de données
restore_database "$backup_file"
