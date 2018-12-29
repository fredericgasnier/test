#!/bin/bash
#
# 03-installer-base.sh
#
# Nicolas Kovacs, 2019
#
# Installation du système de base

. source.sh

# Installer le système minimal
echo 
echo -e ":: Installation du système minimal... \c"
yum -y group install "Core" >> $LOG 2>&1
ok

# Installer le système de base
echo "::"
echo -e ":: Installation du système de base... \c"
yum -y group install "Base" >> $LOG 2>&1
ok

# Installer les outils supplémentaires
echo "::"
echo -e ":: Installation des outils supplémentaires... \c"
PAQUETS=$(egrep -v '(^\#)|(^\s+$)' $CWD/../config/pkglists/outils.txt)
yum -y install $PAQUETS >> $LOG 2>&1
ok

echo

exit 0
