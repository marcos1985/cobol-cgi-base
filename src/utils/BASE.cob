       IDENTIFICATION DIVISION.
       PROGRAM-ID. BASE.
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

       PROCEDURE DIVISION.

       MAIN-PROCEDURE.
           
           PERFORM 1000-CONFIGURAR-HTTP-HEADERS.

           DISPLAY "BASE".

           STOP RUN.
           
       1000-CONFIGURAR-HTTP-HEADERS.
      * Informa cabeçalhos da requisição.    
           DISPLAY "Access-Control-Allow-Origin: *".
           DISPLAY "Content-type: application/json".
           DISPLAY WRK-NEWLINE.