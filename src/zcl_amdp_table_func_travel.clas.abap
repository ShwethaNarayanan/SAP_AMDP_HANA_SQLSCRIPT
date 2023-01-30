CLASS zcl_amdp_table_func_travel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: begin of ty_travel,
              carrier_id      type /dmo/carrier_id,
              connection_id   type /dmo/connection_id,
              flight_date     type /dmo/flight_date,
              price           type /dmo/flight_price,
              currency_code   type /dmo/currency_code,
              airport_from_id type /dmo/airport_from_id,
              airport_to_id   type /dmo/airport_to_id,
              distance        type /dmo/flight_distance,
              distance_unit   type msehi,
           end of ty_travel,
           tt_travel type STANDARD TABLE OF ty_travel WITH KEY carrier_id.
    INTERFACES: if_amdp_marker_hdb.
* Create an AMDP Procedure to call the AMDP function
        CLASS-METHODS: GET_travel_detail_proc
            IMPORTING
                 VALUE(i_mandt) type sy-mandt
                 VALUE(i_carrier_id) type /dmo/carrier_id
            EXPORTING
                 VALUE(et_travel) type tt_travel.


  PROTECTED SECTION.
  PRIVATE SECTION.
* AMDP table function cannot be called from a Report program. It can only  be called from
* another AMDP method. AMDP table function returns a table. AMDP function has RETURNING parameter
* not EXPORTING.
        CLASS-METHODS: GET_travel_detail_fun
            IMPORTING
                 VALUE(i_mandt) type sy-mandt
                 VALUE(i_carrier_id) type /dmo/carrier_id
            RETURNING
                 VALUE(et_travel) type tt_travel.
ENDCLASS.



CLASS zcl_amdp_table_func_travel IMPLEMENTATION.


  METHOD get_travel_detail_fun BY DATABASE FUNCTION
                            FOR HDB
                            LANGUAGE SQLSCRIPT
                            OPTIONS READ-ONLY
                            USING /dmo/flight /dmo/connection.

    RETURN SELECT fl.carrier_id,
                  fl.connection_id,
                  fl.flight_date,
                  fl.price,
                  fl.currency_code,
                  con.airport_from_id,
                  con.airport_to_id,
                  con.distance,
                  con.distance_unit
                  FROM  "/DMO/FLIGHT" as fl
                    INNER JOIN "/DMO/CONNECTION" as con
                    ON fl.carrier_id = con.carrier_id and
                       fl.connection_id    = con.connection_id
                  WHERE fl.client = :i_mandt
                    and fl.carrier_id = :i_carrier_id;
  ENDMETHOD.

  METHOD get_travel_detail_proc BY DATABASE PROCEDURE
                                     FOR HDB
                                     LANGUAGE SQLSCRIPT
                                     OPTIONS READ-ONLY
                                     USING ZCL_AMDP_TABLE_FUNC_TRAVEL=>GET_TRAVEL_DETAIL_FUN.

* AMDP table function cannot be called using the CALL statement. it has to be called in the
* FROM caluse in the SELECT statement. The function name should be listed in the USING clause.

        et_travel = SELECT *
                        FROM "ZCL_AMDP_TABLE_FUNC_TRAVEL=>GET_TRAVEL_DETAIL_FUN"(
                            i_mandt     => :i_mandt,
                            i_carrier_id => :i_carrier_id    ) ;
  ENDMETHOD.

ENDCLASS.
