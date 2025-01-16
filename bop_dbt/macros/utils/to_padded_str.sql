{%- macro to_padded_str(col, n_total) -%}
LPAD(TRY_CAST(TO_VARIANT({{ col }}) AS VARCHAR), {{ n_total }}, '0') 
{%- endmacro -%}
