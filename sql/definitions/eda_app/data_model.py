from typing import Optional
import uuid
import datetime
from pydantic import BaseModel, Field
from snowflake.connector import SnowflakeConnection

def is_user_registered(conn: SnowflakeConnection, user_id: str) -> bool:
    query = f"""
        SELECT COUNT(*)
        FROM users
        WHERE user_id = '{user_id}';
    """
    cur = conn.cursor()
    cur.execute(query)
    result = cur.fetchone()
    return result[0] > 0

class User(BaseModel):
    user_id: str = Field(description="User ID", default="")


class Session(BaseModel):
    user_id: str = Field(description="User ID", default="")
    session_id: str = Field(description="Session ID", default=str(uuid.uuid4()))
    start_time: datetime.datetime = Field(description="Start time", default=datetime.datetime.utcnow())
    end_time: Optional[datetime.datetime] = Field(description="End time", default=None)

    def teardown(self):
        self.end_time = datetime.datetime.utcnow()

class Query(BaseModel):
    session: Session 
    index_field: str
    columns_field: str
    value_field: str
    agg_function: str
    filters: str
    result_size: int

