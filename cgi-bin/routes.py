
from router import Router
 
router = Router()

router.get(path="/cobweb/teste/criar-tabela", cobol_program="PROG-CRIAR-TABELA")
router.get(path="/cobweb/teste/consulta-tabela", cobol_program="PROG-CONSULTA-SQL")
router.get(path="/cobweb/teste/chamada-dinamica", cobol_program="PROG-CHAMADA-DINAMICA")
router.get(path="/cobweb/teste/chamada-query-string", cobol_program="PROG-QUERY-STRING")

router.get(path="/cobweb/teste/clientes/:id/venda/:id", cobol_program="PROG-PATH-PARAMS")
router.post(path="/cobweb/teste/post-com-json-simples", cobol_program="PROG-RECEBE-JSON")

