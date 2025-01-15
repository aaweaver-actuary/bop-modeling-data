"""Use snowpark to accomplish data loading before dbt runs."""

from snowflake.snowpark import Session
from sf_bop_data.session import get_session
from pathlib import Path

FILE_PATH = Path("C:/Users/aweaver/Downloads/")

session = get_session()

session.sql(f"PUT 'file://{FILE_PATH}' {STAGE_NAME}").collect()