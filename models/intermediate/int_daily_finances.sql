WITH orders AS(

    WITH session_price AS(
        SELECT session_id,
                SUM(price_per_unit * stay_in_cart_quantity) as total_price_per_session,
        FROM {{ ref('base_snowflake_web__item_views') }} as item_views
        GROUP BY session_id)
        
    SELECT  DATE(orders.order_ts) as order_date,
            SUM(orders.shipping_cost) AS shipping_cost,
            SUM(session_price.total_price_per_session) as revenue, 
      
    FROM {{ ref('base_snowflake_web__orders') }} as orders

    LEFT JOIN session_price ON session_price.session_id = orders.session_id
    GROUP BY order_date
),

    returns AS (
    WITH priced_orders AS (
        SELECT orders.session_id, 
            orders.order_id,
            DATE(orders.order_ts) as order_date,
            orders.shipping_cost,
            orders.tax_rate,
            session_price.total_price_per_session as order_price, 
        
        FROM (
            SELECT session_id,
                    SUM(price_per_unit * stay_in_cart_quantity) as total_price_per_session,
            FROM {{ ref('base_snowflake_web__item_views') }} as item_views
            GROUP BY session_id) 
            AS session_price
        LEFT JOIN {{ ref('base_snowflake_web__orders') }} as orders ON  session_price.session_id = orders.session_id
        WHERE orders.session_id IS NOT NULL)


    SELECT returns.returned_date, SUM(priced_orders.order_price) as refund_cost
    FROM {{ ref('base_google_drive__returns') }} as returns
    LEFT JOIN  priced_orders on priced_orders.order_id = returns.order_id
    WHERE returns.is_refunded = 'yes'
    GROUP BY returns.returned_date
),

    expense AS (
        SELECT DATE AS expense_date,
        SUM(CASE WHEN expense_type = 'tech tool' THEN expense_amount_numeric ELSE NULL END) AS tech_tool_cost,
        SUM(CASE WHEN expense_type = 'hr' THEN expense_amount_numeric ELSE NULL END) AS hr_cost,
        SUM(CASE WHEN expense_type = 'warehouse' THEN expense_amount_numeric ELSE NULL END) AS warehouse_cost,
        SUM(CASE WHEN expense_type = 'other' THEN expense_amount_numeric ELSE NULL END) AS other_cost
    FROM {{ ref('base_google_drive__expenses') }}
    GROUP BY DATE
)

SELECT
    COALESCE(orders.order_date, returns.returned_date, expense.expense_date) AS cost_date,
    COALESCE(orders.shipping_cost,0) AS shipping_cost,
    COALESCE(returns.refund_cost, 0) AS refund_cost,
    COALESCE(expense.tech_tool_cost, 0) AS tech_tool_cost,
    COALESCE(expense.hr_cost, 0) AS hr_cost,
    COALESCE(expense.warehouse_cost, 0) AS warehouse_cost,
    COALESCE(expense.other_cost, 0) AS other_cost,
    COALESCE(orders.shipping_cost,0)+COALESCE(returns.refund_cost, 0)+COALESCE(expense.tech_tool_cost, 0)+COALESCE(expense.hr_cost, 0)+COALESCE(expense.warehouse_cost, 0)+COALESCE(expense.other_cost, 0) AS total_cost,
    COALESCE(orders.revenue, 0) AS revenue,
    revenue - total_cost AS profit

FROM orders
FULL JOIN expense ON expense.expense_date = orders.order_date
FULL JOIN returns ON returns.returned_date = orders.order_date

ORDER BY COST_DATE