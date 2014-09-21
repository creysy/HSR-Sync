#!/bin/bash
# Sync HSR Script Folders

## Config
SERVER="/mnt/hsr/"
#SERVER="//c206.hsr.ch/skripte/"
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

# Advanced
COLORKEYWORDS="backed up\|deleted"
EXCLUDEDFILES="*.DS_Store,*Thumbs.db"


## Const
TEMPEXT=".IAMOLD"
TS="date +%T"
SEP1="==============================================================================="
SEP2="-------------------------------------------------------------------------------"
STOPWATCH=`date +%s`
LOGMSGTYP="BACKUP,COPY,DEL,MISC,MOUNT,NAME1,PROGRESS2,REMOVE,SKIP,STATS,SYMSAFE"


###
cd $DESTFOLDER

echo $SEP1
echo `$TS` "Sync HSR Script Folders.."
for MODULE in ${MODULES[*]} ; do
	echo $SEP2
	echo `$TS` "$MODULE:"
	TMPSTOPWATCH=`date +%s`
	rsync -rtzuv --backup --suffix=.`date +"%Y-%m-%d_%H-%M"`$TEMPEXT --exclude={$EXCLUDEDFILES} --info=$LOGMSGTYP $SERVER$MODULE/ . | sed -e "s/^$COLORKEYWORDS/\x1b[91m&\x1b[0m/"
	echo "took" $(((`date +%s`-TMPSTOPWATCH)/60)) "min." $(((`date +%s`-TMPSTOPWATCH)%60)) "sec."
done

echo $SEP1
echo `$TS` "Fix Permissions.."
chmod -R 777 .

echo $SEP1
echo `$TS` "Check for New File Versions.."
find . -type f -iname "*$TEMPEXT" -print0 | while read -d $'\0' FILE ; do
	OLDFILE=${FILE:0:-7}
	BASEFILE=${FILE:0:-24}
	BASENAME=${BASEFILE##*/}
	EXTENSION=${BASENAME##*.}

	echo `$TS` "New Version of: $BASEFILE"
	mv "$FILE" "$OLDFILE.$EXTENSION"
done
echo $SEP1
echo `$TS` "DONE!" "took" $(((`date +%s`-STOPWATCH)/60)) "min." $(((`date +%s`-STOPWATCH)%60)) "sec."
