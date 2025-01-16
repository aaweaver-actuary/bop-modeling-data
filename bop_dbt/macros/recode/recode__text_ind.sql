{%- macro recode__text_ind(old_column) -%}
    CASE 
        WHEN NOT IS_VARCHAR(TO_VARIANT({{ old_column }}))
            THEN TRY_TO_NUMBER({{ old_column }})
        ELSE {{ recode__text_ind__dispatch(old_column) }}
    END
{%- endmacro -%}

{%- macro recode__text_ind__dispatch(old_column) -%}
CASE
    WHEN LOWER({{ old_column }}) = 'true' THEN 1
    WHEN LOWER({{ old_column }}) = 'yes' THEN 1
    WHEN LOWER({{ old_column }}) = 't' THEN 1
    WHEN LOWER({{ old_column }}) = 'y' THEN 1
    WHEN LOWER({{ old_column }}) = '1' THEN 1
    WHEN LOWER({{ old_column }}) = '1.0' THEN 1

    WHEN LOWER({{ old_column }}) = 'false' THEN 0
    WHEN LOWER({{ old_column }}) = 'no' THEN 0
    WHEN LOWER({{ old_column }}) = 'f' THEN 0
    WHEN LOWER({{ old_column }}) = 'n' THEN 0
    WHEN LOWER({{ old_column }}) = '0' THEN 0
    WHEN LOWER({{ old_column }}) = '0.0' THEN 0

    WHEN LOWER({{ old_column }}) = 'missing' THEN 0
    ELSE 0
END
{%- endmacro -%}
