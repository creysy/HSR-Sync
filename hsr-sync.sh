#!/bin/bash
# Sync HSR Script Folders

## Config
ISLINUX=false
ISMAC=false
ISWiNDOWS=true
USERNAME=kschmidi
#if you have a mac replace username in SERVER_URL
SERVER_URL="//$USERNAME@hsr.ch/root/alg/skripte"
#change the path to wherever you want to sync your files
DESTFOLDER="/home/flo/hsr/sem-3"

# Modules
MODULES[0]="Informatik/Fachbereich/Programmieren_3_C++11"
MODULES[1]="Informatik/Fachbereich/User_Interfaces_1"
MODULES[2]="Informatik/Fachbereich/Software-Engineering_1"
MODULES[3]="Informatik/Fachbereich/Datenbanksysteme_1"
MODULES[4]="Informatik/Fachbereich/Internettechnologien"
MODULES[5]="Kommunikation_Wirtschaft_Recht/Business_und_Recht_1"
MODULES[6]="Mathematik_Naturwissenschaften/Physik_1"
MODULES[7]="Informatik/Fachbereich/Challenge_Projekte_1"


## Const
TEMPEXT=".IAMOLD"
TS="date +%T"
SEP1="==============================================================================="
SEP2="-------------------------------------------------------------------------------"
LOGMSGTYP="BACKUP,COPY,DEL,MISC,MOUNT,NAME1,PROGRESS2,REMOVE,STATS,SYMSAFE"
COLORKEYWORDS="backed up\|deleting"

STOPWATCH=`date +%s`
TMPSTOPWATCH=`date +%s`

echo $SEP1
echo "Mounting skript folder..."
echo $SEP2

if $ISLINUX ; then
	SERVER="/mnt/hsr"
fi
if $ISMAC ; then
	SERVER="/Volumes/skripte"
else
	SERVER="//c206.hsr.ch/skripte"
fi

###
cd $DESTFOLDER

if $ISLINUX ; then
	cmd_output=$(mount $SERVER 2>&1)
fi
if $ISMAC ; then
	mkdir $SERVER
	cmd_output=$(mount -t smbfs $SERVER_URL $SERVER 2>&1)
fi
if $ISWINDOWS ; then
	cmd_output=$(mount.cifs //$SERVER -o username=$USERNAME 2>&1)
	sudo smbmount //$SERVER ~/shares/hsr -o user=$USERNAME,iocharset=utf8,noperm
fi

#removes created folder for the mounting and ends script
if [[ $cmd_output != "" ]] ; then 
	if $ISMAC ; then
		rm -rf $SERVER
	fi
	echo $cmd_output
	echo `$TS` "HSR-Sync DONE!" "took" $(((`date +%s`-STOPWATCH)/60)) "min." $(((`date +%s`-STOPWATCH)%60)) "sec."
	exit 1
fi

echo "Connected! took" $(((`date +%s`-TMPSTOPWATCH)/60)) "min." $(((`date +%s`-TMPSTOPWATCH)%60)) "sec."

echo $SEP1
echo `$TS` "Sync HSR Script Folders.."
for MODULE in ${MODULES[*]} ; do
	echo $SEP2
	echo `$TS` "$MODULE:"
	TMPSTOPWATCH=`date +%s`
	if $ISLINUX ; then
		rsync -rtzuv --backup --suffix=.`date +"%Y-%m-%d_%H-%M"`$TEMPEXT --exclude '*.DS_Store' --exclude '*.DS_STORE' --exclude '*Thumbs.db' --info=$LOGMSGTYP $SERVER/$MODULE/ . | sed -e "s/^$COLORKEYWORDS/\x1b[91m&\x1b[0m/"
	fi
	if $ISMAC ; then
		rsync -rtzuv --backup --suffix=.`date +"%Y-%m-%d_%H-%M"`$TEMPEXT --exclude '*.DS_Store' --exclude '*.DS_STORE' --exclude '*Thumbs.db' $SERVER/$MODULE/ .
	fi
	if $ISWINDOWS ; then
		rsync -rtzuv --backup --suffix=.`date +"%Y-%m-%d_%H-%M"`$TEMPEXT --chmod=ugo=rwx $SERVER$MODULE/ .
	fi
	echo "took" $(((`date +%s`-TMPSTOPWATCH)/60)) "min." $(((`date +%s`-TMPSTOPWATCH)%60)) "sec."
done

echo $SEP1
echo `$TS` "Check for New File Versions.."
find . -type f -name "*$TEMPEXT" -print0 | while read -d $'\0' FILE ; do
	OLDFILE=${FILE%.*}
	BASEFILE=${OLDFILE%.*}
	BASENAME=${BASEFILE##*/}
	EXTENSION=${BASENAME##*.}

	echo `$TS` "New Version of: $BASEFILE"
	mv "$FILE" "$OLDFILE.$EXTENSION"
done

echo $SEP1

echo "Unmount skripte folder"
umount $SERVER

if $ISMAC ; then	
	rm -rf $SERVER
fi

echo $SEP1

echo `$TS` "DONE!" "took" $(((`date +%s`-STOPWATCH)/60)) "min." $(((`date +%s`-STOPWATCH)%60)) "sec."
