# Verifica si el valor no es igual a 5

#!/bin/bash

echo -n "EScribe un valor:  "
read valor

if [[ $valor -ne 5 ]]; then
    echo "Tu numero no es igual a 5"

else 
    echo "Tu numero es igual a 5"
fi
