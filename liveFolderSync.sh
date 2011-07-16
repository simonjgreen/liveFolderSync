#!/bin/sh
# Simple script to facilitate a Master/Slave distributed file system for applications such as web servers.
# 1. Set up SSH key authentication to the slave server from the master server
# 2. Invoke this script like:
# nohup ./liveFolderSync.sh &

set -e
set -u

BASEDIR="$1"
TARGETSERVER="$2"
RSYNC="rsync -av --delete -e ssh"

#Logger Function
log() { logger -p daemon.info -t "liveFolderSync" "$@"; echo "$@"; }

#Make sure any running sync completes before exiting
finishSyncAndExiti() { log "Completing currently running syncs";   }
trap finishSyncAndExit SIGINT

# Initial sync
log "Performing initial sync"
$RSYNC ${BASEDIR}/* ${TAGRETSERVER}:${BASEDIR}/
log "Initial sync complete"

# Wait for individual file events and keep in sync
inotifywait --format '%e %w' -e close_write -e move -e create -e delete -qmr $BASEDIR | while read EVENT DIR
do
	# Fork off rsync proc to do sync
	$RSYNC ${DIR}/* ${TAGRETSERVER}:${DIR}/ &
	log "${EVENT} on ${DIR} triggered sync with PID $!"
done
