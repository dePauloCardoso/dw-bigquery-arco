{{ config(
    materialized='table'
) }}

SELECT
    h.facility                                          AS filial,
    FORMAT_DATE('%d/%m/%Y', DATE(d.create_ts))          AS dt_criacao,
    FORMAT_TIMESTAMP('%H:%M', d.create_ts)              AS hr_criacao,
    FORMAT_DATE('%d/%m/%Y', DATE(d.mod_ts))             AS dt_modificacao,
    FORMAT_TIMESTAMP('%H:%M', d.mod_ts)                 AS hr_modificacao,
    h.cust_short_text_1                                 AS ordem_frete,
    CAST(h.order_nbr AS INT64)                          AS remessa,
    d.item_code                                         AS item,
    CAST(d.ord_qty AS INT64)                            AS qtd_pedido,
    CAST(d.orig_ord_qty AS INT64)                       AS qtd_pedido_original,
    CAST(d.alloc_qty AS INT64)                          AS qtd_alocada,
    h.order_type                                        AS tipo_pedido,
    FORMAT_DATE('%d/%m/%Y', h.ord_date)                 AS dt_ordem,
    FORMAT_DATE('%d/%m/%Y', h.req_ship_date)            AS dt_embarque_obrigatoria,
    CASE
        WHEN h.status_id = 0  THEN 'Criado'
        WHEN h.status_id = 10 THEN 'Parcialmente alocado'
        WHEN h.status_id = 20 THEN 'Alocado'
        WHEN h.status_id = 25 THEN 'Em Separação'
        WHEN h.status_id = 27 THEN 'Separado'
        WHEN h.status_id = 30 THEN 'Em Conferência'
        WHEN h.status_id = 40 AND COALESCE(h.cust_field_2, '') <> '' THEN 'Faturado'
        WHEN h.status_id = 40 THEN 'Conferido'
        WHEN h.status_id = 50 THEN 'Carregado'
        WHEN h.status_id = 90 THEN 'Expedido'
        WHEN h.status_id = 99 THEN 'Cancelado'
        ELSE 'Desconhecido'
    END                                                 AS status_remessa,
    h.cust_name                                         AS nome_cliente,
    h.cust_addr                                         AS endereco_cliente,
    h.cust_addr2                                        AS numero_end_cliente,
    h.cust_city                                         AS cidade_cliente,
    h.cust_state                                        AS estado_cliente,
    h.cust_zip                                          AS cep_cliente,
    h.cust_nbr                                          AS cod_cliente,
    h.shipto_name                                       AS cliente_entrega,
    h.shipto_addr                                       AS endereco_entrega,
    h.shipto_addr2                                      AS numero_entrega,
    h.shipto_city                                       AS cidade_cliente_entrega,
    h.shipto_state                                      AS estado_cliente_entrega,
    h.shipto_zip                                        AS cep_cliente_entrega,
    h.priority                                          AS prioridade,
    FORMAT_DATE('%d/%m/%Y', DATE(h.order_shipped_ts))   AS data_expedicao,
    h.cust_field_2                                      AS nota_fiscal,
    FORMAT_DATE('%d/%m/%Y', h.cust_date_1)              AS dt_faturamento,
    h.cust_short_text_2                                 AS erro_zero,
    h.cust_long_text_1                                  AS transportadora,
    h.cust_long_text_2                                  AS tipo_pedido_extra,
    d.order_dtl_id                                      AS id_linha

FROM {{ ref('silver_order_dtl') }} d
LEFT JOIN {{ ref('silver_order_hdr') }} h ON d.order_id = h.order_id
WHERE
    h.order_type <> '91'
    AND DATE(d.create_ts) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY) -- Adiciona o filtro para os últimos 30 dias
ORDER BY d.create_ts