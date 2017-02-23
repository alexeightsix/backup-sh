#!/bin/bash
sleep 1

echo "OK: STARTING BACKUP."

sleep 0.5

echo "OK: setting variables"

timestamp=`date +%Y-%m-%d:%H:%M:%S`

mysql_username=""
mysql_password=""
mysql_database=""
mysql_hostname=""

project_directory="/your/project/directory"
backups_directory="/your/backups/directory"
temp_directory="/your/temp/directory"

database_file_name=$mysql_database-$timestamp.sql
data_file_name=www-data-$mysql_database-$timestamp.zip

sleep 1

echo "OK: CHECKING DIRECTORY PATHS"

if [ ! -d $project_directory ]; then

        echo "ERROR: project directory doesn't exist" 
        exit

fi


if [ ! -d $mysql_backups_directory ]; then

	echo "ERROR: mysql backups directory doesn't exist" 
	exit

fi

sleep 1

echo "OK: mysql backups directory set to:" $mysql_backups_directory

if [ ! -d $data_backups_directory ]; then

        echo "ERROR: data backups directory doesn't exist" 
        exit

fi

sleep 1

echo "OK: data backups directory set to:" $data_backups_directory

if [ ! -d $temp_directory ]; then

  	echo "ERROR: temp directory doesn't exist"
	exit

fi

sleep 1

echo "OK: temp directory set to:" $temp_directory

slep 1

echo "OK: clearing temp directory"

rm -rf $temp_directory/*

sleep 1

echo "OK: DUMPING MYSQL DATABASE INTO TEMP DIRECTORY"

mysqldump --user=$mysql_username --password=$mysql_password --host=$mysql_hostname $mysql_database > $temp_directory/$database_file_name

if [ ! -f $temp_directory/$database_file_name ]; then

	echo "ERROR: MYSQL DUMP NOT FOUND"
	exit;

fi

sleep 1

echo "OK: DATABASE BACKED UP"

tar -czvf $temp_directory/$mysql_database-www-data.tar.gz $project_directory

if [ ! -f $temp_directory/$mysql_database-www-data.tar.gz ]; then

        echo "ERROR: TAR FILE NOT FOUND"
        exit;

fi

sleep 1

tar -czvf $temp_directory/$mysql_database-www-data-mysql-dump-$timestamp.tar.gz $temp_directory

if [ ! -f $temp_directory/$mysql_database-www-data-mysql-dump-$timestamp.tar.gz ]; then

        echo "ERROR: DB+MYSQL TAR FILE NOT FOUND"
        exit;

fi

sleep 1

mv $temp_directory/$mysql_database-www-data-mysql-dump-$timestamp.tar.gz $backups_directory 

if [ ! -f $backups_directory/$mysql_database-www-data-mysql-dump-$timestamp.tar.gz ]; then

        echo "ERROR: DB+MYSQL TAR FILE NOT FOUND IN BACKUPS FOLDER"
        exit;

fi

sleep 1

echo "OK: BACKUP CREATED"

sleep 1

echo "OK:  CLEARING TEMP DIRECTORY"

rm -rf $temp_directory/*

number_of_backups=$(ls -l $backups_directory | egrep -c '^-')

sleep 1

if (($number_of_backups > 7)); then

	oldest_file=$(ls $backups_directory -tr | head -n 1)

	echo "DELETING:" $backups_directory/$oldest_file

	rm $backups_directory/$oldest_file

	if [ ! -f $backups_directory/$oldest_file ]; then

        	echo "OK: DELETED" $backups_directory/$oldest_file

	fi

fi

echo "SUCCESS: BACKUP COMPLETE"

exit
