
import os
import sys

class CobolProgram(object):

    def __init__(self, compilation_name, source_code, object_name, access_database, dynamic_lib) -> None:
        
        self.__compilation_name = compilation_name
        self.__source_code = source_code
        self.__object_name = object_name
        self.__access_database = access_database
        self.__dynamic_lib = dynamic_lib

    def get_compilation_name(self):
        return self.__compilation_name

    def get_source_code(self):
        return self.__source_code
    
    def get_object_name(self):
        return self.__object_name

    def get_access_database(self):
        return self.__access_database

    def get_dynamic_lib(self):
        return self.__dynamic_lib

# Karate DSL teste
class KarateDSLTest(object):

    def __init__(self, code, name, source) -> None:
        
        self.__code = code
        self.__name = name
        self.__source = source
    
    def get_code(self):
        return self.__code
    
    def get_name(self):
        return self.__name
    
    def get_source(self):
        return self.__source

class karateTestManager(object):

    def __init__(self) -> None:
        self.__karate_tests   = {}
    
    def add_karate_dsl_test(self, code, name, source):
        self.__karate_tests[code] = KarateDSLTest(code, name, source)

    def __karate_test_one(self, code):
        
        test = self.__karate_tests.get(code, None)

        if not test:
            print(f"Teste {code} não encontrado.")
            sys.exit(1)
        
        os.system(f"java -jar /usr/local/bin/karate-1.4.0.jar {test.get_source()}")

    def run_karate_dsl_test(self):

        if not len(sys.argv) == 2:
            print("Erro de sintaxe: deve ser passado o nome do teste ou a palavra ALL")
            print("Exemplo: python3 test.py T0001")
            print("Exemplo: python3 test.py ALL")
            sys.exit(1)

        test = sys.argv[1]
        
        if test.upper() == 'ALL':
            
            for key, karate_test in self.__karate_tests.items():
                self.__karate_test_one(karate_test.get_code())

        else:
            self.__karate_test_one(test)

class CobolCompiler(object):

    def __init__(self) -> None:
        
        self.__cobol_programs = []
    
    def add(self, compilation_name, source_code, object_name, access_database, dynamic_lib):
        
        self.__cobol_programs.append(CobolProgram(compilation_name, source_code, object_name, access_database, dynamic_lib))

    def __get_cobol_program_by_compilation_name(self, name):

        for cobol_program in self.__cobol_programs:

            if cobol_program.get_compilation_name() == name:
                return cobol_program
        
        return None

    def __compile_one(self, compilation_name):
        
        cobol_program = self.__get_cobol_program_by_compilation_name(compilation_name)

        if not cobol_program:
            print(f"Compilação de nome '{compilation_name}' não econtrada.")
            sys.exit(1)


        source_code = cobol_program.get_source_code()
        object_name = cobol_program.get_object_name()

        os.system(f"rm -f cgi-bin/dist/{object_name}")


        access_database = cobol_program.get_access_database()
        compile_as_dymanic_lib = cobol_program.get_dynamic_lib()

        type = "-m" if compile_as_dymanic_lib else "-x"
        extension = ".so" if compile_as_dymanic_lib else ""

        lib_sql = "-static -locsql" if access_database else ""
        temp_sql_cob_file = "temp.sql.cob" if access_database else ""

        if access_database:
            
            sys_return = os.system(f"esqlOC  -static -o {temp_sql_cob_file} {source_code}")
            source_code = temp_sql_cob_file

            if sys_return > 0:
                print(f"[{compilation_name}][FALHA]: COMPILAÇÃO DE NOME '{compilation_name}' FALHOU.\n")
                sys.exit(1)
            
        
        sys_return = os.system(f"cobc {type} {lib_sql} -o {object_name}{extension} {source_code}")
        
        if sys_return > 0:
            print(f"[{compilation_name}][FALHA]: COMPILAÇÃO DE NOME '{compilation_name}' FALHOU.\n")
            sys.exit(1)
        
        os.system(f"cp {object_name}{extension} cgi-bin/dist")
        os.system(f"rm -f {temp_sql_cob_file}")
        os.system(f"rm -f {object_name}{extension}")
        
        print(f"[{compilation_name}][SUCESSO]: COMPILAÇÃO DE NOME '{compilation_name}' REALIZADA COM SUCESSO.\n")


    def __compile_all(self):

        for cobol_program in self.__cobol_programs:
            self.__compile_one(cobol_program.get_compilation_name())

    def compile(self):

        os.system("mkdir -p cgi-bin/dist")

        compilation_name = sys.argv[1]

        if not compilation_name:
            print("Erro ao receber argumento da linha de comando.")
            sys.exit(1)

        if compilation_name == "ALL":
            os.system("rm -f cgi-bin/dist/*")
            self.__compile_all()
        else:
            self.__compile_one(compilation_name)