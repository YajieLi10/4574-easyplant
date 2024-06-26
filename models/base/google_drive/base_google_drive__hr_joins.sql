SELECT _FILE,
       _LINE,
       _MODIFIED AS _MODIFIED_TS,
       CAST(EMPLOYEE_ID AS STRING) AS EMPLOYEE_ID,
       CAST(REPLACE(HIRE_DATE, 'day  ', '') AS DATE) AS HIRE_DATE,
       NAME,
       CITY,
       ADDRESS,
       TITLE,
       ANNUAL_SALARY,
       _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS
FROM {{ source('google_drive', 'hr_joins') }}