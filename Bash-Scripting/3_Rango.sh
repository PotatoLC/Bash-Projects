# Checa rangos de un numero

#!/bin/bash

echo -n "EScribe un numero:  "
read valor

if [ $valor -lt 5 -o $valor -gt 10 ]; then
    echo "Tu valor no está entre 5 y 10"
else
    echo "Tu valor está entre 5 y 10"
fi 
