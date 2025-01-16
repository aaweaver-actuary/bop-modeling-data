{%- macro generate_policy_key(struct) -%}
{%- set company_numb -%}
{{ struct }}['company_numb']
{%- endset -%}
{%- set policy_sym -%}
{{ struct }}['sym']
{%- endset -%}
{%- set policy_numb -%}
{{ struct }}['numb']
{%- endset -%}
{%- set policy_module -%}
{{ struct }}['module']
{%- endset -%}
{%- set policy_eff_date -%}
{{ struct }}['eff_date']
{%- endset -%}

{%- set eff_year -%}
YEAR({{ policy_eff_date }})
{%- endset -%}
{%- set eff_month -%}
MONTH({{ policy_eff_date }})
{%- endset -%}
{%- set eff_day -%}
DAY({{ policy_eff_date }})
{%- endset -%}

    md5(
        {{ to_padded_str(company_numb, 2) }}
        || {{ policy_sym }}
        || {{ to_padded_str(policy_numb, 7) }}
        || {{ to_padded_str(policy_module, 2) }}
        || {{ to_padded_str(eff_year, 4) }}
        || {{ to_padded_str(eff_month, 2) }}
        || {{ to_padded_str(eff_day, 2) }}
    ) as policy_key
{%- endmacro -%}
