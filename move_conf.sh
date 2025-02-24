#!/bin/bash
mv hostname hosts /etc # On set les variable d'env, les hosts et hostname
mv interfaces /etc/network # On set les bon paramétres réseau
apt-mark hold grub-pc # On met grub-pc en hold sinon on ne peut pas mettre a jour les machines de maniére automatisé
