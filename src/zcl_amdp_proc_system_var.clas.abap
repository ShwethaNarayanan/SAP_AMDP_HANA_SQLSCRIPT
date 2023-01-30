CLASS zcl_amdp_proc_system_var DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

      TYPES: begin of ty_session_var,
              client type sy-mandt,
              cds_clnt type sy-mandt,
              uname type sy-uname,
              lang type sy-langu,
              date type sy-datum,
           end of ty_session_var,
           tt_session_var type STANDARD TABLE OF ty_session_var.
    INTERFACES: if_amdp_marker_hdb.

* If we pass the "current" client as the CDS SESSION CLIENT we need not pass the Importing parameter
* However, if we wish to retrieve data for a different client, then we need pas the same value for
* CDS SESSION CLIENT and IMPORTING client.

    CLASS-METHODS get_session_variable
        AMDP OPTIONS READ-ONLY
                     CDS SESSION CLIENT i_clnt
        IMPORTING
            VALUE(i_clnt) type sy-mandt
        EXPORTING
            value(e_client) type ty_session_var-CLient
            value(e_cds_clnt) type ty_session_var-cds_clnt
            value(e_uname) type ty_session_var-uname
            value(e_lang) type ty_session_var-lang
            value(e_date) type ty_session_var-date
        RAISING
            cx_amdp_execution_error.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_amdp_proc_system_var IMPLEMENTATION.
  METHOD get_session_variable BY DATABASE PROCEDURE
                               FOR HDB
                               LANGUAGE SQLSCRIPT
                               OPTIONS READ-ONLY.

    e_client := session_context( 'CLIENT' );
    e_cds_clnt := session_context( 'CDS_CLIENT' );
    e_uname := session_context( 'APPLICATIONUSER' );
    e_lang := session_context( 'LOCALE_SAP' );
    e_date := session_context( 'SAP_SYSTEM_DATE' );

  ENDMETHOD.

ENDCLASS.
