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

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           
           PERFORM 1000-CONFIGURAR-HTTP-HEADERS.
           PERFORM 2000-CHAMA-MOD-TESTA-CALL.
           PERFORM 3000-MONTA-JSON-RETORNO.
           STOP RUN.
       
       1000-CONFIGURAR-HTTP-HEADERS.    
           DISPLAY "Access-Control-Allow-Origin: *".
           DISPLAY "Content-type: application/json".
           DISPLAY WRK-NEWLINE. 

       2000-CHAMA-MOD-TESTA-CALL.
           CALL 'MOD-TESTA-CALL' USING WRK-RETURN END-CALL.
       
       3000-MONTA-JSON-RETORNO. 
           DISPLAY '{'.
           DISPLAY '  "retorno": "' FUNCTION trim(WRK-RETURN) '",'.      
           DISPLAY '}'.
