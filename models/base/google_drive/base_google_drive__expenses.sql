SELECT DATE,
    CASE
        WHEN expense_amount LIKE '$%' THEN CAST(REPLACE(expense_amount, '$', '') AS DECIMAL(10,2))
        ELSE CAST(expense_amount AS DECIMAL(10,2))
    END AS expense_amount_numeric,
    EXPENSE_TYPE,
    _FILE,
    _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS,
    _LINE,
    _MODIFIED AS _MODIFIED_TS
FROM {{source("google_drive", "expenses")}}
ORDER BY DATE