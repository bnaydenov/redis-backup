#!/usr/bin/env bash
#redis-backup.sh is script which copies dump.rdb file to backup directory destionation - separate for each day 
#and name dump file with timestamp.
#this scipt should be executed as cron job for example every 1 hour
#the script also keeps directories last number of days given in KEEP_LAST_NUMBER_OF_DAYS


REDIS_RDB_SOURCE='/var/lib/redis/dump.rdb' #
REDIS_RDB_BACKUP_DESTINATION='/backup'
KEEP_LAST_NUMBER_OF_DAYS=7


###Function declarations##########

#create folder for today if not exist
function createRedisRdbBackupDestinatinDirectory
{
  mkdir -p $REDIS_RDB_BACKUP_DESTINATION/$(date +"%Y-%m-%d")
}

#copy redis file to REDIS_RDB_BACKUP_DESTINATION with timestamp in file name
function copyredisRdbFile
{
  cp $REDIS_RDB_SOURCE $REDIS_RDB_BACKUP_DESTINATION/$(date +"%Y-%m-%d")/dump-$(date +"%Y-%m-%d--%Hh%Mm").rdb
}

#groom old files and delete older then $KEEP_LAST_NUMBER_OF_DAYS
function groomOldFiles
{
	find $REDIS_RDB_BACKUP_DESTINATION -type d -mtime +$KEEP_LAST_NUMBER_OF_DAYS -exec rm -rf {} \;
}

###END Function declarations##########



#create folder for today if not exist
createRedisRdbBackupDestinatinDirectory

#copy redis file to REDIS_RDB_BACKUP_DESTINATION
copyredisRdbFile

#groom old files and delete older then $KEEP_LAST_NUMBER_OF_DAYS
groomOldFiles