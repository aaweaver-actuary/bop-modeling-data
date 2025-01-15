import requests
from fabric import Connection
from pathlib import Path
import webbrowser as wb
import re

MYLIB = Path("/sas/data/project/EG/ActShared/SmallBusiness/aw")
HIDE = False
SERVER_FILE = Path("/home/aweaver/snow/src/snow/sf.py")

def main():
    print('connecting to the server now...')
    with Connection(
        host="lnxvsashq001",
        user="aweaver",
        connect_kwargs={
            "password": "Aw37355#"
        }
    ) as c:
        print("Step 1:")
        rslt = c.run('./aw-env/bin/python ./snow/src/snow/sf.py', hide=HIDE, warn=True, timeout=90)
        print("Step 2:")
        sso_url = re.search("(https://login\.microsoftonline\.com/[\S]+)", rslt.stdout)

        print("Step 3:")
        if not sso_url:
            raise ValueError("Couldn't find the regex")
        print("Step 4:")
        sso_url = ssl_url.group(0)
        wb.open(sso_url)
        print("Step 5:")
        token = input("Enter the auth token from the browser: ")
        print("Step 6:")
        conn.run(f"export SNOWFLAKE_AUTH_TOKEN='{token}' && ./aw-env/bin/python {SERVER_FILE.as_posix()}")

        


if __name__=="__main__":
    main()