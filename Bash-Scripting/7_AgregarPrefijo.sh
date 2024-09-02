# Este script de Bash es una herramienta para agregar un prefijo a los nombres de todos los archivos en un directorio especificado.

#!/bin/bash

# nombre -- extension -- numero -- ruta 

error(){
    echo -e $1 
    exit 1
}

if [ $# -ne 2 ]; then 
    error "\nUso script --> Prefijo - Ruta\n"
fi

if [ ! -d $2 ]; then
    error "\nError: El directorio no existe\n"
fi

for f in `ls $2`; do
    name="$2/$f"
    new_name="$2/$1$f"
    mv $name $new_name
done

echo "Se ha actualizado correctamente el nombre con el prefijo $1"
