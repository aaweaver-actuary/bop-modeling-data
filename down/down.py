import requests
from fabric import Connection
from pathlib import Path

MYLIB = Path("/sas/data/project/EG/ActShared/SmallBusiness/aw")

URLS = [
    # "https://files.pythonhosted.org/packages/26/9f/ad63fc0248c5379346306f8668cda6e2e2e9c95e01216d2b8ffd9ff037d0/typing_extensions-4.12.2-py3-none-any.whl",
    # "https://files.pythonhosted.org/packages/a8/7c/b860618c25678bbd6d1d99dbdfdf0510ccb50790099b963ff78a124b754f/pydantic_core-2.27.2-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl",
    # "https://files.pythonhosted.org/packages/78/b6/6307fbef88d9b5ee7421e68d78a9f162e0da4900bc5f5793f6d3d0e34fb8/annotated_types-0.7.0-py3-none-any.whl",
    # "https://files.pythonhosted.org/packages/58/26/82663c79010b28eddf29dcdd0ea723439535fa917fce5905885c0e9ba562/pydantic-2.10.5-py3-none-any.whl#sha256=4dd4e322dbe55472cb7ca7e73f4b63574eecccf2835ffa2af9021ce113c83c53",
    # "https://files.pythonhosted.org/packages/6b/03/2cb0e5326e19b7d877bc9c3a7ef436a30a06835b638580d1f5e21a0409ed/atpublic-5.0-py3-none-any.whl#sha256=b651dcd886666b1042d1e38158a22a4f2c267748f4e97fde94bc492a4a28a3f3",
    # "https://files.pythonhosted.org/packages/28/34/6b3ac1d80fc174812486561cf25194338151780f27e438526f9c64e16869/cryptography-44.0.0-cp39-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl",
    # "https://files.pythonhosted.org/packages/42/22/40f9162e943f86f0fc927ebc648078be87def360d9d8db346619fb97df2b/pyOpenSSL-24.3.0-py3-none-any.whl",
    # "https://files.pythonhosted.org/packages/37/52/500d72079bfb322ebdf3892180ecf3dc73c117b3a966ee8d4bb1378882b2/snowflake_connector_python-3.12.4-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl",
    # "https://files.pythonhosted.org/packages/75/3c/ec228b7325b32781081c72254dd0ef793943e853d82616e862e231909c6c/snowflake_core-1.0.2-py3-none-any.whl#sha256=55c37cf526a0d78dd3359ad96b9ecd7130bbbbc2f5a2fec77bb3da0dac2dc688",
    # "https://files.pythonhosted.org/packages/aa/8c/64f9b5ee0c3f376a733584c480b31addbf2baff7bb41f655e5e3f3719d3b/snowflake_legacy-1.0.0-py3-none-any.whl",
    # "https://files.pythonhosted.org/packages/b6/25/4cbba4da3f9b333d132680a66221d1a101309cce330fa8be38b674ceafd0/snowflake-1.0.2-py3-none-any.whl#sha256=6bb0fc70aa10234769202861ccb4b091f5e9fb1bbc61a1e708db93baa3f221f4",
    # "https://files.pythonhosted.org/packages/97/3f/c4c51c55ff8487f2e6d0e618dba917e3c3ee2caae6cf0fbb59c9b1876f2e/tzlocal-5.2-py3-none-any.whl",
    # "https://files.pythonhosted.org/packages/15/80/44286939ca215e88fa827b2aeb6fa3fd2b4a7af322485c7170d6f9fd96e0/cloudpickle-2.2.1-py3-none-any.whl",
    # "https://files.pythonhosted.org/packages/7d/d2/c7c0c999c35626463c9bcab883ef739ddacb7ff014a5f25a9bdde1dcb9e9/snowflake_snowpark_python-1.26.0-py3-none-any.whl",
    "https://files.pythonhosted.org/packages/88/ef/eb23f262cca3c0c4eb7ab1933c3b1f03d021f2c48f54763065b6f0e321be/packaging-24.2-py3-none-any.whl",
    "https://files.pythonhosted.org/packages/08/e7/ae38d7a6dfba0533684e0b2136817d667588ae3ec984c1a4e5df5eb88482/hatchling-1.27.0-py3-none-any.whl",
]

def get_filename(url):
    if url.find("#") > -1:
        return url.split("#")[0].split("/")[-1]
    else:
        return url.split("/")[-1]


def download(url):
    file = Path(get_filename(url))
    if not file.exists():
        print("we haven't already downloaded this, so here I go...")
        r = requests.get(url)

        with open(file.as_posix(), "wb") as f:
            f.write(r.content)

        print('got it')

    else:
        print("no need to re-download: we already have this file!")

    
def upload(url, c = None):
    print('checking whether the file is already uploaded...')
    file = Path(get_filename(url))
    test_grep = c.run("ls | grep \"" + file.as_posix() + "\" || echo \"NOPE NOT HERE\"")
    stdout = test_grep.stdout
    if stdout.lower().find(file.as_posix().lower()) == -1:
        print("file not found on server, so uploading it")
        result = c.put(file)
        print("uploaded!")
        print(result)

    else:
        print("file found in `ls` call to server (see above), so we are done!")

def install(url, c = None):
    print('trying to install!')
    file = get_filename(url)
    env = (MYLIB / "aw-env" / "bin" / "activate").as_posix()
    py = (MYLIB / "aw-env" / "bin" / "python3").as_posix()
    c.run(f". {env}; {py} -m pip install {file}")


def main():
    print('connecting to the server now...')
    with Connection(
        host="lnxvsashq001",
        user="aweaver",
        connect_kwargs={
            "password": "Aw37355#"
        }
    ) as c:
        for u in URLS:
            download(u)
            upload(u, c)
            install(u, c)

if __name__=="__main__":
    main()