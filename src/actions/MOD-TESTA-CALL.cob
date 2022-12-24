       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD-TESTA-CALL.
      *******************************************
      * AUTOR: 
      * DATA: 
      ******************************************* 
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       
       DATA DIVISION.
      
       FILE SECTION.

       LINKAGE SECTION.
       77  LS-RETURN    PIC X(255).

       PROCEDURE DIVISION USING LS-RETURN.
       
       MAIN-PROCEDURE.
           MOVE "QWYTYQTWYTQY WWW" TO LS-RETURN.    
       EXIT PROGRAM.
