CLASS zcl_amdp_proc_call_sys_var DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    DATA: ls_session_var TYPE zcl_amdp_proc_system_var=>ty_session_var .
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_amdp_proc_call_sys_var IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    TRY.
        zcl_amdp_proc_system_var=>get_session_variable(
          EXPORTING
            i_clnt     = '200'
          IMPORTING
            e_client   = ls_session_var-client
            e_cds_clnt = ls_session_var-cds_clnt
            e_uname    = ls_session_var-uname
            e_lang     = ls_session_var-lang
            e_date     = ls_session_var-date
        ).
      CATCH cx_amdp_execution_error INTO DATA(ls_msg).
        DATA(msg) = ls_msg->get_text(  ).
        out->write( msg )   .

    ENDTRY.

    out->write( ls_session_var )   .

  ENDMETHOD.
ENDCLASS.
