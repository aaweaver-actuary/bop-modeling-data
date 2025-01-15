{%- macro generate_aiv_key(lob, struct) -%}
    md5(
        {{ struct }}['cfxmlid']
        {% if lob=='prop' %}
            || {{ struct }}['coverage_component_agreement_id']

        {% endif %}

    ) as aiv_key

{%- endmacro -%}