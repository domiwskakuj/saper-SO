#!/bin/bash

wypisz(){
clear
echo "aby wykonac ruch wpisz r i adres pola"
echo "aby postawic flage wpisz f i adres pola"
echo "aby usunac flage wpisz u i adres pola"
echo "aby zakonczyc gre wpisz q"
echo
echo "PLANSZA"
echo
echo "  0 1 2 3 4 5 6 7 8 9 pozostalo $((licz_x-licz_f)) min"

for i in $(seq 0 9);
do
echo
col="$i"
for j in $(seq 0 9);
do
temp=${visible[$i,$j]}
if [ "$temp" = "H" ]; then
col="${col} #"
elif [ "$temp" = "F" ]; then
col="${col} ${RED}F${NC}"
elif [ "$temp" != "H" ]; then

if [[ "${background[$i,$j]}" = "0" || "${background[$i,$j]}" = "O" ]]; then
col="${col}  "
else
col="${col} ${PURPLE}${background[$i,$j]}${NC}"
fi

fi
done
echo -e "${col}"
done
echo 
}
test(){
for i in $(seq 0 9);
do
echo
col="$i"
for j in $(seq 0 9);
do

col="${col} ${background[$i,$j]}"

done
echo -e "${col}"
done
}

wystartuj(){
#dookola pola (x,y) powinno byc nic
for i in $(seq 0 9);
do
for j in $(seq 0 9);
do
background[$i,$j]="."
done
done

for i in $(seq 0 9);
do
for j in $(seq 0 9);
do
a=$(($RANDOM % $trudnosc))
if [ $a -eq 0 ]; then
if [[ ( $i -gt $x+1 || $i -lt $x-1 ) || ( $j -gt $y+1 || $j -lt $y-1 ) ]]; then
background[$i,$j]="X"
fi
fi
done
done
#wylosowaly sie flagi
#teraz trzeba opisac
for i in $(seq 0 9);
do
for j in $(seq 0 9);
do

if [ "${background[$i,$j]}" != "X" ]; then
dx=$i
dy=$j
licznik=0
dx=$((dx-1))
if [ "${background[$dx,$dy]}" = "X" ]; then
licznik=$((licznik+1))
fi
dx=$((dx+2))
if [ "${background[$dx,$dy]}" = "X" ]; then
licznik=$((licznik+1))
fi
dx=$((dx-1))
dy=$((dy-1))
if [ "${background[$dx,$dy]}" = "X" ]; then
licznik=$((licznik+1))
fi
dy=$((dy+2))
if [ "${background[$dx,$dy]}" = "X" ]; then
licznik=$((licznik+1))
fi
dx=$((dx-1))
if [ "${background[$dx,$dy]}" = "X" ]; then
licznik=$((licznik+1))
fi
dx=$((dx+2))
if [ "${background[$dx,$dy]}" = "X" ]; then
licznik=$((licznik+1))
fi
dx=$((dx-2))
dy=$((dy-2))
if [ "${background[$dx,$dy]}" = "X" ]; then
licznik=$((licznik+1))
fi
dx=$((dx+2))
if [ "${background[$dx,$dy]}" = "X" ]; then
licznik=$((licznik+1))
fi

background[$i,$j]=$licznik

fi
done
done
a=$x
b=$y
odkryj_otoczenie
win_check
}

win_check(){
local ch=0
licz_f=0
licz_x=0
for i in $(seq 0 9);
do
for j in $(seq 0 9);
do

if [ "${background[$i,$j]}" = "X" ]; then
licz_x=$((licz_x+1))
fi
if [ "${visible[$i,$j]}" = "F" ]; then
licz_f=$((licz_f+1))
elif [ "${visible[$i,$j]}" = "H" ]; then
ch=$((ch+1))
fi

done
done
if [[ $ch -eq 0 && $licz_f -eq $licz_x ]]; then
win=1
fi

}

odkryj_otoczenie()
{
background[$a,$b]="O"
local aa=$a 
local bb=$b

local dx=$((a-1))
local dy=$((b-1))

visible[$a,$b]=" "
dx=$((a-1))
dy=$((b-1))
visible[$dx,$dy]=" "
if [ "${background[$dx,$dy]}" = "0" ]; then
a=$dx
b=$dy
odkryj_otoczenie
a=$aa
b=$bb
fi
dy=$((b+1))
visible[$dx,$dy]=" "
if [ "${background[$dx,$dy]}" = "0" ]; then
a=$dx
b=$dy
odkryj_otoczenie
a=$aa
b=$bb
fi
dy=$b
visible[$dx,$dy]=" "
if [ "${background[$dx,$dy]}" = "0" ]; then
a=$dx
b=$dy
odkryj_otoczenie
a=$aa
b=$bb
fi

dx=$a
dy=$((b-1))
visible[$dx,$dy]=" "
if [ "${background[$dx,$dy]}" = "0" ]; then
a=$dx
b=$dy
odkryj_otoczenie
a=$aa
b=$bb
fi
dy=$((b+1))
visible[$dx,$dy]=" "
if [ "${background[$dx,$dy]}" = "0" ]; then
a=$dx
b=$dy
odkryj_otoczenie
a=$aa
b=$bb
fi

dx=$((a+1))
dy=$((b-1))
visible[$dx,$dy]=" "
if [ "${background[$dx,$dy]}" = "0" ]; then
a=$dx
b=$dy
odkryj_otoczenie
a=$aa
b=$bb
fi
dy=$b
visible[$dx,$dy]=" "
if [ "${background[$dx,$dy]}" = "0" ]; then
a=$dx
b=$dy
odkryj_otoczenie
a=$aa
b=$bb
fi
dy=$((b+1))
visible[$dx,$dy]=" "
if [ "${background[$dx,$dy]}" = "0" ]; then
a=$dx
b=$dy
odkryj_otoczenie
a=$aa
b=$bb
fi


a=$aa
b=$bb
}

dodaj_flage(){
    #na pozycji x y
    visible[$x,$y]="F"
    win_check
if [ $win -eq 1 ]; then
clear
cat winner_saper.txt
echo
q=0
fi
}
usun(){
    visible[$x,$y]="H"
	licz_f=$((licz_f-1))
}

odkryj(){
#na pozycji x y
visible[$x,$y]=" "
if [ "${background[$x,$y]}" = "X" ]; then
#koniec gry
clear
cat game_over_saper.txt
echo 
q=0
fi

if [[ "${visible[$x,$y]}" = " " && "${background[$x,$y]}" = "0" ]]; then
a=$x
b=$y
odkryj_otoczenie
fi

win_check
if [ $win -eq 1 ]; then
clear
cat winner_saper.txt
echo
q=0
fi
}
pomoc(){
    echo "pomoc"
}
wersja(){
    echo "wersja 1.3"
}
t=0;
trudnosc=4
q=1
while getopts hvt: OPT; do

case $OPT in
h) pomoc
q=0;;
v) wersja
q=0;;
t) t=$OPTARG
if [ $t -eq 1 ]; then
trudnosc=14
elif [ $t -eq 2 ]; then
trudnosc=9
elif [ $t -eq 3 ]; then
trudnosc=4
elif [ $t -eq 4 ]; then
trudnosc=2
fi;;
esac
done

declare -A visible=()
declare -A background=();
RED='\033[1;33m'
PURPLE='\033[1;35m'
NC='\033[0m' # No Color
win=0
licz_f=0
licz_x=0

for i in $(seq 0 9);
do
for j in $(seq 0 9);
do
visible[$i,$j]="H"
done

done


zaczete=0

while [ $q -gt 0 ];
do

wypisz

read polecenie
first=$( echo $polecenie | cut -d' ' -f1 )
if [[ "$first" == "r" && $zaczete -eq 0 ]]; then
x=$( echo $polecenie | cut -d' ' -f2 )
y=$( echo $polecenie | cut -d' ' -f3 )
wystartuj
zaczete=1
elif [[ "$first" == "r" && $zaczete -eq 1 ]]; then
x=$( echo $polecenie | cut -d' ' -f2 )
y=$( echo $polecenie | cut -d' ' -f3 )
odkryj
zaczete=1
elif [ "$first" == "q" ]; then
q=0
elif [ "$first" == "f" ]; then
x=$( echo $polecenie | cut -d' ' -f2 )
y=$( echo $polecenie | cut -d' ' -f3 )
dodaj_flage
elif [ "$first" == "u" ]; then
x=$( echo $polecenie | cut -d' ' -f2 )
y=$( echo $polecenie | cut -d' ' -f3 )
usun
else
echo "nie rozpoznano polecenia"
fi

done
