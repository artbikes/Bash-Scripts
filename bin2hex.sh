#!/bin/bash

declare -a stack
BOTTOM=0
CURRENT=0

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
	echo -n "HEX: "
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

echo "BIN: $1"
bin=$1
while : 
do
	if [ "$bin" -le 16 ]
	then
		#echodigit $bin
		push $bin
		break
	fi
	base=$(($bin/16))
	mod=$(($bin%16))
	echodigit $mod
	bin=$base
done

pop

