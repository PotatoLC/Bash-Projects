#!/bin/bash 

function ctrl_c(){
	echo -e "\n\n[!] Saliendo..."
	tput cnorm; exit 1
}


# Ctrl C
trap ctrl_c INT

# Ocultar el cursor 
tput civis

for port in $(seq 1 65535); do
	(echo '' > /dev/tcp/127.0.0.1/$port) 2>/dev/null && echo "[+] $port --> Open" &	
done; wait 

# Recuperar el cursos
tput cnorm
