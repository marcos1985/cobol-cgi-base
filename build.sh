#!/usr/bin/bash

# ======================================= Functions =====================================================

mostar_sucesso_falha() {
    
    if [ $? -eq 0 ]; then 
        printf "\xE2\x9C\x85 $1"
    else 
        printf "\xF0\x9F\x9A\xAB $1"
    fi

}

# ======================================== SETUP INICICAL =============================================== 

if [ $# -lt 1 ]; then
    echo -e "\n\tSintaxe: bash build.sh <COMPILAÇÃO>\n"
    echo -e "\tEx01: bash build.sh TUDO         # Excetuta todos as compilações"
    echo -e "\tEx02: bash build.sh PASSO-01     # Excetuta uma compilação especifica\n"
    exit
fi

chmod +x cgi-bin/gateway.py

# ======================================== COMPILAÇÃO ===================================================

# Criar pasta cgi-bin/dist
mkdir -p  cgi-bin/dist

# Compilar LIBS
esqlOC  -static -o MOD-DYN-SQL.sql.cob src/libs/MOD-DYN-SQL.cob
cobc -m -static -locsql -o MOD-DYN-SQL.so MOD-DYN-SQL.sql.cob
cp MOD-DYN-SQL.so cgi-bin/dist
rm MOD-DYN-SQL.sql.cob
rm MOD-DYN-SQL.so
mostar_sucesso_falha "MOD-DYN-SQL"
echo ""


# >> src/actions/PROG-CHAMADA-ESTATICA.cob
if [[ ( $1 == "TUDO" ) || ( $1 == "PROG-CHAMADA-ESTATICA" ) ]]; then

    rm -f cgi-bin/dist/PROG-CHAMADA-ESTATICA

    cobc -c src/actions/MOD-TESTA-CALL.cob
    cobc -x -o PROG-CHAMADA-ESTATICA src/actions/PROG-CHAMADA-ESTATICA.cob MOD-TESTA-CALL.o
    
    cp PROG-CHAMADA-ESTATICA cgi-bin/dist
    
    rm MOD-TESTA-CALL.o
    rm PROG-CHAMADA-ESTATICA

    if [ $? -eq 0 ]; then 
        printf "\xE2\x9C\x85 PROG-CHAMADA-ESTATICA"
    else 
        printf "\xF0\x9F\x9A\xAB PROG-CHAMADA-ESTATICA"
    fi
    echo ""
fi

# >> src/actions/PROG-CRIAR-TABELA.cob
if [[ ( $1 == "TUDO" ) || ( $1 == "PROG-CRIAR-TABELA" ) ]]; then

    rm -f cgi-bin/dist/PROG-CRIAR-TABELA

    esqlOC  -static -o PROG-CRIAR-TABELA.sql.cob src/actions/PROG-CRIAR-TABELA.cob
    cobc    -x -static -locsql -o PROG-CRIAR-TABELA PROG-CRIAR-TABELA.sql.cob

    cp PROG-CRIAR-TABELA cgi-bin/dist
    
    rm PROG-CRIAR-TABELA.sql.cob
    rm PROG-CRIAR-TABELA

    if [ $? -eq 0 ]; then 
        printf "\xE2\x9C\x85 PROG-CRIAR-TABELA"
    else 
        printf "\xF0\x9F\x9A\xAB PROG-CRIAR-TABELA"
    fi

    echo ""
fi

# >> src/actions/PROG-QUERY-STRING.cob
if [[ ( $1 == "TUDO" ) || ( $1 == "PROG-QUERY-STRING" ) ]]; then

    rm -f cgi-bin/dist/PROG-QUERY-STRING

    cobc -x -o PROG-QUERY-STRING src/actions/PROG-QUERY-STRING.cob
    cp PROG-QUERY-STRING cgi-bin/dist
    
    rm PROG-QUERY-STRING

    if [ $? -eq 0 ]; then 
        printf "\xE2\x9C\x85 PROG-QUERY-STRING"
    else 
        printf "\xF0\x9F\x9A\xAB PROG-QUERY-STRING"
    fi

    echo ""
fi

# >> src/actions/PROG-CONSULTA-SQL.cob
if [[ ( $1 == "TUDO" ) || ( $1 == "PROG-CONSULTA-SQL" ) ]]; then

    rm -f cgi-bin/dist/PROG-CONSULTA-SQL

    esqlOC  -static -o PROG-CONSULTA-SQL.sql.cob src/actions/PROG-CONSULTA-SQL.cob
    cobc    -x -static -locsql -o PROG-CONSULTA-SQL PROG-CONSULTA-SQL.sql.cob

    cp PROG-CONSULTA-SQL cgi-bin/dist
    
    rm PROG-CONSULTA-SQL.sql.cob
    rm PROG-CONSULTA-SQL

    if [ $? -eq 0 ]; then 
        printf "\xE2\x9C\x85 PROG-CONSULTA-SQL"
    else 
        printf "\xF0\x9F\x9A\xAB PROG-CONSULTA-SQL"
    fi

    echo ""
fi

# >> src/actions/PROG-CHAMADA-DINAMICA.cob
if [[ ( $1 == "TUDO" ) || ( $1 == "PROG-CHAMADA-DINAMICA" ) ]]; then

    rm -f cgi-bin/dist/MOD-DYN.so
    rm -f cgi-bin/dist/PROG-CHAMADA-DINAMICA

    cobc -m src/libs/MOD-DYN.cob
    cp MOD-DYN.so cgi-bin/dist
    rm MOD-DYN.so

    cobc -x -o PROG-CHAMADA-DINAMICA src/actions/PROG-CHAMADA-DINAMICA.cob
    cp PROG-CHAMADA-DINAMICA cgi-bin/dist
    rm PROG-CHAMADA-DINAMICA

    if [ $? -eq 0 ]; then 
        printf "\xE2\x9C\x85 PROG-CHAMADA-DINAMICA"
    else 
        printf "\xF0\x9F\x9A\xAB PROG-CHAMADA-DINAMICA"
    fi
    echo ""
fi


