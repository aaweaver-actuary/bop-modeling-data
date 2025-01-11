CREATE TABLE IF NOT EXISTS SF_BIDM_WORK_PRD.SF_SB_PRED_DEV.DBT_TELEMETRY (
    id BIGINT AUTOINCREMENT,
    session_id STRING,
    user_id STRING,
    query_id STRING,
    n_queries_in_session INTEGER,
    session_start_at TIMESTAMP_NTZ,
    session_current_duration INTEGER,
    log_level INT,
    model_name STRING,
    schema_name STRING,
    environment STRING,
    message STRING,
    data_preview OBJECT
);
