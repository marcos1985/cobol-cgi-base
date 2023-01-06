       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROG-RECEBE-JSON.
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

       77  WRK-ID-MASK                     PIC Z(9)9.
       
       77  WRK-MSG-ERRO                    PIC X(255).
       77  WRK-MSG-EXP-ERRO                PIC X(255).
       
       77  WRK-HTTP-STATUS-200             PIC 9(3)        VALUE 200.
       77  WRK-HTTP-STATUS-500             PIC 9(3)        VALUE 500.


       01  WRK-POST-DATA.
           05 PS-ID     PIC 9(10).
           05 PS-NOME   PIC X(255).


       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           
           PERFORM PROC-SETAR-CABECALHO-HTTP.
           PERFORM PROC-PROCESSAR-REQUEST-BODY.
           PERFORM PROC-RETORNAR-RESPOSTA-HTTP-200.
           STOP RUN.

       PROC-PROCESSAR-REQUEST-BODY.
           ACCEPT PS-ID    FROM ENVIRONMENT "PS_ID".
           ACCEPT PS-NOME  FROM ENVIRONMENT "PS_NOME".
           
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

       
       PROC-RETORNAR-RESPOSTA-HTTP-200.

           MOVE PS-ID TO WRK-ID-MASK.

           DISPLAY '{'.
           DISPLAY '"http-status": ' WRK-HTTP-STATUS-200 ','.
           DISPLAY '"msg": null,'.
           DISPLAY '"data": {'.
           DISPLAY '"id":' WRK-ID-MASK ','.
           DISPLAY '"nome": "' FUNCTION TRIM(PS-NOME) '"'.
           DISPLAY "}".
           DISPLAY "}".
       
      