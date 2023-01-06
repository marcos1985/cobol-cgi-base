
from router import Router
 
router = Router()

router.get(path="/cobweb/teste/criar-tabela", cobol_program="PROG-CRIAR-TABELA")
router.get(path="/cobweb/teste/consulta-tabela", cobol_program="PROG-CONSULTA-SQL")
router.get(path="/cobweb/teste/chamada-estatica", cobol_program="PROG-CHAMADA-ESTATICA")
router.get(path="/cobweb/teste/chamada-dinamica", cobol_program="PROG-CHAMADA-DINAMICA")
router.get(path="/cobweb/teste/chamada-query-string", cobol_program="PROG-QUERY-STRING")

router.get(path="/clientes/:id/rel/:idRelatorio", cobol_program="PROG-CHAMADA-ESTATICA")
router.post(path="/clientes", cobol_program="PROG-RECEBE-JSON")

