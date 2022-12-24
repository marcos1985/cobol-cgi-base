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
           
           PERFORM 1000-CONFIGURAR-HTTP-HEADERS.
           PERFORM 2000-ABIR-CONEXAO-BANCO-DE-DADOS.
           PERFORM 3000-CRIAR-TABELA-TESTE.
           PERFORM 3100-INSERIR-REGISTRO.
           PERFORM 4000-MONTAR-JSON-RETORNO.

           STOP RUN.
           
       1000-CONFIGURAR-HTTP-HEADERS.

           DISPLAY "Access-Control-Allow-Origin: *".
           DISPLAY "Content-type: application/json".
           DISPLAY WRK-NEWLINE.

       
       2000-ABIR-CONEXAO-BANCO-DE-DADOS.
           
           ACCEPT WRK-DB-STRING 
           FROM ENVIRONMENT "DB_CONNECTION_STRING_COB_DEV".

           MOVE WRK-DB-STRING TO BUFFER.
           EXEC SQL CONNECT TO :BUFFER END-EXEC.
      
       3000-CRIAR-TABELA-TESTE.
           
           MOVE SPACES TO BUFFER;

           STRING 'DROP TABLE IF EXISTS teste;' INTO BUFFER.

           EXEC SQL
               EXECUTE IMMEDIATE :BUFFER
           END-EXEC.

           IF  SQLCODE NOT EQUAL ZERO 
               STRING 
                   "ERRO AO TENTAR EXCLUIR TABELA."
               INTO WRK-MSG-ERRO
               DISPLAY FUNCTION trim(WRK-MSG-ERRO)
               MOVE SPACES TO WRK-MSG-ERRO
               STOP RUN
           END-IF.
           
           MOVE SPACES TO BUFFER;

           STRING 
               'CREATE TABLE teste'
               '('
                   'id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,'
                   'nome VARCHAR(255) NOT NULL'
               ');'
           INTO BUFFER
           

           EXEC SQL 
               EXECUTE IMMEDIATE :BUFFER
           END-EXEC.

           IF  SQLCODE NOT EQUAL ZERO 
               STRING 
                   "ERRO AO TENTAR CRIAR TABELA."
               INTO WRK-MSG-ERRO
               DISPLAY FUNCTION trim(WRK-MSG-ERRO)
               MOVE SPACES TO WRK-MSG-ERRO
               STOP RUN
           END-IF.
       
       3100-INSERIR-REGISTRO.
           
           MOVE 'R1D6' TO NOME.

           EXEC SQL
               INSERT INTO teste (nome)
               VALUES (:NOME)
           END-EXEC.

           EXEC SQL COMMIT END-EXEC.

           IF  SQLCODE NOT EQUAL ZERO 
               STRING 
                   "ERRO AO TENTAR INSERIR REGISTRO."
               INTO WRK-MSG-ERRO
               DISPLAY FUNCTION trim(WRK-MSG-ERRO)
               MOVE SPACES TO WRK-MSG-ERRO
               STOP RUN
           END-IF.

       4000-MONTAR-JSON-RETORNO.

           DISPLAY '{'.
           DISPLAY '   "tabela": "teste'.
           DISPLAY "}".
       
       

       
