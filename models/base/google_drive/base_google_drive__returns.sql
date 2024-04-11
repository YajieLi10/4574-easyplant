SELECT _FILE,
       _LINE,
       _MODIFIED AS _MODIFIED_TS,
       _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS,
       RETURNED_AT AS RETURED_DATE,
       ORDER_ID,
       IS_REFUNDED     
FROM {{ source('google_drive', 'returns') }}