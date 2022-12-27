#!/usr/bin/python3

from cob_web import CobWeb

CobWeb.run()

# import sys
# import os
# import cgi

# # print(os.environ)
# # sys.exit()

# # Importa as rotas do micro serviço.
# import routes as rt

# def action_not_found():
#     print("Access-Control-Allow-Origin: *")
#     print("Content-type: application/json")
#     print("\n")
#     print("Action não encontrada")
#     sys.exit()


# # # Monta o caminho base dos binários em cobol
# directory = os.getcwd()
# dist_path = directory + "/dist"

# # # Pega os paramentros passados via QUERY_STRING
# # #agrs = dict(item.split('=') for item in os.environ['QUERY_STRING'].split('&') if item)
# agrs = cgi.parse()


# # Pegar programa cobol correspondente
# prog_cobol, path_params = rt.router.get_prog_cobol(http_method=os.environ["REQUEST_METHOD"], path=os.environ["REQUEST_URI"])

# # Se não tem, mostra a mensagem de erro
# if not prog_cobol:
#     action_not_found()

# # Setando os parametros do path
# i = 0

# for path_param in path_params:

#     if isinstance(path_param, tuple):
#         for item in path_param:
#             i += 1
#             os.environ["PATH-PARAM-" + str(i)] = item
#     else:
#         i += 1
#         os.environ["PATH-PARAM-" + str(i)] = path_param


# # setar configurações
# import config as cf

# for config in cf.config_list:
#     os.environ[config['key']] = config['value']

# # QUERY-STRINGS args
# for key, value in agrs.items():
#     os.environ["QS_" + str(key).upper()] = str(value).replace("%20", " ")

# # # Setar os dados via post. Ex: PS_ID, PS_NOME ...



# # # Executa o binário
# os.system(dist_path + "/" + prog_cobol)

