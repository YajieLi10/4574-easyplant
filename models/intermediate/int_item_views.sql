select item_name, price_per_unit, time_of_item_view, time_of_cart_add
from(
    select 
        item_name,
        count(distinct item_view_ts) as time_of_item_view,
        sum(case when add_to_cart_quantity>0 then 1 else 0 end) as time_of_cart_add
    from {{ ref('base_snowflake_web__item_views') }}
    group by item_name
) tmp
join {{ ref('base_snowflake_web__item_views') }}
using(item_name)