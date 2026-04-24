{{ config(
    materialized='incremental',
    unique_key='order_dtl_id'
) }}

select
    -- identificação
    cast(JSON_VALUE(_raw, '$.id')                                   as INT64)       as order_dtl_id,
    cast(JSON_VALUE(_raw, '$.order_id.id')                          as INT64)       as order_id,
    JSON_VALUE(_raw, '$.order_id.key')                                              as order_nbr,
    cast(JSON_VALUE(_raw, '$.seq_nbr')                              as INT64)       as seq_nbr,
    JSON_VALUE(_raw, '$.order_dtl_original_seq_nbr')                               as order_dtl_original_seq_nbr,

    -- item
    cast(JSON_VALUE(_raw, '$.item_id.id')                           as INT64)       as item_id,
    JSON_VALUE(_raw, '$.item_id.key')                                               as item_code,
    JSON_VALUE(_raw, '$.orig_item_code')                                            as orig_item_code,

    -- status
    cast(JSON_VALUE(_raw, '$.status_id')                            as INT64)       as status_id,

    -- quantidades
    cast(JSON_VALUE(_raw, '$.ord_qty')                              as FLOAT64)     as ord_qty,
    cast(JSON_VALUE(_raw, '$.orig_ord_qty')                         as FLOAT64)     as orig_ord_qty,
    cast(JSON_VALUE(_raw, '$.alloc_qty')                            as FLOAT64)     as alloc_qty,
    cast(JSON_VALUE(_raw, '$.ordered_uom_qty')                      as FLOAT64)     as ordered_uom_qty,

    -- uom
    JSON_VALUE(_raw, '$.uom_id.key')                                                as uom,
    JSON_VALUE(_raw, '$.ordered_uom_id.key')                                        as ordered_uom,

    -- valores financeiros
    cast(JSON_VALUE(_raw, '$.cost')                                 as FLOAT64)     as cost,
    cast(JSON_VALUE(_raw, '$.sale_price')                           as FLOAT64)     as sale_price,
    cast(JSON_VALUE(_raw, '$.unit_declared_value')                  as FLOAT64)     as unit_declared_value,
    cast(JSON_VALUE(_raw, '$.voucher_amount')                       as FLOAT64)     as voucher_amount,
    JSON_VALUE(_raw, '$.voucher_nbr')                                               as voucher_nbr,
    date(JSON_VALUE(_raw, '$.voucher_exp_date'))                                    as voucher_exp_date,
    cast(JSON_VALUE(_raw, '$.voucher_print_count')                  as INT64)       as voucher_print_count,

    -- tolerâncias de envio
    cast(JSON_VALUE(_raw, '$.min_shipping_tolerance_percentage')    as FLOAT64)     as min_shipping_tolerance_pct,
    cast(JSON_VALUE(_raw, '$.max_shipping_tolerance_percentage')    as FLOAT64)     as max_shipping_tolerance_pct,

    -- referências e rastreabilidade
    JSON_VALUE(_raw, '$.po_nbr')                                                    as po_nbr,
    JSON_VALUE(_raw, '$.shipment_nbr')                                              as shipment_nbr,
    JSON_VALUE(_raw, '$.ref_nbr_1')                                                 as ref_nbr_1,
    JSON_VALUE(_raw, '$.req_cntr_nbr')                                              as req_cntr_nbr,
    JSON_VALUE(_raw, '$.host_ob_lpn_nbr')                                           as host_ob_lpn_nbr,
    JSON_VALUE(_raw, '$.serial_nbr')                                                as serial_nbr,
    JSON_VALUE(_raw, '$.lock_code')                                                 as lock_code,
    JSON_VALUE(_raw, '$.ship_request_line')                                         as ship_request_line,
    JSON_VALUE(_raw, '$.externally_planned_load_nbr')                              as externally_planned_load_nbr,
    JSON_VALUE(_raw, '$.planned_parcel_shipment_nbr')                              as planned_parcel_shipment_nbr,
    JSON_VALUE(_raw, '$.erp_source_line_ref')                                       as erp_source_line_ref,
    JSON_VALUE(_raw, '$.erp_source_shipment_ref')                                  as erp_source_shipment_ref,
    JSON_VALUE(_raw, '$.erp_fulfillment_line_ref')                                 as erp_fulfillment_line_ref,

    -- destino
    JSON_VALUE(_raw, '$.dest_facility_attr_a')                                      as dest_facility_attr_a,
    JSON_VALUE(_raw, '$.dest_facility_attr_b')                                      as dest_facility_attr_b,
    JSON_VALUE(_raw, '$.dest_facility_attr_c')                                      as dest_facility_attr_c,

    -- atributos de inventário
    JSON_VALUE(_raw, '$.invn_attr_id.key')                                          as invn_attr,
    JSON_VALUE(_raw, '$.vas_activity_code')                                         as vas_activity_code,
    JSON_VALUE(_raw, '$.spl_instr')                                                 as spl_instr,
    JSON_VALUE(_raw, '$.internal_text_field_1')                                     as internal_text_field_1,
    JSON_VALUE(_raw, '$.req_pallet_nbr')                                            as req_pallet_nbr,

    -- campos customizados
    JSON_VALUE(_raw, '$.cust_field_1')                                              as cust_field_1,
    JSON_VALUE(_raw, '$.cust_field_2')                                              as cust_field_2,
    JSON_VALUE(_raw, '$.cust_field_3')                                              as cust_field_3,
    JSON_VALUE(_raw, '$.cust_field_4')                                              as cust_field_4,
    JSON_VALUE(_raw, '$.cust_field_5')                                              as cust_field_5,
    cast(JSON_VALUE(_raw, '$.cust_number_1')                        as INT64)       as cust_number_1,
    cast(JSON_VALUE(_raw, '$.cust_number_2')                        as INT64)       as cust_number_2,
    cast(JSON_VALUE(_raw, '$.cust_number_3')                        as INT64)       as cust_number_3,
    cast(JSON_VALUE(_raw, '$.cust_number_4')                        as INT64)       as cust_number_4,
    cast(JSON_VALUE(_raw, '$.cust_number_5')                        as INT64)       as cust_number_5,
    cast(JSON_VALUE(_raw, '$.cust_decimal_1')                       as FLOAT64)     as cust_decimal_1,
    cast(JSON_VALUE(_raw, '$.cust_decimal_2')                       as FLOAT64)     as cust_decimal_2,
    cast(JSON_VALUE(_raw, '$.cust_decimal_3')                       as FLOAT64)     as cust_decimal_3,
    cast(JSON_VALUE(_raw, '$.cust_decimal_4')                       as FLOAT64)     as cust_decimal_4,
    cast(JSON_VALUE(_raw, '$.cust_decimal_5')                       as FLOAT64)     as cust_decimal_5,
    date(JSON_VALUE(_raw, '$.cust_date_1'))                                         as cust_date_1,
    date(JSON_VALUE(_raw, '$.cust_date_2'))                                         as cust_date_2,
    date(JSON_VALUE(_raw, '$.cust_date_3'))                                         as cust_date_3,
    date(JSON_VALUE(_raw, '$.cust_date_4'))                                         as cust_date_4,
    date(JSON_VALUE(_raw, '$.cust_date_5'))                                         as cust_date_5,
    JSON_VALUE(_raw, '$.cust_short_text_1')                                        as cust_short_text_1,
    JSON_VALUE(_raw, '$.cust_short_text_2')                                        as cust_short_text_2,
    JSON_VALUE(_raw, '$.cust_short_text_3')                                        as cust_short_text_3,
    JSON_VALUE(_raw, '$.cust_short_text_4')                                        as cust_short_text_4,
    JSON_VALUE(_raw, '$.cust_short_text_5')                                        as cust_short_text_5,
    JSON_VALUE(_raw, '$.cust_short_text_6')                                        as cust_short_text_6,
    JSON_VALUE(_raw, '$.cust_short_text_7')                                        as cust_short_text_7,
    JSON_VALUE(_raw, '$.cust_short_text_8')                                        as cust_short_text_8,
    JSON_VALUE(_raw, '$.cust_short_text_9')                                        as cust_short_text_9,
    JSON_VALUE(_raw, '$.cust_short_text_10')                                       as cust_short_text_10,
    JSON_VALUE(_raw, '$.cust_short_text_11')                                       as cust_short_text_11,
    JSON_VALUE(_raw, '$.cust_short_text_12')                                       as cust_short_text_12,
    JSON_VALUE(_raw, '$.cust_long_text_1')                                         as cust_long_text_1,
    JSON_VALUE(_raw, '$.cust_long_text_2')                                         as cust_long_text_2,
    JSON_VALUE(_raw, '$.cust_long_text_3')                                         as cust_long_text_3,

    -- auditoria
    JSON_VALUE(_raw, '$.create_user')                                               as create_user,
    timestamp(JSON_VALUE(_raw, '$.create_ts'))                                      as create_ts,
    JSON_VALUE(_raw, '$.mod_user')                                                  as mod_user,
    timestamp(JSON_VALUE(_raw, '$.mod_ts'))                                         as mod_ts,

    -- metadados da ingestão
    _ingested_at

from {{ source('bronze', 'wms_order_dtl') }}

{% if is_incremental() %}
where _ingested_at > (select max(_ingested_at) from {{ this }})
{% endif %}