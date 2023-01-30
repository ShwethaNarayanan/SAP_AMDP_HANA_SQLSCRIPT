CLASS zcl_amdp_call_cds_table_func DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_amdp_call_cds_table_func IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    select *
           from ZCDS_AMDP_CDS_TABLE_FUNC
           into TABLE @data(lt_carrier).

*    select *
*           from ZCDS_AMDP_CDS_TABLE_FUNC
*           USING CLIENT '200'
*           into TABLE @data(lt_carrier1).

    out->write( lt_carrier )   .

  ENDMETHOD.
ENDCLASS.
