CLASS zcl_amdp_scalar_func_travel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_travel,
             carrier_id      TYPE /dmo/carrier_id,
             connection_id   TYPE /dmo/connection_id,
             airport_from_id TYPE /dmo/airport_from_id,
             airport_to_id   TYPE /dmo/airport_to_id,
             distance        TYPE /dmo/flight_distance,
             distance_unit   TYPE msehi,
           END OF ty_travel,
           tt_travel TYPE STANDARD TABLE OF ty_travel WITH KEY carrier_id.
    INTERFACES: if_amdp_marker_hdb.

* Scalar function returns a scalar value(elementary data type). It can be called from
* from a program or from another AMDP method.
    CLASS-METHODS GET_dist_scalar_fun
      IMPORTING
        VALUE(i_mandt)      TYPE sy-mandt
        VALUE(i_carrier_id) TYPE /dmo/carrier_id
      RETURNING
        VALUE(e_dist)       TYPE /dmo/flight_distance.

    CLASS-METHODS get_travel_details_maxdist
      IMPORTING
        VALUE(i_mandt)   TYPE    sy-mandt
        VALUE(i_carrier_id) TYPE /dmo/carrier_id
      EXPORTING
        VALUE(et_travel) TYPE  tt_travel .


PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_amdp_scalar_func_travel IMPLEMENTATION.

  METHOD get_dist_scalar_fun BY DATABASE FUNCTION
                               FOR HDB
                               LANGUAGE SQLSCRIPT
                               OPTIONS READ-ONLY
                               USING /dmo/connection.

* The value retrieved from the select will have to be sent using the into clause.
* Assigning it to an export variable will not work.

    SELECT MAX( distance )
              INTO e_dist
                FROM "/DMO/CONNECTION"
                where CLIENT = :i_mandt
                 and carrier_id = :i_carrier_id;

  ENDMETHOD.

  METHOD get_travel_details_maxdist BY DATABASE PROCEDURE
                                    FOR HDB
                                    LANGUAGE SQLSCRIPT
                                    OPTIONS READ-ONLY
                                    USING /dmo/connection zcl_amdp_scalar_func_travel=>get_dist_scalar_fun.

    et_travel = select con.carrier_id ,
                       con.connection_id,
                       con.airport_from_id ,
                       con.airport_to_id  ,
                       con.distance,
                       con.distance_unit
                      FROM "/DMO/CONNECTION" as  con
                       WHERE  con.client = :i_mandt
                        and  con.distance = "ZCL_AMDP_SCALAR_FUNC_TRAVEL=>GET_DIST_SCALAR_FUN"(
                                             i_mandt      => :i_mandt ,
                                             i_carrier_id => :i_carrier_id );

  ENDMETHOD.

ENDCLASS.
