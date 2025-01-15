WITH

raw AS (
    SELECT *
    FROM {{ ref('stg__cf_exposureview') }}
)

SELECT 
    {{ generate_policy_key('policy') }},
    * 
FROM raw