CREATE TABLE IF NOT EXISTS sf_bidm_work_prd.sf_sb_pred_dev.dbt_telemetry (
    id bigint AUTOINCREMENT,
    session_id string,
    user_id string,
    query_id string,
    n_queries_in_session integer,
    session_start_at timestamp_ntz,
    session_current_duration integer,
    log_level int,
    model_name string,
    schema_name string,
    environment string,
    message string,
    data_preview object
);
