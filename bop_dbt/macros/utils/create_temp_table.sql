{%- macro create_temp_table(table_name, definition) -%}
    {%- set temp_table_name = "temp_" ~ table_name -%}
    {%- set temp_table = ref(temp_table_name) -%}
    {%- set sql = "CREATE TEMPORARY TABLE " ~ temp_table_name ~ " AS " ~ definition -%}
    {%- do run_query(sql) -%}
    {%- set temp_table = ref(temp_table_name) -%}
    {{ temp_table }}
{%- endmacro -%}