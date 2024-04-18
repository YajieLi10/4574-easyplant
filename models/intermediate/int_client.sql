WITH ClientSessions AS (
    SELECT 
        s.CLIENT_ID,
        s.SESSION_ID,
        o.ORDER_ID,
        o.PAYMENT_METHOD,
        o.CLIENT_NAME,
        o.STATE,
        o.PAYMENT_INFO,
        o.SHIPPING_ADDRESS,
        o.PHONE,
        o.ORDER_TS,
        COUNT(s.SESSION_ID) OVER (PARTITION BY s.CLIENT_ID) AS session_num,
        ROW_NUMBER() OVER (PARTITION BY s.CLIENT_ID ORDER BY o.ORDER_TS DESC NULLS LAST) AS rn_latest
    FROM {{ref('base_snowflake_web__sessions')}} s
    LEFT JOIN {{ ref('base_snowflake_web__orders') }} o
    ON s.SESSION_ID = o.SESSION_ID
)
SELECT 
    CLIENT_ID,
    ORDER_ID,
    PAYMENT_METHOD,
    CLIENT_NAME,
    STATE,
    PAYMENT_INFO,
    SHIPPING_ADDRESS,
    PHONE,
    session_num,
    CASE WHEN ORDER_ID IS NULL THEN FALSE ELSE TRUE END AS IS_ORDERED
FROM ClientSessions
WHERE rn_latest = 1
ORDER BY CLIENT_ID