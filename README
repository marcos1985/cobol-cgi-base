## COBOL COM CGI

### Baixando o projeto
git clone https://github.com/marcos1985/cobol-cgi-base.git

### Entrar na pasta do projeto
cd cobol-cgi-base

### Criar arquivo config.py
cp cgi-bin/config.exemple.py cgi-bin/config.py

### Subir os containers com GNU-COBOL e MariaDB
docker-compose up

### Entar no container do COBOL
docker exec -it <container> bash

### Compilar projeto base
bash build.sh TUDO

### Portas

* Porta COBOL:     5300
* Porta MariaDB:   33061

### Testar chamda dos enpoints no linux com CURL

* curl http://localhost:5300/cgi-bin/gateway.py?action=CHAMADA-ESTATICA
* curl http://localhost:5300/cgi-bin/gateway.py?action=CRIAR-TABELA-TESTE
* curl http://localhost:5300/cgi-bin/gateway.py?action=RECEBER-QUERY-STRING&id=34&nome=Marcos Oliveira
* curl http://localhost:5300/cgi-bin/gateway.py?action=CONSULTAR-TABELA-TESTE
