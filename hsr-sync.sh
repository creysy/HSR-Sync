#!/bin/bash
# Sync HSR Script Folders

## Config
ISLINUX=true
DESTFOLDER="/home/flo/hsr/sem_3"

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
STOPWATCH=`date +%s`
LOGMSGTYP="BACKUP,COPY,DEL,MISC,MOUNT,NAME1,PROGRESS2,REMOVE,STATS,SYMSAFE"
COLORKEYWORDS="backed up\|deleting"

if $ISLINUX ; then
	SERVER="/mnt/hsr"
else
	SERVER="//c206.hsr.ch/skripte"
fi


###
cd $DESTFOLDER

if $ISLINUX ; then
	sudo mount $SERVER
fi

echo $SEP1
echo `$TS` "Sync HSR Script Folders.."
for MODULE in ${MODULES[*]} ; do
	echo $SEP2
	echo `$TS` "$MODULE:"
	TMPSTOPWATCH=`date +%s`
	if $ISLINUX ; then
		rsync -rtzuv --backup --suffix=.`date +"%Y-%m-%d_%H-%M"`$TEMPEXT --exclude '*.DS_Store' --exclude '*.DS_STORE' --exclude '*Thumbs.db' --info=$LOGMSGTYP $SERVER/$MODULE/ . | sed -e "s/^$COLORKEYWORDS/\x1b[91m&\x1b[0m/"
	else
		rsync -rtzuv --backup --suffix=.`date +"%Y-%m-%d_%H-%M"`$TEMPEXT --exclude '*.DS_Store' --exclude '*.DS_STORE' --exclude '*Thumbs.db' $SERVER/$MODULE/ .
	fi
	echo "took" $(((`date +%s`-TMPSTOPWATCH)/60)) "min." $(((`date +%s`-TMPSTOPWATCH)%60)) "sec."
done

echo $SEP1
echo `$TS` "Check for New File Versions.."
find . -type f -name "*$TEMPEXT" -print0 | while read -d $'\0' FILE ; do
	OLDFILE=${FILE:0:-7}
	BASEFILE=${FILE:0:-24}
	BASENAME=${BASEFILE##*/}
	EXTENSION=${BASENAME##*.}

	echo `$TS` "New Version of: $BASEFILE"
	mv "$FILE" "$OLDFILE.$EXTENSION"
done
echo $SEP1

echo `$TS` "DONE!" "took" $(((`date +%s`-STOPWATCH)/60)) "min." $(((`date +%s`-STOPWATCH)%60)) "sec."
