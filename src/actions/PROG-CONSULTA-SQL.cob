       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROG-CONSULTA-SQL.
      *******************************************
      * AUTOR: 
      * DATA: 
      ******************************************* 
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.       
       DATA DIVISION.
       FILE SECTION.

       WORKING-STORAGE SECTION.

       01  WRK-NEWLINE                     PIC X       VALUE x'0a'.

       77  WRK-TEST-ID-MASK                PIC Z(8)9.
       77  WRK-CONTADOR                    PIC 9(10) VALUE ZERO.
       77  WRK-MSG-ERRO                    PIC X(255).
       77  WRK-DB-STRING                   PIC X(255).

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       
       01  HOSTVARS.
           05 BUFFER     PIC X(1024).
           05 SQL-BUFFER     PIC X(1024).
           05 HVARD      PIC S9(5)V99.
           05 HVARC      PIC  X(50).
           05 HVARN      PIC  9(12).
       
       01  SQL-01-VARS.
           05 TEST-ID          PIC 9(10).
           05 TEST-NOME        PIC X(255).
           05 TEST-QTD         PIC 9(10).
          
       EXEC SQL END DECLARE SECTION END-EXEC. 

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           
           PERFORM 1000-CONFIGURAR-HTTP-HEADERS.
           PERFORM 1100-CONECTA-BANCO-DE-DADOS.
           PERFORM 2000-CONTA-ELEMENTOS-CONSULTA.
           PERFORM 2100-CRIAR-CURSOR.
           PERFORM 3000-MONTA-JSON-RETORNO.
           
           STOP RUN.

      
       1000-CONFIGURAR-HTTP-HEADERS.
    
           DISPLAY "Access-Control-Allow-Origin: *".
           DISPLAY "Content-type: application/json".
           DISPLAY WRK-NEWLINE. 
       
       1100-CONECTA-BANCO-DE-DADOS. 

           ACCEPT WRK-DB-STRING 
           FROM ENVIRONMENT "DB_CONNECTION_STRING_COB_DEV".

           MOVE WRK-DB-STRING TO BUFFER.
           EXEC SQL CONNECT TO :BUFFER END-EXEC.
           
           IF  SQLCODE NOT EQUAL ZERO 
               STRING 
                   "ERRO AO TENTAR ABIR CONEXÃO COM O "
                   "BANDO DE DADOS."
               INTO WRK-MSG-ERRO

               DISPLAY FUNCTION trim(WRK-MSG-ERRO)
               MOVE SPACES TO WRK-MSG-ERRO

               PERFORM 4000-LIBERAR-RECURSOS
               STOP RUN
           END-IF.
      
       2000-CONTA-ELEMENTOS-CONSULTA.
           
           EXEC SQL 
               SELECT
                   COUNT(*)
               INTO :TEST-QTD
               FROM teste
           END-EXEC.

       2100-CRIAR-CURSOR.

           EXEC SQL
               DECLARE CUR-TESTE CURSOR FOR 
               SELECT 
                   id,
                   nome
               FROM teste
           END-EXEC
       
           EXEC SQL
               OPEN CUR-TESTE
           END-EXEC

           IF  SQLCODE NOT EQUAL ZERO 
               STRING 
                   "ERRO AO TENTAR CRIAR CURSOR "
               INTO WRK-MSG-ERRO
               DISPLAY FUNCTION trim(WRK-MSG-ERRO)
               MOVE SPACES TO WRK-MSG-ERRO
               PERFORM 4000-LIBERAR-RECURSOS
               STOP RUN
           END-IF.
       
      
       
       3000-MONTA-JSON-RETORNO. 
           
           DISPLAY "[".
           
           PERFORM UNTIL SQLCODE = 100
               
               EXEC SQL
                   FETCH 
                       CUR-TESTE
                   INTO 
                       :TEST-ID, 
                       :TEST-NOME
               END-EXEC
               
               IF SQLCODE NOT EQUAL 100 THEN
                   
                   ADD 1 TO WRK-CONTADOR
    
                   MOVE TEST-ID TO WRK-TEST-ID-MASK
    
                   DISPLAY '   {'
                       DISPLAY '    "id": ' WRK-TEST-ID-MASK ', '
                       DISPLAY '    "nome": "' 
                                       FUNCTION trim(TEST-NOME) '"'
                   DISPLAY '   }'
                   
                   IF WRK-CONTADOR < TEST-QTD THEN 
                       DISPLAY ", "
                   END-IF
    
               END-IF
    
           END-PERFORM.
    
           DISPLAY "]".
       
       4000-LIBERAR-RECURSOS.
           
           EXEC SQL CONNECT RESET END-EXEC.
