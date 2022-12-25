       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROG-CHAMADA-EXTERNA.
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

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           
           PERFORM PROC-SETAR-CABECALHO-HTTP.
           PERFORM PROC-CHAMA-MOD-TESTA-CALL.
           PERFORM PROC-RETORNAR-RESPOSTA-HTTP-200.
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
           CALL 'MOD-TESTA-CALL' USING WRK-RETURN END-CALL.
       
       PROC-RETORNAR-RESPOSTA-HTTP-200.
           
           DISPLAY '{'.
           DISPLAY '"http-status": ' WRK-HTTP-STATUS-200 ','.
           DISPLAY '"msg": null,'.
           DISPLAY '"data":'.
               DISPLAY '{'.
               DISPLAY '   "retorno": "' 
                            FUNCTION trim(WRK-RETURN) '"'.
               DISPLAY "}".
           DISPLAY "}".