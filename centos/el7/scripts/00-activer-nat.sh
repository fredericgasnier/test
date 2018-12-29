#!/bin/bash
#
# 00-activer-nat.sh
#
# Nicolas Kovacs, 2019
#
# Ce script active le relais des paquets sur un serveur faisant office de
# passerelle.

. source.sh

# Activer le relais des paquets
echo
echo -e ":: Activation du relais des paquets... \c"
sleep $DELAY
cat $CWD/../config/sysctl.d/enable-ip-forwarding.conf > \
  /etc/sysctl.d/enable-ip-forwarding.conf
sysctl -p --load /etc/sysctl.d/enable-ip-forwarding.conf >> $LOG 2>&1
ok

echo

exit 0
