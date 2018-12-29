#!/bin/bash
#
# 00-desactiver-ipv6.sh
#
# Nicolas Kovacs, 2019
#
# Ce script désactive l'IPv6 et reconfigure automatiquement les serveurs SSH et
# Postfix pour qu'ils fonctionnent correctement en IPv4 seul. La reconstruction
# de l'initrd évite le plantage de rpcbind au démarrage.

. source.sh

# Désactiver l'IPv6
echo
echo -e ":: Désactivation de l'IPv6... \c"
sleep $DELAY
cat $CWD/../config/sysctl.d/disable-ipv6.conf > /etc/sysctl.d/disable-ipv6.conf
sysctl -p --load /etc/sysctl.d/disable-ipv6.conf >> $LOG 2>&1
ok

# SSH
echo "::"
echo -e ":: Configuration du serveur SSH... \c"
sleep $DELAY
if [ -f /etc/ssh/sshd_config ]; then
  sed -i -e 's/#AddressFamily any/AddressFamily inet/g' /etc/ssh/sshd_config
  sed -i -e 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config
  systemctl restart sshd
fi
ok

# Postfix
echo "::"
echo -e ":: Configuration du serveur Postfix... \c"
sleep $DELAY
if [ -f /etc/postfix/main.cf ]; then
  sed -i -e 's/inet_protocols = all/inet_protocols = ipv4/g' /etc/postfix/main.cf
  systemctl restart postfix
fi
ok

# rpcbind
echo "::"
echo -e ":: Reconstruction du disque mémoire initial... \c"
sleep $DELAY
dracut -f -v >> $LOG 2>&1
ok

echo

exit 0
