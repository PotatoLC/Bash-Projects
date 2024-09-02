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

# Ctrl + C 
trap ctrl_c INT

function ctrl_c(){
	echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n\n"
	exit 1
	tput cnorm
}

function helpPanel(){
	echo -e "\n ${yellowColour}[+]"${endColour}" "${grayColour}"Uso: ${endColour}"
	echo -e "\t ${purpleColour}u)${endColour} ${grayColour}Actualizar Base de Datos${endColour}"
	echo -e "\t ${purpleColour}m)${endColour} ${grayColour}Buscar por máquina${endColour}"
	echo -e "\t ${purpleColour}i)${endColour} ${grayColour}Buscar por dirección ip${endColour}"
	echo -e "\t ${purpleColour}d)${endColour} ${grayColour}Buscar por dificultad${endColour}"		
	echo -e "\t ${purpleColour}o)${endColour} ${grayColour}Buscar por sistema operativo${endColour}"	
	echo -e "\t ${purpleColour}s)${endColour} ${grayColour}Buscar por skills${endColour}"	
	echo -e "\t ${purpleColour}y)${endColour} ${grayColour}Obtener enlace de resolución de máquina${endColour}"
	echo -e "\t ${purpleColour}h)${endColour} ${grayColour}Panel de ayuda${endColour}\n"
}

function updateFiles() {
	if [ ! -f bundle.js ]; then	
		tput civis	
		echo -e "\n\t${yellowColour}[+]${endColour} ${grayColour}Descargando archivos necesarios...${endColour}"
		curl -s $main_url > bundle.js
		js-beautify bundle.js | sponge bundle.js
		echo -e "\t${yellowColour}[+]${endColour} ${grayColour}Todo se ha descargado exitosamente\n${endColour}"
		tput cnorm
	else
		tput civis
		echo -e "${yellowColour}\n\t[+]${endColour} ${grayColour}Comprobando si hay actualizaciones pendientes${endColour}"	
		sleep 2
		curl -s $main_url > bundle_tmp.js
		js-beautify bundle_tmp.js | sponge bundle_tmp.js
		md5_tempValue=$(md5sum bundle_tmp.js | awk '{print $1}')
		md5_originalValue=$(md5sum bundle.js | awk '{print $1}')

		if [ $md5_tempValue == $md5_originalValue ]; then 
			echo -e "\t${yellowColour}[+]${endColour} ${grayColour}Tienes la base de datos actualizada${endColour}"
			rm bundle_tmp.js
		else 
			echo -e "\t${yellowColour}[+]${endColour} ${grayColour}Se ha encontrado una actualización, se está actualizando la base de datos${endColour}"
			sleep 2
			rm bundle.js && mv bundle_tmp.js bundle.js
		fi 
		tput cnorm
	fi	       
}

function searchMachine() {
	machineName="$1"
	checker="$(cat bundle.js| awk "/name: \"$machineName\"/, /resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ","  | sed 's/^ *//')"
	if [ "$checker"	]; then 	
		echo -e "\n${yellowColour}[!]${endColour} ${grayColour}Listando las propiedades de la máquina${endColour} ${blueColour}$machineName${endColour}${grayColour}:${endColour}\n"
		sleep 1
		cat bundle.js| awk "/name: \"$machineName\"/, /resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ","  | sed 's/^ *//'
	else
		sleep 2
		echo -e "\n${redColour}[!]${endColour} ${grayColour}No existe la máquina${endColour} ${redColour}$machineName${endColour}\n"
	fi
}

function searchIp() {
	ipAddress="$1"	
	machineName="$(cat bundle.js| grep "ip: \"$ipAddress\"" -B 3 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
	
	if [ "$machineName" ]; then		
		echo -e "\n\n${yellowColour}[!]${endColour} ${grayColour}Buscando por la IP${endColour} ${blueColour}$ipAddress${endColour}${grayColour}:${endColour}"
		sleep 1		
		echo -e "\n${purpleColour}[+]${endColour} ${grayColour}La máquina correspondiente para la ip${endColour} ${blueColour} $ipAddress ${endColour} ${grayColour}es${endColour} ${blueColour} $machineName ${endColour}\n"	
		#searchMachine $machine
	else 
		sleep 2	
		echo -e "\n${redColour}[+]${endColour} ${grayColour}La máquina con la ip${endColour} ${redColour} $ipAddress ${endColour} ${grayColour}no existe${endColour}\n" 
	fi 
}

function youtubeLink(){
	machine_name="$1"	
	checker="$(cat bundle.js| awk "/name: \"$machine_name\"/, /resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ","  | sed 's/^*//' | grep youtube | awk 'NF{print $NF}')"
	if [ "$checker" ]; then 	
		echo -e "\n\n${yellowColour}[!]${endColour} ${grayColour}Buscando el link para la máquina${endColour} ${blueColour}$machine_name${endColour}"
		sleep 1		
		echo -e "\n${purpleColour}[+]${endColour} ${grayColour}El link para resolución de máquina${endColour} ${blueColour} $machine_name ${endColour} ${grayColour}es${endColour} ${blueColour} $checker ${endColour}\n"
	else 
		sleep 2	
		echo -e "\n${redColour}[+]${endColour} ${grayColour}La máquina${endColour} ${redColour} $machine_name ${endColour} ${grayColour}no existe${endColour}\n" 
	fi
}

function difficultyMachine(){
	difficulty="$1"
	checker="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 -i | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
	if [ "$checker" ]; then 	
		echo -e "\n\n${yellowColour}[!]${endColour} ${grayColour}Buscando por la dificultad${endColour} ${blueColour}$difficulty${endColour} ${grayColour}:${endColour}\n"
		sleep 1 
		cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 -i | grep "name" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
	else 
		sleep 2
		echo -e "\n${redColour}[+]${endColour} ${grayColour}La dificultad${endColour} ${redColour} $difficulty ${endColour} ${grayColour}no existe${endColour}\n" 
	fi 
}

function getOS(){
	os="$1"
	checker="$(cat bundle.js | grep "so: \"$os\"" -B 5 -i | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
	if [ "$checker" ]; then 		
		echo -e "\n\n${yellowColour}[!]${endColour} ${grayColour}Buscando máquinas${endColour} ${blueColour}$os${endColour} ${grayColour}:${endColour}\n"
		sleep 1
		cat bundle.js | grep "so: \"$os\"" -B 5 -i | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
	else 
		sleep 2
		echo -e "\n${redColour}[+]${endColour} ${grayColour}NO existen máquinas con el sistema operativo${endColour} ${redColour} $os ${endColour}"
	fi 
}

function get_OS_Difficulty(){
	difficulty="$1"
	os="$2"
	checker="$(cat bundle.js | grep "so: \"$os\"" -C 4 -i | grep "dificultad: \"$difficulty\"" -B 5 -i | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
	if [ "$checker" ]; then
		echo -e "\n\n${yellowColour}[!]${endColour} ${grayColour}Buscando máquinas${endColour} ${blueColour}$os${endColour} ${grayColour}con dificultad${endColour} ${blueColour}$difficulty${endColour}\n"
		sleep 1 
		cat bundle.js | grep "so: \"$os\"" -C 4 -i | grep "dificultad: \"$difficulty\"" -B 5 -i | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
	else
		sleep 2
		echo -e "\n\n${redColour}[!]${endColour} ${grayColour}No hemos encontrado máquinas${endColour} ${redColour}$os${endColour} ${grayColour}con dificultad${endColour} ${redColour}$difficulty${endColour}\n"

	fi
}

function getSkills(){
	skills="$1"
	checker="$(cat bundle.js | grep "skills: " -B 6 | grep "$skills" -i -B 6 | grep "name: " | tr -d ',' | tr -d '"')"
	if [ "$checker" ]; then 	
		echo -e "\n\n${yellowColour}[!]${endColour} ${grayColour}Buscando máquinas con las skills${endColour} ${blueColour}$skills${endColour}${grayColour}:${endColour}\n"
		sleep 1
		cat bundle.js | grep "skills: " -B 6 | grep "$skills" -i -B 6 | grep "name: " | tr -d ',' | tr -d '"' | awk 'NF{print $NF}' | column
	else
		sleep 2
		echo -e "\n\n${redColour}[!]${endColour} ${grayColour}No hemos encontrado máquinas con la skill${endColour} ${redColour} $skills${endColour}\n"
	fi
}

#Variables globales
main_url="https://htbmachines.github.io/bundle.js"

#Indicadores 
declare -i parameter_counter=0
declare -i optionOS=0
declare -i optionDifficulty=0


while getopts "m:hui:y:d:o:s:" arg; do 
	case $arg in 
		h) ;;
		m) machine_name="$OPTARG"; let parameter_counter+=1;;
		u) let parameter_counter+=2;;
		i) ip_Address="$OPTARG"; let parameter_counter+=3;;
		y) machine_name="$OPTARG"; let parameter_counter+=4;;
		d) difficulty="$OPTARG"; optionDifficulty=1; let parameter_counter+=5;; 
		o) os="$OPTARG"; optionOS=1; let parameter_counter+=6;;
		s) skills="$OPTARG"; let parameter_counter+=7;;

	esac
done 



if [ $parameter_counter -eq 1 ]; then 
	searchMachine "$machine_name"
elif [ $parameter_counter -eq 2 ]; then
	updateFiles
elif [ $parameter_counter -eq 3 ]; then 
	searchIp $ip_Address
elif [ $parameter_counter -eq 4 ]; then
	youtubeLink $machine_name
elif [ $parameter_counter -eq 5 ]; then 
	difficultyMachine $difficulty
elif [ $parameter_counter -eq 6 ]; then 
	getOS $os
elif [ $optionDifficulty -eq 1 ] && [ $optionOS -eq 1 ]; then 
	get_OS_Difficulty $difficulty $os
elif [ $parameter_counter -eq 7 ]; then
	getSkills "$skills"
else
	helpPanel
fi


