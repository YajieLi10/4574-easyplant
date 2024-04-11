SELECT _fivetran_id,
       page_name,
       view_at AS view_at_ts,
       session_id,
       _fivetran_deleted,
       _fivetran_synced AS _fivetran_synced_ts
FROM {{ source('snowflake_web', 'page_views') }}