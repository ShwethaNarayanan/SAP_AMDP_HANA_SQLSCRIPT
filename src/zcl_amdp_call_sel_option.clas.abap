CLASS zcl_amdp_call_sel_option DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_amdp_call_sel_option IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: lt_travel_range    TYPE RANGE OF /dmo/travel_id.

    lt_travel_range = VALUE #( LET s = 'I'
                                   o = 'EQ'
                               IN sign   = s
                                  option = o
                                ( low = '00000107'
                                  high = '00000239' ) ).

*try.
*   cl_shdb_seltab=>combine_seltabs(
*     EXPORTING
*       it_named_seltabs = VALUE #( ( name = 'TRAVEL_ID' dref = REF #( lt_travel_range ) ) )
***       iv_client_field  =
*     RECEIVING
*       rv_where         = DATA(LV_WHERE)
*   ).
*   CATCH cx_shdb_exception into data(l_msg).
*ENDTRY.

    zcl_amdp_proc_update_travel=>update_travel_details(
      EXPORTING
        i_mandt     = sy-mandt
        i_travel_id = '00000107'
      IMPORTING
        et_travel   = DATA(lt_travel)
    ).

    out->write( lt_travel )   .

  ENDMETHOD.
ENDCLASS.
