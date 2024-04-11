SELECT _FIVETRAN_ID,
       SESSION_ID,
       CAST(CLIENT_ID AS STRING) AS CLIENT_ID,
       SESSION_AT AS SESSION_AT_TS,
       IP,
       OS,
       _FIVETRAN_DELETED,
       _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS
FROM {{ source('snowflake_web', 'sessions') }}