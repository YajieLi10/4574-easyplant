SELECT 
    ORDER_ID,
    PAYMENT_METHOD,
    CLIENT_NAME,
    STATE,
    PAYMENT_INFO,
    SHIPPING_ADDRESS,
    PHONE   
FROM {{ ref('base_snowflake_web__orders') }}
