WITH Orders_new AS (
    SELECT
        ORDER_ID,
        ORDER_TS,
        SHIPPING_COST,
        SESSION_ID,
        TAX_RATE,
        ROW_NUMBER() OVER (PARTITION BY ORDER_ID ORDER BY ORDER_TS) AS rn_1
    FROM {{ ref('base_snowflake_web__orders') }}
),
Returns_new AS (
    SELECT
        ORDER_ID,
        RETURNED_DATE,
        IS_REFUNDED,
        ROW_NUMBER() OVER (PARTITION BY ORDER_ID ORDER BY RETURNED_DATE) AS rn_2
    FROM {{ ref('base_google_drive__returns') }}
)
SELECT
    o.ORDER_ID,
    o.ORDER_TS,
    o.SHIPPING_COST,
    o.SESSION_ID,
    o.TAX_RATE,
    r.RETURNED_DATE,
    r.IS_REFUNDED
FROM Orders_new o
LEFT JOIN Returns_new r 
ON o.ORDER_ID = r.ORDER_ID
WHERE o.rn_1 = 1 AND (r.rn_2 = 1 OR r.ORDER_ID IS NULL)

