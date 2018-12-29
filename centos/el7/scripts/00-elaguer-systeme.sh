#!/bin/bash
#
# 00-elaguer-systeme.sh
#
# Nicolas Kovacs, 2019
#
# Ce script désinstalle tous les paquets présents sur un système CentOS 7 qui
# ne font pas partie du système de base, c'est-à-dire des groupes de paquets
# "Core" et "Base".

CWD=$(pwd)
TMP=/tmp

PKGLIST=$TMP/pkglist
PKGINFO=$TMP/pkg_base

# Créer la liste des paquets installés sur le système
rpm -qa --queryformat '%{NAME}\n' | sort > $PKGLIST 

# Créer une variable correspondant à cette liste
PAQUETS=$(egrep -v '(^\#)|(^\s+$)' $PKGLIST)

# Faire le ménage
rm -rf $PKGLIST $PKGINFO
mkdir $PKGINFO
unset SUPPRIMER

# Créer une base de données rudimentaire 
echo
echo ":: Création de la base de données..."
echo
sleep 3
BASE=$(egrep -v '(^\#)|(^\s+$)' $CWD/../config/pkglists/base.txt)
for PAQUET in $BASE; do
  printf "."
  touch $PKGINFO/$PAQUET
done

echo

# Vérifier pour chaque paquet s'il fait partie du système de base
echo
echo ":: Création de la liste des paquets à supprimer..."
echo
sleep 3
for PAQUET in $PAQUETS; do
  if [ -r $PKGINFO/$PAQUET ]; then
    continue
  else
    printf "."
    SUPPRIMER="$SUPPRIMER $PAQUET"
  fi
done

echo
echo

# Supprimer tous les paquets qui ne font pas partie du système de base
if [[ ! -z $SUPPRIMER ]]; then
  yum -y remove $SUPPRIMER
fi

# Réinstaller les paquets de base
yum -y install $BASE

# Encore un peu de ménage
rm -rf $PKGLIST $PKGINFO

exit 0
