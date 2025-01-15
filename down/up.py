from fabric import Connection

FILE = "snowflake-1.0.2-py3-none-any.whl"

with Connection(
    host="lnxvsashq001",
    user="aweaver",
    connect_kwargs={
        "password": "Aw37355#"
    }
) as c:
    # c.put(FILE)
    c.run('ml | grep snow')