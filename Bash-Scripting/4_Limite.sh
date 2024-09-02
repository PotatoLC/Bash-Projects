# Limite
#!/bin/bash

echo -n "Escribe un limite:  "
read limite

for (( i = 0; i < $limite; i++ )); do
    echo $i 
done
