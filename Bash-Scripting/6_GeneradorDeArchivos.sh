# Generador de archivos, crea multiples archivos con la extension que elije el usuario

#!/bin/bash

# nombre -- extension -- numero -- ruta 

error(){
    echo -e $1 
    exit 1
}

if [ $# -ne 4 ]; then 
    error "\nUso script --> Nombre - Extension - Número - Ruta\n"
fi

if [ ! -d $4 ]; then
    error "\nError: El directorio no existe\n"
fi

if [ $3 -lt 1 ]; then
    error "\nEl numero de ficheros no puede ser menor a uno\n"
fi 

for (( i = 1; i <= $3; i++)); do
    name="$4/$1$i.$2"
    if [ $i -lt 10 ]; then
        name="$4/$10$i.$2"
    fi
    touch $name
done

echo -e "\nSe han creado $3 ficheros .$2 exitosamente en $4\n"
