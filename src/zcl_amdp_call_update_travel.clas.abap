CLASS zcl_amdp_call_update_travel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_amdp_call_update_travel IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    zcl_amdp_proc_update_travel=>update_travel_details(
      EXPORTING
        i_mandt     = sy-mandt
        i_travel_id = '00000107'
      IMPORTING
        et_travel   = data(lt_travel)
    ).

    out->write( lt_travel )   .

  ENDMETHOD.
ENDCLASS.
