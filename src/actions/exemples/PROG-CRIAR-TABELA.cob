       IDENTIFICATION DIVISION.
       PROGRAM-ID. TESTA-ENV.
      *******************************************
      * AUTOR    : 
      * DATA     : 
      ******************************************* 
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       
       DATA DIVISION.
       FILE SECTION.

       WORKING-STORAGE SECTION.
       
       01  WRK-NEWLINE                     PIC X       VALUE x'0a'.

       77  WRK-MSG-ERRO                    PIC X(255).
       77  WRK-MSG-EXP-ERRO                PIC X(255).
       
       77  WRK-HTTP-STATUS-200             PIC 9(3)        VALUE 200.
       77  WRK-HTTP-STATUS-500             PIC 9(3)        VALUE 500.
       77  WRK-DB-STRING                   PIC X(255).

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       
       01  HOSTVARS.
           05 BUFFER     PIC X(1024).
           05 HVARD      PIC S9(5)V99.
           05 HVARC      PIC  X(50).
           05 HVARN      PIC  9(12).
       
       77  NOME          PIC X(255).
          
       EXEC SQL END DECLARE SECTION END-EXEC.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           
           PERFORM PROC-SETAR-CABECALHO-HTTP.
           PERFORM PROC-CONECTAR-BANCO-COB-DEV.
           PERFORM PROC-CRIAR-TABELA-TESTE.
           PERFORM PROC-INSERIR-REGISTRO.
           PERFORM PROC-RETORNAR-RESPOSTA-HTTP-200.
           PERFORM PROC-LIBERAR-RECURSOS.
           
           STOP RUN.
           
       PROC-LIBERAR-RECURSOS.
           EXEC SQL CONNECT RESET END-EXEC.
       
       PROC-VERIFICAR-EXEC-SQL.
           
           IF  SQLCODE NOT EQUAL ZERO 
               MOVE "ERRO AO INTERAGIR COM A BASE DE DADOS."
                   TO WRK-MSG-ERRO
               MOVE SQLERRM TO WRK-MSG-EXP-ERRO
               PERFORM PROC-RETORNAR-RESPOSTA-HTTP-500
           END-IF.

       PROC-RETORNAR-RESPOSTA-HTTP-500.
           
           PERFORM PROC-LIBERAR-RECURSOS.

           DISPLAY '{'.
           DISPLAY '"http-status": ' WRK-HTTP-STATUS-500 ','.
           DISPLAY '"msg": "' FUNCTION trim(WRK-MSG-ERRO) '",'.
           DISPLAY '"exp-msg": "' FUNCTION trim(WRK-MSG-EXP-ERRO) '",'.
           DISPLAY '"data": null'.
           DISPLAY '}'.

           STOP RUN.

       PROC-SETAR-CABECALHO-HTTP.
    
           DISPLAY "Access-Control-Allow-Origin: *".
           DISPLAY "Content-type: application/json".
           DISPLAY WRK-NEWLINE. 
       
       PROC-CONECTAR-BANCO-COB-DEV. 

           ACCEPT WRK-DB-STRING 
           FROM ENVIRONMENT "DB_CONNECTION_STRING_COB_DEV".

           MOVE WRK-DB-STRING TO BUFFER.
           EXEC SQL CONNECT TO :BUFFER END-EXEC.

           PERFORM PROC-VERIFICAR-EXEC-SQL.
      
       PROC-CRIAR-TABELA-TESTE.
           
           MOVE SPACES TO BUFFER.

           STRING 'DROP TABLE IF EXISTS teste;' INTO BUFFER.

           EXEC SQL
               EXECUTE IMMEDIATE :BUFFER
           END-EXEC.

           PERFORM PROC-VERIFICAR-EXEC-SQL.
           
           MOVE SPACES TO BUFFER.

           STRING 
               'CREATE TABLE acl.teste'
               '('
                   'id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,'
                   'nome VARCHAR(255) NOT NULL'
               ');'
           INTO BUFFER
           

           EXEC SQL 
               EXECUTE IMMEDIATE :BUFFER
           END-EXEC.

           PERFORM PROC-VERIFICAR-EXEC-SQL.

       
       PROC-INSERIR-REGISTRO.
           
           MOVE 'R1D8' TO NOME.

           EXEC SQL
               INSERT INTO acl.teste (nome)
               VALUES (:NOME)
           END-EXEC.
           
           PERFORM PROC-VERIFICAR-EXEC-SQL.

           EXEC SQL COMMIT END-EXEC.
           PERFORM PROC-VERIFICAR-EXEC-SQL.

       
       PROC-RETORNAR-RESPOSTA-HTTP-200.

           DISPLAY '{'.
           DISPLAY '"http-status": ' WRK-HTTP-STATUS-200 ','.
           DISPLAY '"msg": null,'.
           DISPLAY '"data":'.
               DISPLAY '{'.
               DISPLAY '   "tabela": "teste"'.
               DISPLAY "}".
           DISPLAY "}".
