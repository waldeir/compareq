#!/bin/bash
#compara duas fotos e diz se são a mesma
echo > fotos_iguais.txt

#

getCurrentCursorPosition(){
# based on a script from http://invisible-island.net/xterm/xterm.faq.html
exec < /dev/tty
oldstty=$(stty -g)
stty raw -echo min 0
# on my system, the following line can be replaced by the line below it
echo -en "\033[6n" > /dev/tty
# tput u7 > /dev/tty    # when TERM=xterm (and relatives)
IFS=';' read -r -d R -a pos 
stty $oldstty
# change from one-based to zero based so they work with: tput cup $row $col
row=$((${pos[0]:2} - 1))    # strip off the esc-[
col=$((${pos[1]} - 1))
#echo $row $col

}

cancelProcedure(){
echo Finishing, bitch!
tput cnorm
exit 3
}


barraDeProgresso() {
#clear
tput civis
if [ $TOTALSTEPS -ge $CURRENTSTEP ] 
then
                PROGRESS=$(((100 * $CURRENTSTEP) / $TOTALSTEPS))
 
               
               COLUMNS=$(($(tput cols) - 8)) #save some space to write the percentage progress at the same line of the progressbar
    
               POSITION_PROGRESS=$((($PROGRESS * $COLUMNS) / 100))
 
               tput cup $BARLINE 0 
               echo -n '['
               tput sc
               tput cup $BARLINE $(($COLUMNS + 1))
               echo -n ']' $PROGRESS%         
               tput rc

               for COUNT in $(seq 1 $POSITION_PROGRESS)
               do
                       echo -n \)
               done

               for COUNT in $(seq $POSITION_PROGRESS $(($COLUMNS - 1)) )
               do
                       echo -n ' '
               done

fi

#printf '\n'
#tput cnorm
}

#Inicio

WDIR=.
NUMARCHIVES=$(ls $WDIR | wc -l)
TOTALSTEPS=$(( $NUMARCHIVES*($NUMARCHIVES+1)/2 - $NUMARCHIVES ))
CURRENTSTEP=1

#if you hit control + c execute cancelProcedure function
trap cancelProcedure 2
echo ''

getCurrentCursorPosition
BARLINE=$(( $row  - 1))

l=0
for file in `ls $WDIR`
	do
		Files[$l]=$file
		l=$(( $l + 1 ))
	done
m=0
for i in ${Files[*]}
    do
    for j in ${Files[*]:$m+1}
        do
        diff $i $j>/dev/null 
        if [ $? -eq 0 ] 
            then
                           echo  $i and $j match >> fotos_iguais.txt
                           CURRENTSTEP=$(($CURRENTSTEP + 1)) 
			   barraDeProgresso
        fi
                           CURRENTSTEP=$(($CURRENTSTEP + 1))
			   barraDeProgresso
        done

	m=$(( $m + 1 ))
    done
tput cnorm
echo ''
#echo $CURRENTSTEP $TOTALSTEPS $i 
