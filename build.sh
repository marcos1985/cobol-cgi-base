#!/usr/bin/bash

# ======================================== SETUP INICICAL =============================================== 

if [ $# -lt 1 ]; then
    echo -e "\n\tSintaxe: bash build.sh <COMPILAÇÃO>\n"
    echo -e "\tEx01: bash build.sh ALL         # Excetuta todos as compilações"
    echo -e "\tEx02: bash build.sh PASSO-01     # Excetuta uma compilação especifica\n"
    exit
fi

chmod +x cgi-bin/gateway.py

python3 compile.py $1