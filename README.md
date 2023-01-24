## COBOL WEB VIA CGI

### OBJETIVOS
* Ter uma imagem de desenvolvimento Cobol para baixa plataforma.
* Explorar as possibilidades de usar o Cobol para criação de micro serviços.

### LIMITAÇÕES

* Somente acessa os bancos de dados DB2, MariaDB, MYSQL e POSTGRESQL.
* (Drivers incluídos na imagem)

### SOFTWARES NECESSÁRIOS
* git
* docker 
* docker-compose
* curl

### ESTRUTURA DE PASTAS E ARQUIVOS DO PROJETO

* build.sh:
	> Arquivo usado para chamar o arquivo compile.py, que compila os programas cobol.

* compile.py:
	> Arquivo usado adicionar uma compilação ao projeto. Uma compilação consiste em um nome, código fonte e parâmetros de compilação.

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
 
* src/actions/exemples:
   > Pasta onde estão os programas de exemplo, que podem ser usdados como referência para a criação de outros programas.
 
* src/libs:
   > Pasta sugerida para criação de modulos auxiliares dos programas cobol

* src/util/base.cob:
	> Código fonte com a estrutura básica que pode ser usado como referência para
	criação de endpoints.



### COMO COMPILAR UM PROGRAMA COBOL

* Basta adicionar uma entrada no arquivo compile.py
* executar o comando dentro do container:
	* bash build.sh [nome da compilação]
	* Ex 01: python3 compile.py ALL
	* Ex 02: python3 compile.py C2020
	
```python

	from cob_compiler import CobolCompiler
	
	compiler = CobolCompiler()
	
	# Exemples
	compiler.add(compilation_name="C2020",
		source_code="src/actions/exemples/MOD-DYN.cob",
	    	object_name="MOD-DYN", access_database=False, 
	    	dynamic_lib=True)
	 
	 
	 .
	 .
	 .
	             
	compiler.compile()
	
```


### EXPLICANDO O ARQUIVO BUILD.SH

> Arquivo, com códigos em SHELL SCRIPT, que chama o arquivo compile.py passando como parâmetro o nome da compilação. Se for passada a palavra ALL, todas as compilações serão executadas na mesma sequência defina no arquivo compile.py
	
### EXECUTANDO COM DOCKER-COMPOSE

* Clonar o projeto:
	* git clone https://github.com/marcos1985/cobol-cgi-base.git

* Entrar na pasta do projeto
	* cd cobol-cgi-base

* Criar arquivo config.py
	* cp cgi-bin/config.exemple.py cgi-bin/config.py

* Subir os containers com GNU-COBOL e DB2
	* docker-compose up

* Verificar qual o id do container (Abrir outra aba do terminal)
	* docker ps

* Entar no container do COBOL (Substitua [id_do_container] com o id do seu container)
	* docker exec -it [id_do_container] bash
	* **Exemplo**: docker exec -it 8728378728 bash

* Compilar todos os programas cobol configurados no compile.py (Você deve estar dentro do container)
	* python3 compile.py ALL
	
### ENTENDENDO O ARQUIVO ROUTES.PY

> Arquivo contendo o de-para entre a action passada na url e o binário Cobol que deve ser executado na pasta cgi-bin/dist

> É possivel também usar parametros do tipo inteiro na url:<br>
Ex: /cliente/:id<br>
Ex: /professor/:id/disciplina/:id/tutorados<br>


``` python

	from router import Router
	 
	router = Router()
	
	router.get(path="/cobweb/exemplo/criar-tabela", cobol_program="PROG-CRIAR-TABELA")
	router.get(path="/cobweb/exemplo/consulta-tabela", cobol_program="PROG-CONSULTA-SQL")
	router.get(path="/cobweb/exemplo/chamada-dinamica", cobol_program="PROG-CHAMADA-DINAMICA")
	router.get(path="/cobweb/exemplo/chamada-query-string", cobol_program="PROG-QUERY-STRING")
	
	router.get(path="/cobweb/exemplo/clientes/:id/venda/:id", cobol_program="PROG-PATH-PARAMS")
	router.post(path="/cobweb/exemplo/post-com-json-simples", cobol_program="PROG-RECEBE-JSON")

```

### QUERY STRING

> Todo parâmetro passado via QUERY-STRING é acessado no código Cobol com um QS_ na frente do nome do parâmetro. Tudo deve ficar em caixa alta.

```cobol

	ACCEPT WRK-ID-CLIENTE FROM ENVIRONMENT "QS_ID".
	ACCEPT WRK-NOME-CLIENTE FROM ENVIRONMENT "QS_NOME".

```



### PATH PARAMS

> Todo parâmetro passado via PATH PARAMS é acessado no código Cobol com um PATH_PARAM_, na frente do index do parâmetro. Tudo deve ficar em caixa alta.

```python
	router.get(path="/cobweb/teste/clientes/:id/venda/:id", 
	           cobol_program="PROG-PATH-PARAMS")
```

```cobol

	ACCEPT WRK-CLIENTE-ID     FROM ENVIRONMENT "PATH_PARAM_1".
	ACCEPT WRK-VENDA-ID       FROM ENVIRONMENT "PATH_PARAM_2".

```

### POST/PUT COM JSON

>Todo parâmetro passado via JSON é acessado no código Cobol com um PS_ na frente do nome do parâmetro. Tudo deve ficar em caixa alta.

> Somente aceita JSON simples com chave e valor. Não aceita JSON complexos com vários níveis.

```json

	{
	   "id": 10,
	   "nome": "Jpse"
	}
```

```cobol

	ACCEPT WRK-CLIENTE-ID    FROM ENVIRONMENT "PS_ID".
	ACCEPT WRK-CLIENTE-NOME  FROM ENVIRONMENT "PS_NOME".

```

#### PORTAS EXPOSTAS

* Porta COBOL:      5300
* DB2:			   50000
* Porta MariaDB:    33061

#### TESTAR COM CURL OU POSTMAN/INSOMNIA
> Execute em sequência para a criação da tabela teste.

* curl http://localhost:5300/cobweb/exemplo/criar-tabela
* curl http://localhost:5300/cobweb/exemplo/consulta-tabela
* curl http://localhost:5300/cobweb/exemplo/chamada-dinamica
* curl http://localhost:5300/cobweb/exemplo/chamada-query-string?id=10&nome=Mar
* curl http://localhost:5300/cobweb/exemplo/clientes/300/venda/2056
