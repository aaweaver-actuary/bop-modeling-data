{%- macro generate_quote_key(struct) -%}
{%- set numb = struct['numb'] -%}
{%- set version_numb = struct['version_numb'] -%}
    md5(
        {{ to_padded_str(numb, 7) }}
        || {{ to_padded_str(version_numb, 2) }}
    ) as quote_key
{%- endmacro -%}
