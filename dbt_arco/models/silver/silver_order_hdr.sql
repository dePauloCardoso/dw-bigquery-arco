{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

select
    -- identificação
    cast(JSON_VALUE(_raw, '$.id')                           as INT64)       as order_id,
    JSON_VALUE(_raw, '$.order_nbr')                                         as order_nbr,
    JSON_VALUE(_raw, '$.ref_nbr')                                           as ref_nbr,
    JSON_VALUE(_raw, '$.sales_order_nbr')                                   as sales_order_nbr,
    JSON_VALUE(_raw, '$.customer_po_nbr')                                   as customer_po_nbr,
    JSON_VALUE(_raw, '$.customer_po_type')                                  as customer_po_type,
    JSON_VALUE(_raw, '$.customer_vendor_code')                              as customer_vendor_code,
    JSON_VALUE(_raw, '$.erp_source_hdr_ref')                               as erp_source_hdr_ref,
    JSON_VALUE(_raw, '$.erp_source_system_ref')                            as erp_source_system_ref,
    JSON_VALUE(_raw, '$.tms_order_hdr_ref')                                as tms_order_hdr_ref,
    JSON_VALUE(_raw, '$.group_ref')                                         as group_ref,

    -- status e tipo
    cast(JSON_VALUE(_raw, '$.status_id')                    as INT64)       as status_id,
    cast(JSON_VALUE(_raw, '$.priority')                     as INT64)       as priority,
    JSON_VALUE(_raw, '$.order_type_id.key')                                 as order_type,
    cast(JSON_VALUE(_raw, '$.order_type_id.id')             as INT64)       as order_type_id,
    JSON_VALUE(_raw, '$.sales_channel')                                     as sales_channel,
    JSON_VALUE(_raw, '$.record_origin_code')                               as record_origin_code,

    -- facility e empresa
    JSON_VALUE(_raw, '$.facility_id.key')                                   as facility,
    cast(JSON_VALUE(_raw, '$.facility_id.id')               as INT64)       as facility_id,
    JSON_VALUE(_raw, '$.company_id.key')                                    as company,
    cast(JSON_VALUE(_raw, '$.company_id.id')                as INT64)       as company_id,
    JSON_VALUE(_raw, '$.destination_company_id.key')                       as destination_company,

    -- datas
    date(JSON_VALUE(_raw, '$.ord_date'))                                    as ord_date,
    date(JSON_VALUE(_raw, '$.req_ship_date'))                               as req_ship_date,
    date(JSON_VALUE(_raw, '$.exp_date'))                                    as exp_date,
    date(JSON_VALUE(_raw, '$.start_ship_date'))                             as start_ship_date,
    date(JSON_VALUE(_raw, '$.stop_ship_date'))                              as stop_ship_date,
    date(JSON_VALUE(_raw, '$.sched_ship_date'))                             as sched_ship_date,
    timestamp(JSON_VALUE(_raw, '$.order_shipped_ts'))                      as order_shipped_ts,
    timestamp(JSON_VALUE(_raw, '$.create_ts'))                              as create_ts,
    timestamp(JSON_VALUE(_raw, '$.mod_ts'))                                 as mod_ts,
    JSON_VALUE(_raw, '$.create_user')                                       as create_user,
    JSON_VALUE(_raw, '$.mod_user')                                          as mod_user,

    -- cliente (bill to)
    JSON_VALUE(_raw, '$.cust_nbr')                                          as cust_nbr,
    JSON_VALUE(_raw, '$.cust_name')                                         as cust_name,
    JSON_VALUE(_raw, '$.cust_addr')                                         as cust_addr,
    JSON_VALUE(_raw, '$.cust_addr2')                                        as cust_addr2,
    JSON_VALUE(_raw, '$.cust_addr3')                                        as cust_addr3,
    JSON_VALUE(_raw, '$.cust_city')                                         as cust_city,
    JSON_VALUE(_raw, '$.cust_state')                                        as cust_state,
    JSON_VALUE(_raw, '$.cust_zip')                                          as cust_zip,
    JSON_VALUE(_raw, '$.cust_country')                                      as cust_country,
    JSON_VALUE(_raw, '$.cust_phone_nbr')                                    as cust_phone_nbr,
    JSON_VALUE(_raw, '$.cust_email')                                        as cust_email,
    JSON_VALUE(_raw, '$.cust_contact')                                      as cust_contact,

    -- destinatário (ship to)
    JSON_VALUE(_raw, '$.shipto_name')                                       as shipto_name,
    JSON_VALUE(_raw, '$.shipto_addr')                                       as shipto_addr,
    JSON_VALUE(_raw, '$.shipto_addr2')                                      as shipto_addr2,
    JSON_VALUE(_raw, '$.shipto_addr3')                                      as shipto_addr3,
    JSON_VALUE(_raw, '$.shipto_city')                                       as shipto_city,
    JSON_VALUE(_raw, '$.shipto_state')                                      as shipto_state,
    JSON_VALUE(_raw, '$.shipto_zip')                                        as shipto_zip,
    JSON_VALUE(_raw, '$.shipto_country')                                    as shipto_country,
    JSON_VALUE(_raw, '$.shipto_phone_nbr')                                  as shipto_phone_nbr,
    JSON_VALUE(_raw, '$.shipto_email')                                      as shipto_email,
    JSON_VALUE(_raw, '$.shipto_contact')                                    as shipto_contact,

    -- logística
    JSON_VALUE(_raw, '$.route_nbr')                                         as route_nbr,
    JSON_VALUE(_raw, '$.external_route')                                    as external_route,
    JSON_VALUE(_raw, '$.ship_via_ref_code')                                 as ship_via_ref_code,
    JSON_VALUE(_raw, '$.carrier_account_nbr')                              as carrier_account_nbr,
    JSON_VALUE(_raw, '$.billto_carrier_account_nbr')                       as billto_carrier_account_nbr,
    JSON_VALUE(_raw, '$.currency_code')                                     as currency_code,
    JSON_VALUE(_raw, '$.host_allocation_nbr')                              as host_allocation_nbr,
    cast(JSON_VALUE(_raw, '$.externally_planned_load_flg')  as BOOL)        as externally_planned_load_flg,
    cast(JSON_VALUE(_raw, '$.stop_ship_flg')                as BOOL)        as stop_ship_flg,

    -- totais
    cast(JSON_VALUE(_raw, '$.total_orig_ord_qty')           as FLOAT64)     as total_orig_ord_qty,
    cast(JSON_VALUE(_raw, '$.orig_sku_count')               as INT64)       as orig_sku_count,
    cast(JSON_VALUE(_raw, '$.orig_sale_price')              as FLOAT64)     as orig_sale_price,

    -- campos customizados
    JSON_VALUE(_raw, '$.cust_field_1')                                      as cust_field_1,
    JSON_VALUE(_raw, '$.cust_field_2')                                      as cust_field_2,
    JSON_VALUE(_raw, '$.cust_field_3')                                      as cust_field_3,
    JSON_VALUE(_raw, '$.cust_field_4')                                      as cust_field_4,
    JSON_VALUE(_raw, '$.cust_field_5')                                      as cust_field_5,
    cast(JSON_VALUE(_raw, '$.cust_number_1')                as INT64)       as cust_number_1,
    cast(JSON_VALUE(_raw, '$.cust_number_2')                as INT64)       as cust_number_2,
    cast(JSON_VALUE(_raw, '$.cust_number_3')                as INT64)       as cust_number_3,
    cast(JSON_VALUE(_raw, '$.cust_number_4')                as INT64)       as cust_number_4,
    cast(JSON_VALUE(_raw, '$.cust_number_5')                as INT64)       as cust_number_5,
    cast(JSON_VALUE(_raw, '$.cust_decimal_1')               as FLOAT64)     as cust_decimal_1,
    cast(JSON_VALUE(_raw, '$.cust_decimal_2')               as FLOAT64)     as cust_decimal_2,
    cast(JSON_VALUE(_raw, '$.cust_decimal_3')               as FLOAT64)     as cust_decimal_3,
    cast(JSON_VALUE(_raw, '$.cust_decimal_4')               as FLOAT64)     as cust_decimal_4,
    cast(JSON_VALUE(_raw, '$.cust_decimal_5')               as FLOAT64)     as cust_decimal_5,
    date(JSON_VALUE(_raw, '$.cust_date_1'))                                 as cust_date_1,
    date(JSON_VALUE(_raw, '$.cust_date_2'))                                 as cust_date_2,
    date(JSON_VALUE(_raw, '$.cust_date_3'))                                 as cust_date_3,
    date(JSON_VALUE(_raw, '$.cust_date_4'))                                 as cust_date_4,
    date(JSON_VALUE(_raw, '$.cust_date_5'))                                 as cust_date_5,
    JSON_VALUE(_raw, '$.cust_short_text_1')                                as cust_short_text_1,
    JSON_VALUE(_raw, '$.cust_short_text_2')                                as cust_short_text_2,
    JSON_VALUE(_raw, '$.cust_short_text_3')                                as cust_short_text_3,
    JSON_VALUE(_raw, '$.cust_short_text_4')                                as cust_short_text_4,
    JSON_VALUE(_raw, '$.cust_short_text_5')                                as cust_short_text_5,
    JSON_VALUE(_raw, '$.cust_long_text_1')                                 as cust_long_text_1,
    JSON_VALUE(_raw, '$.cust_long_text_2')                                 as cust_long_text_2,
    JSON_VALUE(_raw, '$.cust_long_text_3')                                 as cust_long_text_3,

    -- instruções e observações
    JSON_VALUE(_raw, '$.spl_instr')                                         as spl_instr,
    JSON_VALUE(_raw, '$.gift_msg')                                          as gift_msg,
    JSON_VALUE(_raw, '$.vas_group_code')                                    as vas_group_code,
    JSON_VALUE(_raw, '$.tms_parcel_shipment_nbr')                          as tms_parcel_shipment_nbr,

    -- metadados da ingestão
    _ingested_at

from {{ source('bronze', 'wms_order_hdr') }}

{% if is_incremental() %}
where _ingested_at > (select max(_ingested_at) from {{ this }})
{% endif %}

qualify row_number() over (
    partition by cast(JSON_VALUE(_raw, '$.id') as INT64)
    order by timestamp(JSON_VALUE(_raw, '$.mod_ts')) desc
) = 1