import os
import sys
import routes as rt
import config as cf

class CobWeb(object):
    
    @classmethod
    def show_erro(cls, status_code, erro):
        print("Access-Control-Allow-Origin: *")
        print("Content-type: application/json")
        print("\n")

        json_str = """
            {
                "http-status": %s,
                "msg": "%s",
                "data": null
            }
        """ % ( str(status_code), erro)

        print(json_str)
        sys.exit()

    @classmethod
    def run(cls):
        
        #Monta o caminho base dos binários em cobol
        directory = os.getcwd()
        dist_path = directory + "/dist"

        # Pegar programa cobol correspondente
        prog_cobol, path_params = rt.router.get_prog_cobol(http_method=os.environ["REQUEST_METHOD"], path=os.environ["REQUEST_URI"])

        # Se não tem, mostra a mensagem de erro
        if not prog_cobol:
            cls.show_erro(400, "Ação não encontrada.")

        # Setando os parametros do path
        i = 0

        for path_param in path_params:

            if isinstance(path_param, tuple):
                for item in path_param:
                    i += 1
                    os.environ["PATH-PARAM-" + str(i)] = item
            else:
                i += 1
                os.environ["PATH-PARAM-" + str(i)] = path_param

        
        # setar configurações
        for config in cf.config_list:
            os.environ[config['key']] = config['value']

        # QUERY-STRINGS args
        agrs = dict(item.split('=') for item in os.environ['QUERY_STRING'].split('&') if item)
        
        for key, value in agrs.items():
            os.environ["QS_" + str(key).upper()] = str(value).replace("%20", " ")

        # JSON via body
        content_len = int(os.environ["CONTENT_LENGTH"])
        req_body = sys.stdin.read(content_len)
        os.environ["REQUEST-BODY"] = req_body

        #print(os.environ)
        #Executa o binário
        os.system(dist_path + "/" + prog_cobol)

