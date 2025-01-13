import streamlit as st
import pandas as pd
import snowflake.connector
import uuid
import datetime
from dataclasses import dataclass
from typing import Optional

# Snowflake connection
def get_connection():
    return snowflake.connector.connect(
        user='your_user',
        password='your_password',
        account='your_account',
        warehouse='your_warehouse',
        database='your_database',
        schema='your_schema'
    )

# Log user query
def log_query(user_id, index_field, columns_field, agg_function, filters, result_size):
    conn = get_connection()
    query_log = {
        "user_id": user_id,
        "query_id": str(uuid.uuid4()),
        "timestamp": datetime.datetime.utcnow(),
        "index_field": index_field,
        "columns_field": columns_field,
        "agg_function": agg_function,
        "filters": str(filters),
        "result_size": result_size
    }
    pd.DataFrame([query_log]).to_sql("query_logs", conn, if_exists="append", index=False)

# Check for pre-aggregated table
def check_pre_aggregation(index_field, columns_field, agg_function):
    conn = get_connection()
    query = f"""
        SELECT temp_table_name 
        FROM query_logs_summary
        WHERE index_field = '{index_field}' 
          AND columns_field = '{columns_field}'
          AND agg_function = '{agg_function}'
        ORDER BY created_at DESC
        LIMIT 1;
    """
    cur = conn.cursor()
    cur.execute(query)
    result = cur.fetchone()
    return result[0] if result else None

# Streamlit app
st.title("Pivot Table with Pre-Aggregations")

# User inputs
user_id = st.text_input("User ID", value="anonymous")
index_field = st.selectbox("Index Field", options=["field1", "field2", "field3"])
columns_field = st.selectbox("Columns Field", options=["field4", "field5"])
agg_function = st.selectbox("Aggregation Function", options=["SUM", "COUNT", "AVG"])
filters = st.text_input("Filters (optional)", value="")

# Execute query
if st.button("Run Query"):
    conn = get_connection()
    pre_agg_table = check_pre_aggregation(index_field, columns_field, agg_function)

    if pre_agg_table:
        st.write("Using pre-aggregated table!")
        query = f"SELECT * FROM {pre_agg_table}"
    else:
        st.write("Running on-the-fly aggregation...")
        query = f"""
        SELECT 
            {index_field}, 
            {columns_field}, 
            {agg_function}(value_field) AS aggregated_value
        FROM your_table
        GROUP BY {index_field}, {columns_field};
        """

    # Fetch and display data
    data = pd.read_sql(query, conn)
    st.dataframe(data)

    # Log the query
    log_query(user_id, index_field, columns_field, agg_function, filters, len(data))
