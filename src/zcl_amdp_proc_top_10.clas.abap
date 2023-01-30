CLASS zcl_amdp_proc_top_10 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
**********************************************************************
* Interface if_amdp_marker_hdb has to be defined in the public section

* The typing of the parameters cannot be generic. Only elementary data types and table types with a
* structured row type can be used. The row type of a tabular type can only contain elementary data
* types as components.

* The parameters must be declared using VALUE for pass by value. Pass by reference is not permitted.

* Return values cannot be declared using RETURNING.

* Only input parameters can be flagged as optional and every optional parameter must have a
* replacement parameter declared using DEFAULT. Only literals or constants can be specified as
* replacement parameters.

**********************************************************************
    TYPES: begin of ty_cust,
             cust_id type /dmo/customer_id,
             flight_price type /dmo/flight_price,
           end of ty_cust,
           tt_cust type STANDARD TABLE OF ty_cust.
    INTERFACES: if_amdp_marker_hdb.

* AMDP does not support automatic client handling. When accessing client-specific database tables
* or views in an AMDP method, the required client ID must be selected explicitly. Therefore, the
* parameter interface of an AMDP method must usually contain an input parameter for the client ID,
* and this must be used in a WHERE condition.
* In SQLScript implementations, the built-in function SESSION_CONTEXT can be used to access the
* ABAP-specific session variables CLIENT and CDS_CLIENT of the SAP HANA database. CLIENT always
* contains the nominal value of the ABAP system field sy-mandt. CDS_CLIENT contains the same value
* as CLIENT by default, but can be modified during the execution of an Open SQL statement by the
* addition USING CLIENT and in an AMDP method call from ABAP by the addition AMDP OPTIONS CDS SESSION CLIENT.


    METHODS: GET_cust_detail
       AMDP OPTIONS READ-ONLY
       CDS SESSION CLIENT current
        IMPORTING
             VALUE(i_num) type i
             VALUE(i_mandt) type mandt
        EXPORTING
             VALUE(et_cust) type tt_cust.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_amdp_proc_top_10 IMPLEMENTATION.
  METHOD get_cust_detail BY DATABASE PROCEDURE
                          FOR HDB
                          LANGUAGE SQLSCRIPT
                          USING ZCDS_VIEW_TRAVEL_INNER_JOIN.
* Implicit client handling happen when the data is fetched from CDS View Entities
* WHERE mandt = session_context( 'CDS_CLIENT' ). So good to pass the same value for
* CDS SESSION CLIENT and the importing parameter  i_mandt.

    et_cust = SELECT TOP :i_num customer_id AS cust_id,
                          SUM ( flight_price ) AS flight_price
                         FROM  ZCDS_VIEW_TRAVEL_INNER_JOIN
                         WHERE mandt = :i_mandt
                         GROUP BY customer_id
                         ORDER BY flight_price desc;
  ENDMETHOD.

ENDCLASS.


