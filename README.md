## COBOL WEB VIA CGI

### OBJETIVOS
* Ter uma imagem de desenvolvimento Cobol para baixa plataforma.
* Explorar as possibilidades de usar o Cobol para criação de micro serviços.

### LIMITAÇÕES
* Somente acessa bancos de dados MariaDB, MYSQL e POSTGRESQL.
* Módulos auxiliares aos programas Cobol só podem ser compilados de forma estática.
* Para compilar programas que acessam banco de dados é usado um pré-processador de SQL.
* A passagem de configurações é feita de forma manual no arquivo gateway.py

### SOFTWARES NECESSÁRIOS
* git
* docker 
* docker-compose
* curl

### ESTRUTURA DE PASTAS E ARQUIVOS DO PROJETO

* build.sh:
	> Arquivo usado para compilar os programas Cobol.

* .gitignore:
	> Arquivo usado pelo git para não observar certos arquivos e pastas.	
	
* docker-compose.yml:
	> Arquivo de configuração para subir os containers do projeto.
		
* cgi-bin:
	> Pasta onde deve ficar o arquivo python que rececbe todas as 
	requisições, o arquivo de rotas e as configurações.

	- config.py
	- gateway.py 
	- routes.py
	
* cgi-bin/dist:
	> Pasta onde devem ficar os binários dos programas Cobol

* src:
	> Pastas onde devem ficar os códigos fontes dos programas Cobol.

* src/actions:
   > Pasta sugerida para criação das actions (endpoints)
 
* src/libs:
   > Pasta sugerida para criação de modulos auxiliares dos programas cobol

* src/util/base.cob:
	> Código fonte com a estrutura básica que pode ser usado com referência para
	criação de enpoints.



### COMO COMPILAR UM PROGRAMA COBOL
* Sem usar um modulo auxiliar:
	* **Sintaxe**: cobc -x -o [nome do executável] [código fonte]
	* **Exemplo**: cobc -x -o PROG01 src/actions/PROG01.cob
	
* Usando um ou mais módulo(s) auxiliar(es):
	* **Sintaxe**: <br>
		cobc -c -o [nome do código objeto da lib] [código fonte da lib]<br>
		cobc -x -o [nome do executável] [código fonte] [nome do código objeto] ... [nome do código objeto] <br>
	* **Exemplo 01**: <br>
				cobc -c -o  MOD01 src/lib/MOD01.cob <br>
				cobc -x -o  PROG01 src/actions/PROG01.cob MOD01.o
				
	* **Exemplo 02**: <br>
				cobc -c -o  MOD01 src/lib/MOD01.cob <br>
				cobc -c -o  MOD02 src/lib/MOD02.cob <br>
				cobc -x -o  PROG01 src/actions/PROG01.cob MOD01.o MOD02.o
				
* Com pré-processamento SQL:
	* **Sintaxe**: <br>
		esqlOC  -static -o [nome arquivo processado] [código fonte]  <br>
		cobc -x -static -locsql -o [nome do executável]  [nome arquivo processado]  <br>
	* **Exemplo**: <br>
				esqlOC  -static -o PROG01.sql.cob src/actions/PROG01.cob <br>
				cobc -x -static -locsql -o PROG01 PROG01.sql.cob
				
* Usando módulo auxiliar e com pré-processamento SQLL:
	* **Sintaxe**: <br>
		cobc -c -o [nome do código objeto da lib] [código fonte da lib] <br>
		esqlOC  -static -o [nome arquivo processado] [código fonte]  <br>
		cobc -x -static -locsql -o [nome do executável]  [nome arquivo processado]  <br>
	* **Exemplo**: <br>
				cobc -c -o  MOD01 src/lib/MOD01.cob <br>
				esqlOC  -static -o PROG01.sql.cob src/actions/PROG01.cob <br>
				cobc -x -static -locsql -o PROG01 PROG01.sql.cob MOD01.o


### EXPLICANDO O ARQUIVO BUILD.SH

> Arquivo com códigos em SHELL SCRIPT para compilar os programas
Cobol. Cada programa deve ter sua seção na área de compilação.

> $1 recebe o nome da compilação a ser executada, se for TUDO, todas as compilações configuradas serão executadas. Se for passado um nome de compilação, somente essa compilação será executada.

> Exemplo 01: bash build.sh TUDO 

> Exemplo 02: bash build.sh PROG-CHAMADA-ESTATICA

> cp: comando unix para copiar arquivos e pastas

> rm: comando unix para remover arquivos e pastas
```sh
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

```
	
### EXECUTANDO COM DOCKER-COMPOSE

* Clonar o projeto:
	* git clone https://github.com/marcos1985/cobol-cgi-base.git

* Entrar na pasta do projeto
	* cd cobol-cgi-base

* Criar arquivo config.py
	* cp cgi-bin/config.exemple.py cgi-bin/config.py

* Subir os containers com GNU-COBOL e MariaDB
	* docker-compose up

* Verificar qual o id do container (Abrir outra aba do terminal)
	* docker ps

* Entar no container do COBOL (Substitua [id_do_container] com o id do seu container)
	* docker exec -it [id_do_container] bash
	* **Exemplo**: docker exec -it 8728378728 bash

* Compilar todos os programas cobol configurados no build.sh (Você deve estar dentro do container)
	* bash build.sh TUDO
	
### ENTENDENDO O ARQUIVO ROUTES.PY

> Arquivo contendo o de-para entre a action passada na url e o binário Cobol que deve ser executado na pasta cgi-bin/dist

``` python

	rotas = {}

	rotas["CHAMADA-ESTATICA"]                   = "PROG-CHAMADA-ESTATICA"
	rotas["CRIAR-TABELA-TESTE"]                 = "PROG-CRIAR-TABELA"
	rotas["RECEBER-QUERY-STRING"]               = "PROG-QUERY-STRING"
	rotas["CONSULTAR-TABELA-TESTE"]             = "PROG-CONSULTA-SQL"

```

#### PORTAS EXPOSTAS

* Porta COBOL:     5300
* Porta MariaDB:   33061

#### TESTAR COM CURL OU POSTMAN/INSOMNIA
> Execute em sequência para a criação da tabela teste.

* curl http://localhost:5300/cgi-bin/gateway.py?action=CHAMADA-ESTATICA
* curl http://localhost:5300/cgi-bin/gateway.py?action=CRIAR-TABELA-TESTE
* curl http://localhost:5300/cgi-bin/gateway.py?action=RECEBER-QUERY-STRING&id=34&nome=Marcos Oliveira
* curl http://localhost:5300/cgi-bin/gateway.py?action=CONSULTAR-TABELA-TESTE
