{% macro recode__sas_date_format(date_column) -%}
    TRY_CAST(
        CONCAT(
            RIGHT({{ date_column }}, 4),
            '-',
            ARRAY_POSITION(
                upper(substring({{ date_column }}, 3, 3)),
                ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
            ),
            '-',
            left({{ date_column }}, 2)
        ) as date
    )
{% endmacro -%}

