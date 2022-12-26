       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROG-CH-DYN.
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
       01  WRK-RETURN                      PIC X(255). 

       77  WRK-MSG-ERRO                    PIC X(255).
       77  WRK-MSG-EXP-ERRO                PIC X(255).
       
       77  WRK-HTTP-STATUS-200             PIC 9(3)        VALUE 200.
       77  WRK-HTTP-STATUS-500             PIC 9(3)        VALUE 500.

       77  WRK-QTD-REGISTRO   PIC 9(10).
       77  WRK-FLAG-ERRO      PIC 9(1)      VALUE 0.

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           
           PERFORM PROC-SETAR-CABECALHO-HTTP.
           PERFORM PROC-CHAMA-MOD-TESTA-CALL.
           PERFORM PROC-RETORNAR-RESPOSTA-HTTP-200.
           PERFORM PROC-LIBERAR-RECURSOS.
           STOP RUN.
       

       PROC-LIBERAR-RECURSOS.
           CONTINUE.

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

       PROC-CHAMA-MOD-TESTA-CALL.
           
           CALL 'MOD-DYN-SQL' 
                 USING WRK-QTD-REGISTRO,   
                       WRK-FLAG-ERRO,
                       WRK-MSG-ERRO
           END-CALL.

           IF WRK-FLAG-ERRO NOT EQUAL ZERO THEN 
               PERFORM PROC-RETORNAR-RESPOSTA-HTTP-500
           END-IF.
       
       PROC-RETORNAR-RESPOSTA-HTTP-200.
           
           DISPLAY '{'.
           DISPLAY '"http-status": ' WRK-HTTP-STATUS-200 ','.
           DISPLAY '"msg": null,'.
           DISPLAY '"data":'.
               DISPLAY '{'.
               DISPLAY '   "qtd-registros": "' 
                            FUNCTION trim(WRK-QTD-REGISTRO) '"'.
               DISPLAY "}".
           DISPLAY "}".
