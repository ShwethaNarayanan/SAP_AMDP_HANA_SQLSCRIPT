@EndUserText.label: 'AMDP CDS Table function'
@ClientHandling.type: #CLIENT_DEPENDENT
define table function ZCDS_AMDP_CDS_TABLE_FUNC
   with parameters 
// To restrict the data based on CLIENT. 
// Environment field is used to pass a default value. This cannot be used for client 
// independent CDS table functions . The parameter client and the return value client 
// cannot have the same name in case of client independent tables as it is in the same namespace.
   @Environment.systemField: #CLIENT
   client   : abap.clnt
returns {
// Client field will not be displayed in the output for client dependent tables.
// This field will be displayed for the client independent tables.
  client : abap.clnt;
  carrier_id : /dmo/carrier_id;
  
}
implemented by method zcl_amdp_cds_table_func=>get_travel_details;