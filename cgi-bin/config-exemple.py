
# String de conexão. Para cada banco os nomes dos atributos podem ser diferentes
# Consultar o seu banco de dados para saber como montar a string de conexão.

# EX: MariaDB
DB_CONNECTION_STRING_COB_DEV = """
    Driver=/usr/lib/x86_64-linux-gnu/odbc/libmaodbc.so;
    Server=cob-dev-db;
    UID=root;
    PWD=123456;
    DB=cob-dev;
    Port=3306;
"""

# DB_CONNECTION_STRING_DB2_COB_DEV = """
#     Driver=/home/db2clidriver/lib/libdb2.so;
#     Server=db2-cob-dev-db:50000;Database=COBDEV;UID=db2inst1;PWD=123456;Protocol=TCPIP;
# """

DB_CONNECTION_STRING_DB2_COB_DEV = """
    Driver=/home/db2clidriver/lib/libdb2.so;Database=COBDEV;Hostname=db2-cob-dev-db;Port=50000;Protocol=TCPIP;Uid=db2inst1;Pwd=123456;
"""

DB_CONNECTION_STRING_PGSQL_COB_DEV = """
    Driver=/usr/lib/x86_64-linux-gnu/odbc/psqlodbcw.so;Server=pgsql-cob-dev-db;Port=5432;Database=cob-dev;Uid=root;Pwd=123456;
"""

config_list = []

# config_list.append({
#     "key": "DB_CONNECTION_STRING_COB_DEV",
#     "value": DB_CONNECTION_STRING_COB_DEV
# })

config_list.append({
    "key": "DB_CONNECTION_STRING_COB_DEV",
    "value": DB_CONNECTION_STRING_DB2_COB_DEV
})

# config_list.append({
#     "key": "DB_CONNECTION_STRING_COB_DEV",
#     "value": DB_CONNECTION_STRING_PGSQL_COB_DEV
# })