# Recibe directorio como argumento y muestra informacion sobre los archivos y el tamaño en bytes

#!/bin/bash

if [ ! -d $1 ]; then
    echo "Error: El directorio no existe"
    exit 1
fi

total=0

for f in `ls $1`; do
    name="$1/$f"
    if [ -f $name ]; then
        bytes=`ls -l $name | cut -d " " -f 5`
        echo "El fichero $name ocupa $bytes bytes" | tr -s /
        (( total += $bytes ))
    fi
done

echo -e "\nOcupas un total de $total bytes\n"
