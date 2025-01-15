from typing import Optional
from snowflake.snowpark import Session
from sf_bop_data.session import get_session as snowflake_session
from fabric import Connection

class SasServer:
    def __init__(self, host: str = "lnxvsashq001", user: str = "aweaver"):
        self.host = host
        self.user = user

        self.snowflake_conn = None

    def snowflake_connect(self):
        if self.snowflake_conn:
            return
        self.snowflake_conn = snowflake_session()

    def server_conn(self):
        return Connection(
            host=self.host,
            user=self.user,

        )

    def __call__(self, cmd: str):
        with self.server_conn() as c:
            result = c.run(cmd)

        return result
        

        

    