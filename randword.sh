#!/bin/sh

WORDS=/usr/share/dict/words

LINES=`wc -l $WORDS | awk '{ print ($1 + 1) }'`
while :;
do
  clear
  RANDSEED=`date '+%S%M%I'`
  LINE=`cat $WORDS | awk -v COUNT=$LINES -v SEED=$RANDSEED 'BEGIN { srand(SEED); \
  i=int(rand()*COUNT) } FNR==i { print $0 }'`
  echo "";echo "";echo "";echo ""; echo ""
  figlet -c -w 132 -f slant $LINE
  sleep 2
done
