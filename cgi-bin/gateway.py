    #!/usr/bin/python3
import time

begin_exec = time.time()

import sys
import os
from urllib.parse import urlparse, parse_qs

# Importa as rotas do micro serviço.
import routes as rt

def action_not_found():
    print("Access-Control-Allow-Origin: *")
    print("Content-type: application/json")
    print("\n")
    print("Action não encontrada")
    sys.exit()

# Monta o caminho base dos binários em cobol
directory = os.getcwd()
dist_path = directory + "/dist"

# Pega os paramentros passados via QUERY_STRING
agrs = dict(item.split('=') for item in os.environ['QUERY_STRING'].split('&') if item)

# Pega a action solicitada pelo usuário
action = agrs.get("action")

if not action:
    action_not_found()

# Pega o nome do binário correspondente a rota
prog_cobol = rt.rotas.get(action, None)

# Se não tem, mostra a mensagem de erro
if not prog_cobol:
    action_not_found()


# Setar as variaveis de ambiente para a execução

# Strings de conecção de banco de dados.
import config as cf
os.environ["DB_CONNECTION_STRING_COB_DEV"] = cf.DB_CONNECTION_STRING_COB_DEV

# QUERY-STRINGS args
for key, value in agrs.items():
    os.environ["QS_" + str(key).upper()] = str(value).replace("%20", " ")

# Setar os dados via post. Ex: PS_ID, PS_NOME ...

# Executa o binário
os.system(dist_path + "/" + prog_cobol)
#os.system("cobcrun "+  dist_path + "/" + prog_cobol)

# Mostrar tempo de excução
end_exec = time.time()
#sys.stderr.write("[INFO][" + action +"] TEMPO DE EXECUÇÃO EM SEGUNDOS: " + str(end_exec - begin_exec))
    
