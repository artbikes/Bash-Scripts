#!/bin/bash

declare -a stack
BOTTOM=0
CURRENT=0
verbosity=1
BASE=16

while getopts "b:v" optionName
do
	case "$optionName" in
	b) 	BASE="$OPTARG"
		shift 1
		;;
	v)	verbosity=""
		shift 1
		;;
	esac
done

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
echo
return
}

if [ -z "$verbosity" ]
then
	echo "Base: $BASE"
	echo "BIN: $1"
fi
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

