import os
import sys
import json
import routes as rt
import config as cf

class CobWeb(object):
    
    def __init__(self) -> None:
        self.dist_path = None
        self.cobol_program = None
        self.path_params = None
        self.query_string_params = None
        self.json_body = None

    def return_json_error(self, status_code, erro):
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

    def set_dist_path(self):
        #Monta o caminho base dos binários em cobol
        self.dist_path = os.getcwd() + "/dist"

    def find_cobol_program_from_request(self):

        # Pegar programa cobol correspondente
        self.cobol_program, self.path_params = rt.router.get_prog_cobol(http_method=os.environ["REQUEST_METHOD"], path=os.environ["REQUEST_URI"])

        # Se não tem, mostra a mensagem de erro
        if not self.cobol_program:
            self.return_json_error(400, "Ação não encontrada.")
    
    def parse_query_string_from_request(self):
        # QUERY-STRINGS args
        self.query_string_params = dict(item.split('=') for item in os.environ['QUERY_STRING'].split('&') if item)

    def parse_json_from_request(self):
        content_len = int(os.environ["CONTENT_LENGTH"])
        req_body = sys.stdin.read(content_len)

        if req_body.strip():

            try:
                self.json_body = json.loads(req_body)
            except Exception as e:
                self.return_json_error(500, "Erro ao pegar parâmetros do corpo da requisição.")
    

    def add_json_params_to_cobol_program(self):
        
        if self.json_body:

            for key, value in self.json_body.items():
                os.environ["PS_" + str(key).upper()] = str(value).replace("%20", " ")
           

    def add_query_string_to_cobol_program(self):
        for key, value in self.query_string_params.items():
            os.environ["QS_" + str(key).upper()] = str(value).replace("%20", " ")

    def add_path_params_to_cobol_program(self):
        # Setando os parametros do path
        i = 0

        for path_param in self.path_params:

            if isinstance(path_param, tuple):
                for item in path_param:
                    i += 1
                    os.environ["PATH_PARAM_" + str(i)] = item
            else:
                i += 1
                os.environ["PATH_PARAM_" + str(i)] = path_param
    
    def add_config_to_cobol_program(self):
        
        for config in cf.config_list:
            os.environ[config['key']] = config['value']

    def execute_cobol_program(self):
        os.system(self.dist_path + "/" + self.cobol_program)

    def __print_env(self):
        print(os.environ)

    def run(self):
        self.set_dist_path()
        self.find_cobol_program_from_request()
        self.parse_query_string_from_request()
        self.parse_json_from_request()
        self.add_path_params_to_cobol_program()
        self.add_json_params_to_cobol_program()
        self.add_query_string_to_cobol_program()
        self.add_config_to_cobol_program()
        self.execute_cobol_program()
        #self.__print_env()
        
       
