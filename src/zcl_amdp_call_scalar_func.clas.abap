CLASS zcl_amdp_call_scalar_func DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_amdp_call_scalar_func IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    zcl_amdp_scalar_func_travel=>get_travel_details_maxdist(
      EXPORTING
        i_mandt   = sy-mandt
        i_carrier_id = 'AA'
      IMPORTING
        et_travel = DATA(lt_travel)
    ).


    zcl_amdp_scalar_func_travel=>get_dist_scalar_fun(
      EXPORTING
        i_mandt      = sy-mandt
        i_carrier_id = 'AA'
      RECEIVING
        e_dist       = DATA(lv_max_dist)
    ).

select carrier_id ,
       connection_id,
       airport_from_id ,
       airport_to_id  ,
       distance,
       distance_unit
       FROM /DMO/CONNECTION
       WHERE  carrier_id = 'AA'
         and  distance = @( ZCL_AMDP_SCALAR_FUNC_TRAVEL=>GET_DIST_SCALAR_FUN(
                                             i_mandt      = sy-mandt
                                             i_carrier_id = 'AA' ) )
       INto TABLE @data(lt_max_dist).

    out->write( lv_max_dist )   .

    out->write( lt_travel )   .

    out->write( lt_max_dist ).

  ENDMETHOD.
ENDCLASS.
