from snowflake.snowpark import Session

def get_session(
    database: str = "sf_bidm_work_prd",
    schema: str = "sf_sb_pred",
    warehouse: str = "wh_bidm_prd"
) -> Session:
    conn_args = {
        "account": "cinfin1.east-us-2.azure",
        "user": "andrew_weaver@cinfin.com",
        "authenticator": "externalbrowser",
        "database": database,
        "schema": schema,
        "warehouse": warehouse
    }

    return Session.builder.configs(conn_args).create()