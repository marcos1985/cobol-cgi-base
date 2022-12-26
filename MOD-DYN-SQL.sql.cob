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
      **********************************************************************
      *******                EMBEDDED SQL VARIABLES                  *******
       01 SQLCA.
           05 SQLSTATE PIC X(5).
              88  SQL-SUCCESS           VALUE '00000'.
              88  SQL-RIGHT-TRUNC       VALUE '01004'.
              88  SQL-NODATA            VALUE '02000'.
              88  SQL-DUPLICATE         VALUE '23000' THRU '23999'.
              88  SQL-MULTIPLE-ROWS     VALUE '21000'.
              88  SQL-NULL-NO-IND       VALUE '22002'.
              88  SQL-INVALID-CURSOR-STATE VALUE '24000'.
           05 FILLER   PIC X.
           05 SQLVERSN PIC 99 VALUE 02.
           05 SQLCODE  PIC S9(9) COMP-5.
           05 SQLERRM.
               49 SQLERRML PIC S9(4) COMP-5.
               49 SQLERRMC PIC X(486).
           05 SQLERRD OCCURS 6 TIMES PIC S9(9) COMP-5.
       01 SQLV.
           05 SQL-ARRSZ  PIC S9(9) COMP-5 VALUE 2.
           05 SQL-COUNT  PIC S9(9) COMP-5.
           05 SQL-ADDR   POINTER OCCURS 2 TIMES.
           05 SQL-LEN    PIC S9(9) COMP-5 OCCURS 2 TIMES.
           05 SQL-TYPE   PIC X OCCURS 2 TIMES.
           05 SQL-PREC   PIC X OCCURS 2 TIMES.
      **********************************************************************
       01 SQL-STMT-0.
           05 SQL-IPTR   POINTER.
           05 SQL-PREP   PIC X VALUE 'N'.
           05 SQL-OPT    PIC X VALUE SPACE.
           05 SQL-PARMS  PIC S9(4) COMP-5 VALUE 0.
           05 SQL-STMLEN PIC S9(4) COMP-5 VALUE 26.
           05 SQL-STMT   PIC X(26) VALUE 'SELECT COUNT(*) FROM teste'.
      **********************************************************************
      *******          PRECOMPILER-GENERATED VARIABLES               *******
       01 SQLV-GEN-VARS.
           05 SQL-VAR-0003  PIC S9(11) COMP-3.
      *******       END OF PRECOMPILER-GENERATED VARIABLES           *******
      **********************************************************************

       01  WRK-NEWLINE                     PIC X    VALUE x'0a'.
       77  WRK-DB-STRING                   PIC X(255).

      *EXEC SQL BEGIN DECLARE SECTION END-EXEC.

       01  HOSTVARS.
           05 BUFFER     PIC X(1024).
           05 HVARD      PIC S9(5)V99.
           05 HVARC      PIC  X(50).
           05 HVARN      PIC  9(12).

       77  QTD-REG       PIC 9(10).

      *EXEC SQL END DECLARE SECTION END-EXEC.


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
      *    EXEC SQL CONNECT RESET END-EXEC.
           CALL 'OCSQLDIS' USING SQLCA END-CALL
                                          .


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
      *    EXEC SQL CONNECT TO :BUFFER END-EXEC.
           MOVE 1024 TO SQL-LEN(1)
           CALL 'OCSQL'    USING BUFFER
                               SQL-LEN(1)
                               SQLCA
           END-CALL
                                               .

           PERFORM PROC-VERIFICAR-EXEC-SQL.

       PROC-CONTAR-ELEMENTOS-CONSULTA-TESTE.

      *    EXEC SQL
      *        SELECT
      *            COUNT(*)
      *        INTO :QTD-REG
      *        FROM teste
      *    END-EXEC.
           IF SQL-PREP OF SQL-STMT-0 = 'N'
               SET SQL-ADDR(1) TO ADDRESS OF
                 SQL-VAR-0003
               MOVE '3' TO SQL-TYPE(1)
               MOVE 6 TO SQL-LEN(1)
               MOVE X'00' TO SQL-PREC(1)
               MOVE 1 TO SQL-COUNT
               CALL 'OCSQLPRE' USING SQLV
                                   SQL-STMT-0
                                   SQLCA
           END-IF
           CALL 'OCSQLEXE' USING SQL-STMT-0
                               SQLCA
           MOVE SQL-VAR-0003 TO QTD-REG
                   .

           PERFORM PROC-VERIFICAR-EXEC-SQL.

       PROC-SETAR-VARIAVEIS-DE-RETORNO.

           MOVE QTD-REG TO LS-QTD-REGISTRO.
           MOVE 0 TO LS-FLAG-ERRO.
           MOVE SPACES TO LS-MSG-ERRO.
      **********************************************************************
      *  : ESQL for GnuCOBOL/OpenCobol Version 2 (2021.05.29) Build Dec 26 2022

      *******               EMBEDDED SQL VARIABLES USAGE             *******
      *  BUFFER                   IN USE CHAR(1024)
      *  HOSTVARS             NOT IN USE
      *  HOSTVARS.BUFFER      NOT IN USE
      *  HOSTVARS.HVARC       NOT IN USE
      *  HOSTVARS.HVARD       NOT IN USE
      *  HOSTVARS.HVARN       NOT IN USE
      *  HOSTVARS.QTD-REG     NOT IN USE
      *  HVARC                NOT IN USE
      *  HVARD                NOT IN USE
      *  HVARN                NOT IN USE
      *  QTD-REG                  IN USE THROUGH TEMP VAR SQL-VAR-0003 DECIMAL(11,0)
      **********************************************************************
