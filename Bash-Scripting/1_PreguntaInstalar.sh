
# Este script de bash pregunta si el usuario desea instalar un programa ("s/n"). Si elige "s", muestra 
# "Instalando programa..."; si elige "n" o cualquier otra cosa, muestra "El programa no se va a instalar".


#! /bin/bash

echo -n "¿Deseas instalar el programa [s/n]?:  "
read respuesta

if [[ $respuesta == "s" ]]; then
    echo "Instalando programa..."

else 
    echo "EL programa no se va a instalar"
fi
