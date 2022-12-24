
# String de conexão. Para cada banco os nomes dos atributos podem ser diferentes
# Consultar o seu banco de dados para saber como montar a string de conexão.

# EX: MariaDB
DB_CONNECTION_STRING_COB_DEV = """
    Driver=/usr/lib/x86_64-linux-gnu/odbc/libmaodbc.so;
    Server=cob-dev-db;
    UID=root;
    PWD=123456;
    DB=cob-dev;
    Port=3306
"""