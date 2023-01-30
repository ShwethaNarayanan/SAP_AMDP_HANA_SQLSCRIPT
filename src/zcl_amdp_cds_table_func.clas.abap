CLASS zcl_amdp_cds_table_func DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

   INTERFACES: if_amdp_marker_hdb.
   class-METHODS: get_travel_details
                    for table FUNCTION ZCDS_AMDP_CDS_TABLE_FUNC.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_amdp_cds_table_func IMPLEMENTATION.
  METHOD get_travel_details by DATABASE FUNCTION
                            FOR HDB
                            LANGUAGE SQLSCRIPT
                            OPTIONS READ-ONLY
                            using /dmo/flight.

      return select client,
                    carrier_id
                    FROM
                     "/DMO/FLIGHT"
                     WHERE client = :client;

  ENDMETHOD.

ENDCLASS.
