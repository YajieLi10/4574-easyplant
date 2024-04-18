WITH ranking AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ORDER_ID
               ORDER BY ORDER_AT DESC
           ) as order_rank,
           ROW_NUMBER() OVER (
               PARTITION BY SESSION_ID
               ORDER BY ORDER_AT DESC
           ) as session_rank
    FROM {{ source('snowflake_web', 'orders') }}
)

SELECT _FIVETRAN_ID,
       PAYMENT_METHOD,
       CLIENT_NAME,
       ORDER_AT AS ORDER_TS,
       REPLACE(SHIPPING_COST, 'USD ', '') AS SHIPPING_COST,
       CAST(SESSION_ID AS STRING) AS SESSION_ID,
       STATE,
       PAYMENT_INFO,
       SHIPPING_ADDRESS,
       TAX_RATE,
       CAST(ORDER_ID AS STRING) AS ORDER_ID,
       PHONE,
       _FIVETRAN_DELETED,
       _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS
FROM ranking
WHERE 1=1
AND order_rank = 1 
AND session_rank = 1