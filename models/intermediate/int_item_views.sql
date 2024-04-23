select 
    item_name,
    count(distinct item_view_ts) as time_of_item_view,
    sum(case when add_to_cart_quantity>0 then 1 else 0 end) as time_of_cart_add,
    round(time_of_cart_add/time_of_item_view,3) as view2cart_conversion_rate
from {{ ref('base_snowflake_web__item_views') }}
group by item_name
order by view2cart_conversion_rate desc