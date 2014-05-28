#!/usr/bin/env bash
#redis-backup.sh is script which copies dump.rdb file to backup directory destionation - separate for each day 
#and name dump file with DATESTAMP.
#this scipt should be executed as cron job for example every 1 hour
#the script also keeps directories last number of days given in KEEP_LAST_NUMBER_OF_DAYS


REDIS_RDB_SOURCE='/var/lib/redis/dump.rdb' #source to redis dump.rdb file
REDIS_RDB_BACKUP_DESTINATION='/backup' #backup directory
KEEP_LAST_NUMBER_OF_DAYS=7 #keep files for last number of days
DATESTAMP=$(date +"%Y-%m-%d") #used to create separate folder for each day
TIMESTAMP=$(date +"%Y-%m-%d--%Hh%Mm") #used to append this to backup file
COMMPRES_BACKUP_FILE=1 #compress backuped file is 1, otherwise do not compress


###Function declarations##########

#create folder for today if not exist
function createRedisRdbBackupDestinatinDirectory
{
  mkdir -p $REDIS_RDB_BACKUP_DESTINATION/$DATESTAMP
}

#copy redis file to REDIS_RDB_BACKUP_DESTINATION with DATESTAMP in file name
function copyredisRdbFile
{
  cp $REDIS_RDB_SOURCE $REDIS_RDB_BACKUP_DESTINATION/$DATESTAMP/dump-$TIMESTAMP.rdb
  
  #compress and delete origical backup file
  if [ $COMMPRES_BACKUP_FILE = "1" ]; then
     tar czfP $REDIS_RDB_BACKUP_DESTINATION/$DATESTAMP/dump-$TIMESTAMP.tar.gz $REDIS_RDB_BACKUP_DESTINATION/$DATESTAMP/dump-$TIMESTAMP.rdb
     rm $REDIS_RDB_BACKUP_DESTINATION/$DATESTAMP/dump-$TIMESTAMP.rdb
  fi
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