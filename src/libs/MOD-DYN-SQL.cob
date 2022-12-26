       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD-DYN-SQL.
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

       01  WRK-NEWLINE                     PIC X    VALUE x'0a'.
       77  WRK-DB-STRING                   PIC X(255).

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       
       01  HOSTVARS.
           05 BUFFER     PIC X(1024).
           05 HVARD      PIC S9(5)V99.
           05 HVARC      PIC  X(50).
           05 HVARN      PIC  9(12).
       
       77  QTD-REG       PIC 9(10).
          
       EXEC SQL END DECLARE SECTION END-EXEC.


       LINKAGE SECTION.

       77  LS-QTD-REGISTRO   PIC 9(10).
       77  LS-FLAG-ERRO      PIC 9(01)   VALUE 0.
       77  LS-MSG-ERRO       PIC X(255).


       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           
           PERFORM PROC-CONECTAR-BANCO-COB-DEV.
           PERFORM PROC-CONTAR-ELEMENTOS-CONSULTA-TESTE.
           PERFORM PROC-SETAR-VARIAVEIS-DE-RETORNO.
           PERFORM PROC-LIBERAR-RECURSOS.
           EXIT PROGRAM.
       
       PROC-LIBERAR-RECURSOS.
           EXEC SQL CONNECT RESET END-EXEC.


       PROC-VERIFICAR-EXEC-SQL.
           
           IF  SQLCODE NOT EQUAL ZERO 
               MOVE 1 TO LS-FLAG-ERRO
               MOVE SQLERRM TO LS-MSG-ERRO
               PERFORM PROC-LIBERAR-RECURSOS
               EXIT PROGRAM
           END-IF.
       

       PROC-CONECTAR-BANCO-COB-DEV. 

           ACCEPT WRK-DB-STRING 
           FROM ENVIRONMENT "DB_CONNECTION_STRING_COB_DEV".

           MOVE WRK-DB-STRING TO BUFFER.
           EXEC SQL CONNECT TO :BUFFER END-EXEC.

           PERFORM PROC-VERIFICAR-EXEC-SQL.
       
       PROC-CONTAR-ELEMENTOS-CONSULTA-TESTE.
           
           EXEC SQL 
               SELECT
                   COUNT(*)
               INTO :QTD-REG
               FROM teste
           END-EXEC.
           MOVE QTD-REG TO LS-QTD-REGISTRO.
           PERFORM PROC-VERIFICAR-EXEC-SQL.

       PROC-SETAR-VARIAVEIS-DE-RETORNO.
           
           MOVE QTD-REG TO LS-QTD-REGISTRO.
           MOVE 0 TO LS-FLAG-ERRO.
           MOVE SPACES TO LS-MSG-ERRO.
