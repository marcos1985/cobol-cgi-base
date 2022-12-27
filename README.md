## COBOL WEB VIA CGI

### OBJETIVOS
* Ter uma imagem de desenvolvimento Cobol para baixa plataforma.
* Explorar as possibilidades de usar o Cobol para criação de micro serviços.

### LIMITAÇÕES

* Somente acessa bancos de dados MariaDB, MYSQL e POSTGRESQL.
* Para compilar programas que acessam banco de dados é usado um pré-processador de SQL.

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
	> Código fonte com a estrutura básica que pode ser usado como referência para
	criação de endpoints.



### COMO COMPILAR UM PROGRAMA COBOL
* Compilar programa executável:
	* **Sintaxe**: cobc -x -o [nome do executável] [código fonte]
	* **Exemplo**: cobc -x -o PROG01 src/actions/PROG01.cob

* Compilar programa que sera carregado de forma dinamica (.so):
	* **Sintaxe**: cobc -m -o [nome da lib (colocar .so no final)] [código fonte]
	* **Exemplo**: cobc -m -o MOD02.so src/libs/MOD02.cob
				
* Compilar programa que acessa banco de dados:
	* **Sintaxe**: <br>
		esqlOC  -static -o [nome arquivo processado] [código fonte]  <br>
		cobc -x -static -locsql -o [nome do executável]  [nome arquivo processado]  <br>
	* **Exemplo**: <br>
				esqlOC  -static -o PROG01.sql.cob src/actions/PROG01.cob <br>
				cobc -x -static -locsql -o PROG01 PROG01.sql.cob

* Compilar programa, que acessa banco de dados, que sera carregado de forma dinamica (.so):
	* **Sintaxe**: <br>
		esqlOC  -static -o [nome arquivo processado] [código fonte]  <br>
		cobc -m -static -locsql -o [nome da lib (colocar .so no final)]  [nome arquivo processado]  <br>
	* **Exemplo**: <br>
				esqlOC  -static -o PROG01.sql.cob src/actions/PROG01.cob <br>
				cobc -m -static -locsql -o PROG01 PROG01.sql.cob


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

> É possivel também para parametros do tipo inteiro na url:<br>
Ex: /cliente/:id<br>
Ex: /professor/:id/disciplina/:id/tutorados<br>


``` python

	from router import Router
	 
	router = Router()
	
	router.get(path="/cobweb/teste/criar-tabela", cobol_program="PROG-CRIAR-TABELA")
	router.get(path="/cobweb/teste/consulta-tabela", cobol_program="PROG-CONSULTA-SQL")
	router.get(path="/cobweb/teste/chamada-estatica", cobol_program="PROG-CHAMADA-ESTATICA")
	router.get(path="/cobweb/teste/chamada-dinamica", cobol_program="PROG-CHAMADA-DINAMICA")
	router.get(path="/cobweb/teste/chamada-query-string", cobol_program="PROG-QUERY-STRING")

```

### USANDO PARÂMETROS VIA QUERY STRING

> Todo parâmetro passado via QUERY-STRING é acessado no código Cobol com um QS_ na frente do nome do parâmetro. Tudo deve ficar em caixa alta.

```cobol

	ACCEPT WRK-ID-CLIENTE FROM ENVIRONMENT "QS_ID".
    ACCEPT WRK-NOME-CLIENTE FROM ENVIRONMENT "QS_NOME".

```


### POST/PUT COM JSON NO BODY DA REQUISIÇÃO

> O JSON passado nas requisições POST e PUT é acessado no Cobol por meio da variável de ambiente REQUEST-BODY. Você precisa fazer o parse do JSON dentro do cobol.  


```cobol

	ACCEPT WRK-JSON FROM ENVIRONMENT "REQUEST-BODY".

```

#### PORTAS EXPOSTAS

* Porta COBOL:     5300
* Porta MariaDB:   33061

#### TESTAR COM CURL OU POSTMAN/INSOMNIA
> Execute em sequência para a criação da tabela teste.

* curl http://localhost:5300/cobweb/teste/criar-tabela
* curl http://localhost:5300/cobweb/teste/consulta-tabela
* curl http://localhost:5300/cobweb/teste/chamada-estatica
* curl http://localhost:5300/cobweb/teste/chamada-dinamica
* curl http://localhost:5300/cobweb/teste/chamada-query-string?id=10&nome=Mar
