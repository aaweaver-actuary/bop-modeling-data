{# Implementation of a hash map using DBT to manage temporary table creation. #}

{%- macro create_hashmap(hashmap_name, key_type, value_type) -%}
    {%- set hashmap_name = "hashmap_" ~ hashmap_name -%}
    {%- set hashmap = ref(hashmap_name) -%}
    {%- set sql = "CREATE TEMPORARY TABLE " ~ hashmap_name ~ " (key " ~ key_type ~ ", value " ~ value_type ~ ")" -%}
    {%- do run_query(sql) -%}
    {%- set hashmap = ref(hashmap_name) -%}
    {{ hashmap }}
{%- endmacro -%}

{%- macro hashmap_insert(hashmap, key, value) -%}
    {%- set sql = "INSERT INTO " ~ hashmap ~ " (key, value) VALUES ('" ~ key ~ "', '" ~ value ~ "')" -%}
    {%- do run_query(sql) -%}
{%- endmacro -%}

{%- macro hashmap_get(hashmap, key) -%}
    {%- set sql = "SELECT value FROM " ~ hashmap ~ " WHERE key = '" ~ key ~ "'" -%}
    {%- set result = run_query(sql) -%}
    {%- if result.rows -%}
        {{ result.rows[0].value }}
    {%- else -%}
        {{ None }}
    {%- endif -%}
{%- endmacro -%}

{%- macro hashmap_delete(hashmap, key) -%}
    {%- set sql = "DELETE FROM " ~ hashmap ~ " WHERE key = '" ~ key ~ "'" -%}
    {%- do run_query(sql) -%}
{%- endmacro -%}

{%- macro hashmap_clear(hashmap) -%}
    {%- set sql = "DELETE FROM " ~ hashmap -%}
    {%- do run_query(sql) -%}
{%- endmacro -%}

{%- macro initialize_hashmap(hashmap) -%}
    {# Create a temp table for the hashmap (and all future maps) if the 
    temp__hashmap table does not already exist. #}
    {%- if not ref(hashmap) -%}
        {%- do create_hashmap(hashmap, "text", "text") -%}
    {%- endif -%}
    {%- set sql = "DELETE FROM " ~ hashmap -%}
    {%- do run_query(sql) -%}
{%- endmacro -%}