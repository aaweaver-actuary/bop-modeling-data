-- This script sets up the necessary tables, stored procedures, and tasks 
-- for generating pre-aggregations in Snowflake.

-- A table to store user interactions for analyzing frequently used queries.
CREATE OR REPLACE TABLE query_logs (
    user_id string,
    query_id string,
    query_ts timestamp,
    index_field string,
    columns_field string,
    values_field string,
    agg_function string,
    filters string,
    result_size int
);

-- A summary table to store mappings of pre-aggregated temp tables.
CREATE OR REPLACE TABLE query_logs_summary (
    index_field string,
    columns_field string,
    values_field string,
    agg_function string,
    temp_table_name string,
    created_at timestamp
);

-- This procedure identifies popular queries and creates pre-aggregated temp tables.
CREATE OR REPLACE PROCEDURE generate_pre_aggregations()
RETURNS string
LANGUAGE JAVASCRIPT
AS
$$
    var queries = snowflake.execute(`
        SELECT 
            index_field, 
            columns_field, 
            agg_function, 
            COUNT(*) AS query_count
        FROM query_logs
        WHERE timestamp >= CURRENT_DATE - 1
        GROUP BY index_field, columns_field, agg_function
        ORDER BY query_count DESC
        LIMIT 5
    `);

    while (queries.next()) {
        var index_field = queries.getColumnValue(1);
        var columns_field = queries.getColumnValue(2);
        var agg_function = queries.getColumnValue(3);
        var temp_table_name = 'temp_' + index_field + '_' + columns_field + '_' + agg_function;

        // Create a pre-aggregated table
        snowflake.execute(`
            CREATE OR REPLACE TEMPORARY TABLE ${temp_table_name} AS
            SELECT 
                ${index_field}, 
                ${columns_field}, 
                ${agg_function}(value_field) AS aggregated_value
            FROM your_table
            GROUP BY ${index_field}, ${columns_field}
        `);

        // Log the temp table creation
        snowflake.execute(`
            INSERT INTO query_logs_summary (index_field, columns_field, agg_function, temp_table_name, created_at)
            VALUES ('${index_field}', '${columns_field}', '${agg_function}', '${temp_table_name}', CURRENT_TIMESTAMP)
        `);
    }

    return 'Pre-aggregations generated successfully.';
$$;

-- Set up a task to run the stored procedure nightly.
CREATE OR REPLACE TASK generate_aggregations_task
    WAREHOUSE = my_warehouse
    SCHEDULE = 'USING CRON 0 0 * * * UTC'
AS
    CALL generate_pre_aggregations();
