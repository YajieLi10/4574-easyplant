WITH ORDER_RETURN AS (
    SELECT
        o.ORDER_ID,
        o.ORDER_TS,
        o.SHIPPING_COST,
        o.SESSION_ID,
        o.TAX_RATE,
        r.RETURNED_DATE,
        r.IS_REFUNDED
    FROM {{ ref('base_snowflake_web__orders') }} o
    LEFT JOIN {{ ref('base_google_drive__returns') }} r
    ON o.ORDER_ID = r.ORDER_ID
),
SELECTED_ITEMVIEW AS (
    SELECT 
        ITEM_NAME,
        PRICE_PER_UNIT,
        STAY_IN_CART_QUANTITY AS QUANTITY,
        SESSION_ID
    FROM {{ ref('base_snowflake_web__item_views') }}
),
COMBINED_DATA AS (
    SELECT
        ro.ORDER_ID,
        ro.ORDER_TS,
        ro.SHIPPING_COST,
        ro.TAX_RATE,
        ro.RETURNED_DATE,
        ro.IS_REFUNDED,
        si.ITEM_NAME,
        si.PRICE_PER_UNIT,
        si.QUANTITY,
        (si.PRICE_PER_UNIT * si.QUANTITY) AS item_total
    FROM ORDER_RETURN ro
    LEFT JOIN SELECTED_ITEMVIEW si
    ON ro.SESSION_ID = si.SESSION_ID
)
SELECT
    ORDER_ID,
    SUM(QUANTITY) AS QUANTITY_TOTAL,
    TAX_RATE,
    SHIPPING_COST,  
    SUM(item_total) AS sum_item_totals, 
    SUM(item_total) * TAX_RATE AS TAX_TOTAL,
    (SUM(item_total) * (1 + TAX_RATE)) + SHIPPING_COST AS price_total, 
    RETURNED_DATE,
    IS_REFUNDED
FROM COMBINED_DATA
GROUP BY ORDER_ID, SHIPPING_COST, TAX_RATE,RETURNED_DATE, IS_REFUNDED
