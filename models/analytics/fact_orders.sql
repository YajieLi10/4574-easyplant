SELECT 
    *,
    CASE WHEN RETURNED_DATE IS NOT NULL THEN TRUE ELSE FALSE END as RETURN_REQUEST

FROM {{ ref('int_orders') }} 