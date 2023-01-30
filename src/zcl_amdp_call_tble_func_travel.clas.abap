CLASS zcl_amdp_call_tble_func_travel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_amdp_call_tble_func_travel IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    ZCL_AMDP_TABLE_FUNC_TRAVEL=>get_travel_detail_proc(
      EXPORTING
        i_mandt      = sy-mandt
        i_carrier_id = 'AA'
      IMPORTING
        et_travel    = DATA(lt_travel)
    ).

    out->write( lt_travel )   .

  ENDMETHOD.
ENDCLASS.
