import re

class Route (object):

    def __init__(self, http_method, path, cobol_program) -> None:
        
        self.__http_method = http_method
        self.__path = path
        self.__cobol_program = cobol_program

        fragments = path.split("/")

        list_str = []

        for fragment in  fragments:

            if fragment.startswith(":"):
                list_str.append("(\d+)")
            else:
                list_str.append(fragment)
        
        self.__regex = "^" +  "/".join(list_str) + "$"

    def match_regex(self, uri) :
        
        if re.search(self.__regex, uri):
            return True

        return False

    def get_regex(self):
        return self.__regex

    def get_regex_of_path(self, uri): 
        
        if re.search(self.__regex, uri):
            return self.__regex

        return None

    def get_path(self):
        return self.__path

    def get_http_method(self):
        return self.__http_method

    def get_cobol_program(self):
        return self.__cobol_program

    def __str__(self) -> str:
        return """
            {
                "http_method": "%s",
                "path": "%s",
                "cobol_program": "%s",
                "regex": "%s"   
            }
        """ % (self.__http_method, self.__path, self.__cobol_program, self.__regex)

class Router (object):

    def __init__(self) -> None:
        self.__routes = []


    def get_prog_cobol(self, http_method, path):
        
        uri = path.split("?")[0]

        for route in self.__routes:
            #print(route)
            if route.get_http_method() == http_method and route.match_regex(uri):
                params = re.findall(route.get_regex(), uri)
                return route.get_cobol_program(), list(params)
        
        return None, None

    def __add_route(self, http_method, path, cobol_program):
        self.__routes.append(Route(http_method, path, cobol_program))
    
    def get(self, path, cobol_program):
        self.__add_route("GET", path, cobol_program)

    def post(self, path, cobol_program):
        self.__add_route("POST", path, cobol_program)

    def put(self, path, cobol_program):
        self.__add_route("PUT", path, cobol_program)

    def delete(self, path, cobol_program):
        self.__add_route("DELETE", path, cobol_program)

    def patch(self, path, cobol_program):
        self.__add_route("PATCH", path, cobol_program)