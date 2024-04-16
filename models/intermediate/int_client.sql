WITH ranking AS(
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY ORDER_ID ORDER BY ORDER_TS) as row_n
    FROM {{ ref('base_snowflake_web__orders') }}
)

SELECT 
    ORDER_ID,
    PAYMENT_METHOD,
    CLIENT_NAME,
    STATE,
    PAYMENT_INFO,
    SHIPPING_ADDRESS,
    PHONE   
FROM ranking
WHERE 1=1
AND row_n = 1