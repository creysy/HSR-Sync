#!/bin/bash
# Sync HSR Script Folders

# Config
SERVER="/mnt/hsr/"
#SERVER="//c206.hsr.ch/skripte/"
DESTFOLDER="/home/flo/hsr/sem_3"

MODULES[0]="Informatik/Fachbereich/Programmieren_3_C++11"
MODULES[1]="Informatik/Fachbereich/User_Interfaces_1"
MODULES[2]="Informatik/Fachbereich/Software-Engineering_1"
MODULES[3]="Informatik/Fachbereich/Datenbanksysteme_1"
MODULES[4]="Informatik/Fachbereich/Internettechnologien"
MODULES[5]="Kommunikation_Wirtschaft_Recht/Business_und_Recht_1"
MODULES[6]="Mathematik_Naturwissenschaften/Physik_1"
MODULES[7]="Informatik/Fachbereich/Challenge_Projekte_1"


# Const
TEMPEXT=".IAMOLD"
TS="date +%T"
SEP1="==============================================================================="
SEP2="-------------------------------------------------------------------------------"
STOPWATCH=`date +%s`

cd $DESTFOLDER

echo $SEP1
echo `$TS` "Sync HSR Script Folders.."
for MODULE in ${MODULES[*]} ; do
	echo $SEP2
	echo `$TS` "$MODULE:"
	TMPSTOPWATCH=`date +%s`
	rsync -rtzuv --backup --suffix=.`date +"%Y-%m-%d_%H-%M"`$TEMPEXT --exclude "*.DS_Store" --exclude "*Thumbs.db" --chmod=ugo=rwx $SERVER$MODULE/ .
	echo "took" $(((`date +%s`-TMPSTOPWATCH)/60)) "min." $(((`date +%s`-TMPSTOPWATCH)%60)) "sec."
done

echo $SEP1
echo `$TS` "Fix Permissions.."
chmod -R 777 .

exit 0

echo $SEP1
echo `$TS` "Check for New File Versions.."
for FILE in `find . -type f -iname *$TEMPEXT` ; do
	FILENAME=${FILE%.*}
	TS=${FILE##*.}
	BASEFILENAME=${FILENAME%.*}
	BASEFILENAMENOEXT=${BASEFILENAME##*.}
	EXTENSION=${BASEFILENAME##*.}
	echo $SEP2
	echo `$DATE` "New Version of: $BASEFILENAME"
	mv "$FILE" "$BASEFILENAMENOEXT.$TS.$EXTENSION"
done
echo $SEP1
echo `$TS` "DONE!" "took" $(((`date +%s`-STOPWATCH)/60)) "min." $(((`date +%s`-STOPWATCH)%60)) "sec."

read

