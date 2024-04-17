WITH SESSION_ITEM_VIEWS AS (
    SELECT 
        rs.SESSION_ID,
        rs.SESSION_AT_TS,
        rs.CLIENT_ID,
        rs.IP,
        rs.OS,
        pv.PAGE_NAME,
        pv.VIEW_AT_TS,
        iv.ITEM_NAME,
        iv.ITEM_VIEW_TS,
        iv.PRICE_PER_UNIT,
        iv.ADD_TO_CART_QUANTITY,
        iv.REMOVE_FROM_CART_QUANTITY,
        iv.STAY_IN_CART_QUANTITY
    FROM {{ ref('base_snowflake_web__sessions') }} as rs
    LEFT JOIN {{ ref('base_snowflake_web__page_views') }} AS pv 
    ON rs.SESSION_ID = pv.SESSION_ID
    LEFT JOIN {{ ref('base_snowflake_web__item_views') }} AS iv 
    ON rs.SESSION_ID = iv.SESSION_ID
    WHERE pv.PAGE_NAME = 'shop_plants'
), 

SESSION_NO_ITEM_VIEWS AS (
    SELECT 
        rs.SESSION_ID,
        rs.SESSION_AT_TS,
        rs.CLIENT_ID,
        rs.IP,
        rs.OS,
        pv.PAGE_NAME,
        pv.VIEW_AT_TS,
        NULL AS ITEM_NAME,
        NULL AS ITEM_VIEW_TS,
        NULL AS PRICE_PER_UNIT,
        NULL AS ADD_TO_CART_QUANTITY,
        NULL AS REMOVE_FROM_CART_QUANTITY,
        NULL AS STAY_IN_CART_QUANTITY
    FROM {{ ref('base_snowflake_web__sessions') }} as rs
    LEFT JOIN {{ ref('base_snowflake_web__page_views') }} AS pv 
    ON rs.SESSION_ID = pv.SESSION_ID
    WHERE pv.PAGE_NAME != 'shop_plants'
)

SELECT * FROM SESSION_ITEM_VIEWS
UNION ALL
SELECT * FROM SESSION_NO_ITEM_VIEWS
ORDER BY SESSION_AT_TS, VIEW_AT_TS, ITEM_VIEW_TS
