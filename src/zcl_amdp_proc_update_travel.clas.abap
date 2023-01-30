CLASS zcl_amdp_proc_update_travel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_travel,
             client         type sy-mandt,
             travel_id      type /dmo/travel_id,
             agency_id      type /dmo/agency_id,
             customer_id    type /dmo/customer_id,
             booking_fee    type /dmo/booking_fee,
             total_price    type /dmo/total_price,
             currency_code  type /dmo/currency_code,
           END of ty_travel,
           tt_travel TYPE STANDARD TABLE OF ty_travel.
    INTERFACES: if_amdp_marker_hdb.

    CLASS-METHODS update_travel_details
      IMPORTING
        VALUE(i_mandt) TYPE sy-mandt
        VALUE(i_travel_id) type /dmo/travel_id
      EXPORTING
        VALUE(et_travel) TYPE tt_travel.

  PROTECTED SECTION.

* Internally, the database procedure uses an identically named output parameter to which
* the initial value of the CHANGING parameter is assigned (using the invisible IN parameter
* et_travel__in__) when the procedure is first executed.

  PRIVATE SECTION.
    CLASS-METHODS update_travel_details_priv
    AMDP OPTIONS READ-ONLY
      IMPORTING
        VALUE(i_mandt) TYPE sy-mandt
        VALUE(i_travel_id) type /dmo/travel_id
      CHANGING
        VALUE(et_travel) TYPE tt_travel.

ENDCLASS.

CLASS zcl_amdp_proc_update_travel IMPLEMENTATION.

  METHOD update_travel_details_priv BY DATABASE PROCEDURE
                          FOR HDB
                          LANGUAGE SQLSCRIPT
                          USING ztravel_00.

*    UPDATE ZTRAVEL_00 SET BOOKLING_FEE = 20
*                       WHERE mandt = :i_mandt
*                        and travel_id = :i_travel_id;

    et_travel = SELECT client,
                       travel_id,
                       agency_id  ,
                       customer_id ,
                       booking_fee  ,
                       total_price ,
                       currency_code
                  FROM ZTRAVEL_00
                  WHERE client = :i_mandt
                    and travel_id = :i_travel_id;

  ENDMETHOD.

  METHOD update_travel_details BY DATABASE PROCEDURE
                                  FOR HDB
                                  LANGUAGE SQLSCRIPT
                                  OPTIONS READ-ONLY
                                  USING ZCL_AMDP_PROC_UPDATE_TRAVEL=>UPDATE_TRAVEL_DETAILS_PRIV.
        call "ZCL_AMDP_PROC_UPDATE_TRAVEL=>UPDATE_TRAVEL_DETAILS_PRIV"(
                 i_mandt     => :i_mandt,
                 i_travel_id => :I_TRAVEL_id    ,
                 et_travel__in__ => :ET_TRAVEL,
                 et_travel   => :ET_TRAVEL
             );

  ENDMETHOD.

ENDCLASS.


