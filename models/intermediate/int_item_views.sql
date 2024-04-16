select 
    item_name,
    add_to_cart_quantity,
    item_view_ts,
    price_per_unit,
    remove_from_cart_quantity,
    stay_in_cart_quantity,
    session_id
from {{ ref('base_snowflake_web__item_views') }}

