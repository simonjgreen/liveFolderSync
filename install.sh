#!/bin/sh
SCRIPT=$(readlink -f $0)
INSTALLPATH=`dirname $SCRIPT`

apt-get -y install inotify-tools

mkdir -p /etc/defaults
ln -s $INSTALLPATH/defaults /etc/defaults/liveFolderSync
ln -s $INSTALLPATH/init /etc/defaults/liveFolderSync
ln -s $INSTALLPATH/etc /etc/liveFolderSync
ln -s $INSTALLPATH/liveFolderSync /usr/sbin/liveFolderSync

update-rc.d liveFolderSync defaults 98 02

cat $INSTALLPATH/README.mediawiki
