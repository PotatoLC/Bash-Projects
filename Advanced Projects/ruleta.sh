#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


trap ctrl_c INT
#tput civis

function ctrl_c(){
	echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
	tput cnorm
	exit 1
}

function helpPanel(){
	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso${endColour} ${purpleColour}$0${endColour}\n"
	echo -e "\t${blueColour}-m)${endColour} ${grayColour}Indicar dinero con el que se desea jugar${endColour}"
	echo -e "\t${blueColour}-t)${endColour} ${grayColour}Indicar técnica con la que se desea jugar${endColour} ${blueColour}(${endColour}${purpleColour}martingala${endColour}${blueColour}/${endColour}${purpleColour}inverseLabrouchere${endColour}${blueColour})${endColour}\n"
	tput cnorm
	exit 1
}

function even_martingala(){
	if [ "$(($random_number % 2))" -eq 0 ]; then
		if [ $random_number -ne 0 ]; then
#			echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha salido el número${endColour} ${turquoiseColour}${random_number}${endColour} ${grayColour}que es${endColour} ${yellowColour}par${endColour}"
			reward=$(($initial_bet*2))
			money=$(($money+$reward))
#			echo -e "${yellowColour}[+]${endColour} ${grayColour}¡Ganas${endColour} ${turquoiseColour}\$$reward${endColour}${grayColour}!, tu saldo actual es de${endColour} ${turquoiseColour}\$$money${endColour}\n"
			initial_bet=$backup_bet
			bad_plays=""
			bad_play_counter=0
		else 
#			echo -e "${greenColour}[+]${endColour} ${grayColour}Ha salido el${endColour} ${greenColour}0${endColour}"
			initial_bet=$((initial_bet*2))
			bad_plays+="$random_number "
			let bad_play_counter+=1
#			echo -e "${redColour}[!]${endColour} ${grayColour}¡Pierdes!, tu saldo actual es de${endColour} ${turquoiseColour}\$$money\n${endColour}"
		fi
	else
#		echo -e "${redColour}[+]${endColour} ${grayColour}Ha salido número${endColour} ${turquoiseColour}$random_number${endColour} ${grayColour}que es${endColour} ${redColour}impar${endColour}"
		initial_bet=$((initial_bet*2))
		bad_plays+="$random_number "
		let bad_play_counter+=1
#		echo -e "${redColour}[+]${endColour} ${grayColour}¡Pierdes!, tu saldo actual es de${endColour} ${turquoiseColour}\$$money\n${endColour}"
	fi
}

function odd_martingala(){ #impar
	if [ "$(($random_number % 2))" -eq 0 ]; then
#		echo -e "${redColour}[+]${endColour} ${grayColour}Ha salido número par${endColour} ${redColour} $random_number ${endColour}"
		initial_bet=$((initial_bet*2))
		bad_plays+="$random_number "
		let bad_play_counter+=1
#		echo -e "${redColour}[+]${endColour} ${grayColour}¡Pierdes!, tu saldo actual es de${endColour} ${turquoiseColour}\$$money\n${endColour}"	
	else
#		echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha salido el número${endColour} ${turquoiseColour}${random_number}${endColour} ${grayColour}que es${endColour} ${yellowColour}impar${endColour}"
		reward=$(($initial_bet*2))
		money=$(($money+$reward))
#		echo -e "${yellowColour}[+]${endColour} ${grayColour}¡Ganas${endColour} ${turquoiseColour}\$$reward${endColour}${grayColour}!, tu saldo actual es de${endColour} ${turquoiseColour}\$$money${endColour}\n"
		initial_bet=$backup_bet
		bad_plays=""
		bad_play_counter=0
	fi

}

function martingala_alert(){
	echo -e "\n${redColour}[!] Aviso${endColour}"
	echo -e "\n\t${greenColour}[-]${endColour} ${grayColour}Debes especificar cuál es tu saldo inicial${endColour}"
	echo -e "\t${greenColour}[-]${endColour} ${grayColour}Tu apuesta debe ser menor al dinero que tienes actualmente${endColour}"
	echo -e "\t${greenColour}[-]${endColour} ${grayColour}Debes especificar si apostar a par o impar${endColour}"
	tput cnorm
}

function martingala(){
	echo -e "\n${yellowColour}[!]${endColour} ${grayColour}Dinero actual${endColour} ${purpleColour}\$$money${endColour}\n"
	echo -en "${blueColour}[+]${endColour} ${grayColour}¿Cuánto dinero deseas apostar? -->${endColour}  ${purpleColour}\$" && read initial_bet
	echo -en "${blueColour}[+]${endColour} ${grayColour}¿A qué deseas apostar continuamente? (par/impar) -->${endColour}   ${purpleColour}" && read  even_odd
	
	tput civis
	clear
	backup_bet=$initial_bet
	play_counter=0
	bad_plays="[ "
	bad_play_counter=0

	if [ $initial_bet -gt 0 ] && [ $initial_bet -le $money ] && [ "$even_odd" == "par" ] || [ "$even_odd" == "impar" ]; then 
		echo -e "\n${yellowColour}[!]${endColour} ${grayColour}Vamos a jugar con una cantidad inicial de${endColour}${purpleColour} \$$initial_bet${endColour}${grayColour}, apostando a números${endColour}${purpleColour} $even_odd${endColour}${grayColour}.${endColour}\n"

		while true; do 
			money=$(($money-$initial_bet))
#			echo -e "${blueColour}[+]${endColour} ${grayColour}Acabas de apostar${endColour} ${turquoiseColour}\$$initial_bet${endColour}${grayColour} y te quedan${endColour} ${turquoiseColour}\$$money${endColour}\n"
			random_number="$((RANDOM % 37))"
			
			if [ $money -ge 0 ]; then

				if [ "$even_odd" == "par" ]; then 
	#				sleep 1	
					even_martingala
				elif [ "$even_odd" == "impar" ]; then
					odd_martingala
				else
					martingala_alert
				fi
			else
				echo -e "\n${redColour}[!] Te has quedado sin dinero ${endColour}"
				echo -e "\n\n${yellowColour}[*]${endColour} ${grayColour}Ha habido un total de${endColour} ${greenColour}$play_counter${endColour} ${grayColour}jugadas${endColour}"
				echo -e "${yellowColour}[+]${endColour} ${grayColour}Se van a representar las malas jugadas consecutivas que has tenido (${endColour}${redColour}$bad_play_counter${endColour}${grayColour}) ---> ${greenColour}$bad_plays${endColour}"
				tput cnorm
				exit 0 
			fi
		let play_counter+=1
		done
		tput cnorm
	else
		martingala_alert
	fi
}

function inverseLabrouchere(){
	echo -e "\n${yellowColour}[!]${endColour} ${grayColour}Dinero actual${endColour} ${purpleColour}\$$money${endColour}\n"
	echo -en "${blueColour}[+]${endColour} ${grayColour}¿A qué deseas apostar continuamente? (par/impar) -->${endColour}   ${purpleColour}" && read  even_odd

	declare -a mySequence=(1 2 3 4)
	
	bet=$((${mySequence[0]} + ${mySequence[-1]}))
	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Comenzamos con la secuencia [${endColour}${greenColour} ${mySequence[@]} ${endColour}${grayColour}]${endColour}"

	total_plays=0
	bet_renew=$(($money + ($money/2))) #Almacena la cantidad que una vez alcanzada renovamos nuestra secuencia a [1 2 3 4]
	echo -e "[+] El tope establecido para renovar la secuencia está pasado \$$bet_renew"
	tput civis
	
	while true; do 
		let total_plays+=1
		echo -e "${blueColour}[+]${endColour} ${grayColour}Comenzamos apostando ${endColour}${yellowColour}\$$bet${endColour}"
		let money-=$bet
		echo -e "${blueColour}[+]${endColour} ${grayColour}Saldo actual${endColour} ${purpleColour}\$$money${endColour}"
		sleep 1
		random_number=$((RANDOM % 7)) 
#		echo -e "\n${yellowColour}[+]${endColour} ${greyColour}Ha salido el número${endColour} ${blueColour}$random_number${endColour}"
		
		if [ "$money" -ge 0 ]; then

			if [ "$even_odd" == "par" ]; then 
				if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then

					echo -e "${greenColour}\n[+]${endColour} ${grayColour}Ha salido número par (${endColour}${blueColour}$random_number${endColour}${grayColour}), ¡ganas!${endColour}"
					reward=$(($bet*2))
					let money+=$reward
					echo -e "${blueColour}[+]${endColour}${grayColour} Tienes ${endColour}${turquoiseColour}\$$money${endColour}"
					mySequence+=($bet)
					mySequence=(${mySequence[@]})	
					if [ "${#mySequence[@]}" -ne 1 ] && [ "${#mySequence[@]}" -ne 0 ]; then
						bet=$((${mySequence[0]} + ${mySequence[-1]}))
					elif [ "${#mySequence[@]}" -eq 1 ]; then
						bet=${mySequence[0]}
					else
						mySequence=(1 2 3 4)
						echo -e "${redColour}[!]${endColour}${grayColour} Hemos perdido nuestra secuencia, la restableceremos a [${endColour}${greenColour} ${mySequence[@]} ${endColour}${grayColour}]${endColour}"
						bet=$((${mySequence[0]} + ${mySequence[-1]}))	
					fi

					echo -e "${blueColour}[+]${endColour}${grayColour} Nueva secuencia --> [ ${endColour}${greenColour}${mySequence[@]} ${endColour}${grayColour}]${endColour}"
				
				
				elif [ "$((random_number % 2 ))" -eq 1 ] || [ "$random_number" -eq 0 ]; then
					if [ "$random_number" -eq 0 ]; then 
						echo -e "${redColour}\n[+]${endColour} ${grayColour}Ha salido el ${endColour}${blueColour}$random_number${endColour}${grayColour}, ¡pierdes!${endColour}"
					else 
						echo -e "${redColour}\n[+]${endColour} ${grayColour}Ha salido número impar (${endColour}${blueColour}$random_number${endColour}${grayColour}), ¡pierdes!${endColour}"
			
					fi
			
					echo -e "${redColour}[+]${endColour}${grayColour} Tienes${endColour} ${turquoiseColour}\$$money${endColour}"
					unset mySequence[0]; unset mySequence[-1] 2>/dev/null
					mySequence=(${mySequence[@]})
					if [ "${#mySequence[@]}" -ne 1 ] && [ "${#mySequence[@]}" -ne 0 ]; then 
						bet=$((${mySequence[0]} + ${mySequence[-1]}))
						echo -e "${redColour}[+]${endColour}${grayColour} Nueva secuencia --> [${endColour} ${greenColour}${mySequence[@]}${endColour}${grayColour} ]$endColour"
					elif [ "${#mySequence[@]}" -eq 1 ]; then
						bet=${mySequence[0]}
						echo -e "${redColour}[+]${endColour}${grayColour} Nueva secuencia --> [${endColour} ${greenColour}${mySequence[@]}${endColour}${grayColour} ]$endColour"
					else
						mySequence=(1 2 3 4)
						bet=$((${mySequence[0]} + ${mySequence[-1]}))
						echo -e "${redColour}[!]${endColour}${grayColour} Hemos perdido nuestra secuencia, la restableceremos a [${endColour}${greenColour} ${mySequence[@]} ${endColour}${grayColour}]${endColour}"
					fi
				if [ $money -gt $bet_renew ]; then 
					bet_renew+=$(($money + ($money/2)))
					echo -e "[+] Nuevo limite para restablecer la secuencua es $bet_renew"
				fi

				fi
			fi
	else
		echo -e "\n\n${redColour}[!] Te has quedado sin dinero${endColour}"
		echo -e "${yellowColour}[*]${endColour}${grayColour} Ha habido un total de ${endColour}${greenColour}$total_plays${endColour}${grayColour} jugadas${endColour}\n"
		tput cnorm
		exit 0
	fi

	done
	tput cnorm
}


while getopts "m:t:h" arg; do 
	case $arg in 
		h) helpPanel;;
		m) money=$OPTARG;;
		t) technique=$OPTARG;;
	esac
done

if [ $money -gt 0 ] && [ $technique ]; then 
	if [ "$technique" == "martingala" ]; then
		martingala
	elif [ "$technique" == "inverseLabrouchere" ]; then 
		inverseLabrouchere
	else 
		echo -e "\n${redColour}[!] La técnica $technique no existe${endColour}"
		helpPanel
	fi
else 
	helpPanel
fi 
