
from router import Router
 
router = Router()

router.get(path="/cobweb/exemplo/criar-tabela", cobol_program="PROG-CRIAR-TABELA")
router.get(path="/cobweb/exemplo/consulta-tabela", cobol_program="PROG-CONSULTA-SQL")
router.get(path="/cobweb/exemplo/chamada-dinamica", cobol_program="PROG-CHAMADA-DINAMICA")
router.get(path="/cobweb/exemplo/chamada-query-string", cobol_program="PROG-QUERY-STRING")

router.get(path="/cobweb/exemplo/clientes/:id/venda/:id", cobol_program="PROG-PATH-PARAMS")
router.post(path="/cobweb/exemplo/post-com-json-simples", cobol_program="PROG-RECEBE-JSON")

