#!/usr/bin/env bash

# Gathering files and sha1sums in a variable
FILES_SHASUMS=$(ls| xargs sha1sum)

for i in $(echo "$FILES_SHASUMS"| cut -f3 -d' ')
do
	#Colons surrounding the variable make the shell regognize correctly carriage returns
	MATCHED=$(echo "$FILES_SHASUMS"| fgrep $(sha1sum $i | cut -f1 -d' ') | grep -v $i |cut -f3 -d' ') 

	#Delete already scanned files and update the database
	FILES_SHASUMS=$(echo "$FILES_SHASUMS"| grep -v $i )

	if [ ! -z "$MATCHED" ]
	then
		echo The file $i match with:
		for j in $MATCHED ; do
			echo $j
			#Delete matched files from the database
			FILES_SHASUMS=$(echo "$FILES_SHASUMS"| grep -v $j)
		done
		
	fi
done
