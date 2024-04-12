WITH grouped_data AS (
    SELECT
        TO_CHAR(DATE_TRUNC('day', t.transaction_date), 'YYYY-MM-DD') as Date,
        a.user_id,
        a.DAYS_SINCE_CUSTOMER_CREATION,
        a.transaction_id,
        a.order_id,
        t.refund_date,
        t.refund_reason,
        t.fraud_refund_flag,
        p.product_description as Products,
        kv_pairs.shipping_address_country_name::string as shipping_address_country_name,
        kv_pairs.identity_risk_score::string as identity_risk_score,
        kv_pairs.shipping_address_validation_match_address AS shipping_address_validation_address,
        a.SHIPPING_ADDRESS_VALIDATION_MATCH_LATITUDE,
        a.SHIPPING_ADDRESS_VALIDATION_MATCH_LONGITUDE
    FROM my_schema.customer_transactions a
    JOIN my_schema.transaction_details t ON a.transaction_id = t.transaction_id
    JOIN my_schema.product_info p ON a.order_id = p.order_id
    WHERE
        t.transaction_date >= current_date - 90
        AND t.tenant = 'TenantXYZ'
        AND a.FRAUD_DECISION = 'ACCEPT'
        AND t.PAYMENTS_DECISION = 'Settle'
)

SELECT
    distinct a.customer_id AS Customer_ID_A,
    a.Date as Date_tnx_a,
    a.DAYS_SINCE_CUSTOMER_CREATION AS Age_of_Customer_ID_A,
    a.order_id as order_id_a,
    a.Products as Products_a,
    a.shipping_address_country_name as shipping_address_country_name_a,
    a.refund_date as refund_date_a,
    a.refund_reason as refund_reason_a,
    a.fraud_refund_flag as fraud_refund_flag_a,
    b.customer_id AS Customer_ID_B,
    b.Date as Date_tnx_b,
    b.order_id as order_id_b,
    b.shipping_address_country_name as shipping_address_country_name_b,
    b.Products as Products_b,
    b.DAYS_SINCE_CUSTOMER_CREATION AS Age_of_Customer_ID_B,
    a.shipping_address_validation_address AS Validation_Address_A,
    b.shipping_address_validation_address AS Validation_Address_B,
    b.refund_date as refund_date_b,
    b.refund_reason as refund_reason_b,
    b.fraud_refund_flag as fraud_refund_flag_b,
    HAVERSINE(a.SHIPPING_ADDRESS_VALIDATION_MATCH_LATITUDE, a.SHIPPING_ADDRESS_VALIDATION_MATCH_LONGITUDE, b.SHIPPING_ADDRESS_VALIDATION_MATCH_LATITUDE, b.SHIPPING_ADDRESS_VALIDATION_MATCH_LONGITUDE) AS Distance_bw_SA
FROM
    grouped_data a
    JOIN grouped_data b ON a.customer_id < b.customer_id 
WHERE
    HAVERSINE(a.SHIPPING_ADDRESS_VALIDATION_MATCH_LATITUDE, a.SHIPPING_ADDRESS_VALIDATION_MATCH_LONGITUDE, b.SHIPPING_ADDRESS_VALIDATION_MATCH_LATITUDE, b.SHIPPING_ADDRESS_VALIDATION_MATCH_LONGITUDE) <> 0
    AND HAVERSINE(a.SHIPPING_ADDRESS_VALIDATION_MATCH_LATITUDE, a.SHIPPING_ADDRESS_VALIDATION_MATCH_LONGITUDE, b.SHIPPING_ADDRESS_VALIDATION_MATCH_LATITUDE, b.SHIPPING_ADDRESS_VALIDATION_MATCH_LONGITUDE) <= 1.0000
    AND a.shipping_address_validation_address < b.shipping_address_validation_address
ORDER BY
    Distance_bw_SA ASC
