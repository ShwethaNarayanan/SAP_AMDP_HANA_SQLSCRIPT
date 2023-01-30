CLASS zcl_amdp_proc_call_top_10 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_amdp_proc_call_top_10 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA(lcl_amdp) = new zcl_amdp_proc_top_10(  ).

    lcl_amdp->get_cust_detail(
      EXPORTING
        i_num   = 5
        i_mandt = sy-mandt
      IMPORTING
        et_cust = data(lt_cust)
    ).

    out->write( lt_cust )   .

  ENDMETHOD.
ENDCLASS.
