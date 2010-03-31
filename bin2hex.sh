#!/bin/bash

#set -x

declare -a stack
BOTTOM=0
CURRENT=0
verbosity=1
ndx=0
BASE=16
ADDRESS=""

while getopts "b:vd:" optionName
do
	case "$optionName" in
	b) 	BASE="$OPTARG"
		;;
	v)	verbosity=""
		;;
	d)	ADDRESS=$OPTARG
		;;
	esac
done
shift $(($OPTIND - 1))

echodigit(){
	case $1 in
	[0-9])
	hex=$1
	;;
	10)
	hex=A
	;;
	11)
	hex=B
	;;
	12)
	hex=C
	;;
	13)
	hex=D
	;;
	14)
	hex=E
	;;
	15)
	hex=F
	;;
	16)
	hex=10
	;;
	esac
	push $hex
}

push() 
{
# Nothing to push
	if [ -z "$1" ]
	then
		return
	fi

	stack[$CURRENT]=$1
	let CURRENT+=1
	return
}

pop()
{

	if [ -z "$verbosity" ]
	then
		echo -n "HEX: "
	fi
	while [ "$CURRENT" -ge "$BOTTOM" ]
	do
			data=
			data=${stack[$CURRENT]}
			echo -n $data
			let CURRENT-=1
	done
CURRENT=0
BOTTOM=0
stack=()
return
}
baser(){
	bin=$1
	while : 
	do
		if (( "$bin" < "$BASE" )) 
		then
			echodigit $bin
			break
		fi
		root=$(($bin/$BASE))
		mod=$(($bin%$BASE))
		echodigit $mod
		bin=$root
	done

pop
}


if [ -z "$verbosity" ]
then
	echo "Base: $BASE"
	echo "BIN: $1"
fi
bin=$1
if [ -n "$ADDRESS" ]
then
	seg1=`echo $ADDRESS |  sed -n 's/^\(.*\)\.\(.*\)\.\(.*\)\.\(.*\)/\1/p'`
	seg2=`echo $ADDRESS |  sed -n 's/^\(.*\)\.\(.*\)\.\(.*\)\.\(.*\)/\2/p'`
	seg3=`echo $ADDRESS |  sed -n 's/^\(.*\)\.\(.*\)\.\(.*\)\.\(.*\)/\3/p'`
	seg4=`echo $ADDRESS |  sed -n 's/^\(.*\)\.\(.*\)\.\(.*\)\.\(.*\)/\4/p'`
	for i in $seg1 $seg2 $seg3 $seg4
	do
		echo -n "0x"
		baser $i
		let ndx+=1
		if [ "$ndx" -le 3 ]
		then
			echo -n "."
		fi
	done
	echo
	exit
fi

baser $bin
echo
