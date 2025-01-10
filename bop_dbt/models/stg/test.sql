WITH

raw AS (
    SELECT *
    FROM {{ source('sf_sb', 'eclas_gl_exposureview') }}
)

SELECT DISTINCT
    {
        'co': companycode,
        'sym': policysymbol
    } AS pol
FROM raw
