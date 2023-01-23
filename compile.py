from cob_compiler import CobolCompiler

compiler = CobolCompiler()

# Exemples
compiler.add(compilation_name="C01", source_code="src/actions/exemples/MOD-DYN.cob",
             object_name="MOD-DYN", access_database=False, dynamic_lib=True)

compiler.add(compilation_name="C02", source_code="src/actions/exemples/MOD-DYN-SQL.cob",
             object_name="MOD-DYN-SQL", access_database=True, dynamic_lib=True)

compiler.add(compilation_name="C03", source_code="src/actions/exemples/PROG-QUERY-STRING.cob", 
             object_name="PROG-QUERY-STRING", access_database=False, dynamic_lib=False)

compiler.add(compilation_name="C04", source_code="src/actions/exemples/PROG-RECEBE-JSON.cob", 
             object_name="PROG-RECEBE-JSON", access_database=False, dynamic_lib=False)

compiler.add(compilation_name="C05", source_code="src/actions/exemples/PROG-DB2-CRIAR-TABELA.cob", 
             object_name="PROG-CRIAR-TABELA", access_database=True, dynamic_lib=False)

compiler.add(compilation_name="C06", source_code="src/actions/exemples/PROG-CHAMADA-DINAMICA.cob", 
             object_name="PROG-CHAMADA-DINAMICA", access_database=False, dynamic_lib=False)

compiler.add(compilation_name="C07", source_code="src/actions/exemples/PROG-DB2-CONSULTA-SQL.cob", 
             object_name="PROG-CONSULTA-SQL", access_database=True, dynamic_lib=False)

compiler.add(compilation_name="C08", source_code="src/actions/exemples/PROG-PATH-PARAMS.cob", 
             object_name="PROG-PATH-PARAMS", access_database=False, dynamic_lib=False)

compiler.add(compilation_name="C09", source_code="src/actions/exemples/PROG-MYSQL-CRIAR-TABELA.cob", 
             object_name="PROG-MYSQL-CRIAR-TABELA", access_database=True, dynamic_lib=False)



# Call compile to compile one or all compilations
# Recive from env
compiler.compile()