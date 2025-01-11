-- log_message macro
--
-- Description: This macro is used to log messages to a Snowflake table
-- Usage:
--    {% log_message("INFO", "This is an info message") %}
--    {% log_message("ERROR", "This is an error message", preview_data=ref('my_model')) %}
--    {% log_message("DEBUG", "This is a debug message", show_context=false, write_console=true) %}
{% macro log_message(level, message, preview_data=None, show_context=True, write_console=False) %}
    {%- _validate_level_input(level) -%}
    {%- set model_context = _get_model_context(show_context) -%}
    {%- _ensure_stream_exists_if_in_snowflake() -%}
    {%- set preview_str = _make_preview_string(preview_data) -%}
    -- Generate the SQL to insert the log into the Snowflake table
    {%- set insert_sql = _generate_insert_sql(level, message, preview_str, model_context) -%}
    {{ run_query(insert_sql) }} 
    {%- _print_to_console(message) -%}
{% endmacro %}

{%- macro _validate_level_input(log_level) -%}
    {%- set log_levels = ["DEBUG", "INFO", "WARN", "ERROR"] -%}
    {%- if level not in log_levels -%}
        {{ exceptions.raise_compiler_error("Invalid log level: " ~ level) }}
    {%- endif -%}
{%- endmacro -%}

{%- macro _ensure_stream_exists_if_in_snowflake() -%}
    -- Generate the SQL to create the stream if it doesn't already exist
    {%- set is_snowflake = target.type == "snowflake" -%}
    {%- set stream_sql -%}
        {%- if not is_snowflake -%}
            {{ exceptions.raise_compiler_error("This macro only supports Snowflake") }}
        {%- endif -%}

        CREATE STREAM IF NOT EXISTS SF_BIDM_WORK_PRD.SF_SB_PRED_DEV.DBT_LOGGING_STREAM 
            ON TABLE SF_BIDM_WORK_PRD.SF_SB_PRED_DEV.DBT_LOGGING
            SHOWING CHANGES;
    {%- endset -%}

    -- Create the stream if it doesn't already exist
    {{ run_query(stream_sql) }}
{%- endmacro -%}

{%- macro _get_model_context(show_context) -%}
    {
        "model": this.name if show_context and this else "N/A",
        "schema": this.schema if show_context and this else "N/A",
        "environment": target.name
    }
{%- endmacro -%}

{%- macro pprint_json(data, indent=2) -%}
    {{ adapter.quote(data) }}
{%- endmacro -%}

{%- macro _make_preview_string(preview_data) -%}
    -- The preview string is a JSON representation of the preview data if it exists
    -- It is used to store a snapshot of the data that was processed by the model
    -- in order to provide context for the log message if needed
    {%- set preview_str = preview_data | pprint_json if preview_data else "None" -%}
    {{ preview_str }}
{%- endmacro -%}

{%- macro _generate_insert_sql(level, message, preview_str, model_context) -%}
    -- Generate the SQL to insert the log into the Snowflake table
"""INSERT INTO analytics.logging_table (
    log_level,
    model_name,
    schema_name,
    environment,
    message,
    data_preview
) VALUES (
    '{{ level }}',
    '{{ model_context.model }}',
    '{{ model_context.schema }}',
    '{{ model_context.environment }}',
    '{{ message }}',
    {{ adapter.quote(preview_str) }}
)"""
{%- endmacro -%}

{%- macro run_query(sql) -%}
    {{ return(sql) }}
{%- endmacro -%}

{%- macro log(log_message) -%}
    {{ return(log_message) }}
{%- endmacro -%}

{%- macro _print_to_console(log_message) -%}
    {% if write_console %}
        -- Generate the log message to be printed to the console
        {%- set log_message = {
            "level": level,
            "message": message,
            "context": model_context if show_context else "Context disabled",
            "data_preview": preview_str
        } | pprint_json(indent=2) -%}

        {{ log(log_message) }}
    {% endif %}
{%- endmacro -%}
