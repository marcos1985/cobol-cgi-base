       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROG-QUERY-STRING.
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
       77  WRK-ID-MASK                     PIC Z(8)9.

       77  WRK-ID-CLIENTE                  PIC 9(10).
       77  WRK-NOME-CLIENTE                PIC X(255).

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           
           PERFORM 1000-CONFIGURAR-HTTP-HEADERS.
           PERFORM 2000-RECEBER-PARAMETROS.
           PERFORM 3000-MONTA-JSON-RETORNO.
           STOP RUN.
           
       1000-CONFIGURAR-HTTP-HEADERS.
              
           DISPLAY "Access-Control-Allow-Origin: *".
           DISPLAY "Content-type: application/json".
           DISPLAY WRK-NEWLINE.

       2000-RECEBER-PARAMETROS.
           
           ACCEPT WRK-ID-CLIENTE FROM ENVIRONMENT "QS_ID".
           ACCEPT WRK-NOME-CLIENTE FROM ENVIRONMENT "QS_NOME".

       3000-MONTA-JSON-RETORNO.
           
           MOVE WRK-ID-CLIENTE TO WRK-ID-MASK.

           DISPLAY '{'.
           DISPLAY '   "id": ' WRK-ID-MASK ','.
           DISPLAY '   "nome": "' FUNCTION trim(WRK-NOME-CLIENTE) '"'.
           DISPLAY "}".
       
       

       
