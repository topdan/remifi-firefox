#! /bin/bash

# $1 is the application
# $2 is the script directory
# $3 is the pow root directory
# $@ is the file to run and other arguments

APP=$1
shift
RUNDIR=$1
shift
ROOT=$1
shift
FILE=$@

if [ "$APP$FILE$RUNDIR$ROOT" = "" ];then
	exit 1
fi

echo `date +%Y-%m-%d\ %T` $APP $FILE $RUNDIR $ROOT >> "$ROOT/pow/log/access.txt"

cd "$ROOT/pow/data"

#if [ ! -e pipe ]; then
#	mkfifo pipe
#fi

export REDIRECT_STATUS="200"
export SCRIPT_NAME="$FILE"
export SCRIPT_FILENAME="$RUNDIR/$FILE" 

cd "$RUNDIR"

#echo "$POST_STRING" | "$APP" "$FILE" > "$ROOT/pow/data/pipe" 2>> "$ROOT/pow/log/error.txt" &
echo "$POST_STRING" | "$APP" "$FILE" > "$ROOT/pow/data/powpipe.txt" 2>> "$ROOT/pow/log/error.txt"
export EXIT_VALUE=$?
exit $EXIT_VALUE
